# dsoa-repository

Sintaxe concreta

```
qosLibrary Biblioteca

  dimension Time
    unit Second
    unit Minute is Second * 60
    unit MilliSecond is Second / 1000
  end

  category Performance
    attribute ResponseTime
      metric AverageResponseTime is Time
      metric MaxResponseTime is Time
    end
  end

  category Realiability
    attribute Availability
      metric MeanAvailability
      metric MTBF is Time
    end
  end
end
--------------------------------------------------------------------

application HomebrokerApplicationSample
    Interface InformationProvider
      Double getCotation(String stockId)
    end

    Interface Homebroker
      Interger getCurrentPrice(String stockId)
      Double priceAlert(String address, String stockId, Double lowerThreshold, Double higherThreshold)
      void schedulingOrder(String investorCode, String stockId, Interger quantity, Double orderPrice, Double lowerThreshold, Double higherThreshold)
    end

    component HomebrokerBB
        requires
            infoProviderService : InformationProvider constrained by
              //'contraint' <QoSMetric> <expression> ['on' OperataionList]?
              contraint Availability > 80
              contraint AverageResponseTime <= 1 Second on getCotation
            end

            homebrokerService : Homebroker constrained by
              contraint MeanAvailability > 75
              contraint AverageResponseTime <= 2 Second and MaxResponseTime < 500 MilliSecond on priceAlert
            end
        end

        provides
          homebrokerBBService : Homebroker constrained by
            contraint MaxResponseTime < 10 Second on schedulingOrder, getCurrentPrice
          end
        end
    end
end

--------------------------------------------------------------------------------------------------

eventLibray EventDomain
  event DsoaEvent
  	metadata
      //<Type> <ID> ('required')?
  		String id required
  		String source required
  		Long timestamp required
  	end
  end

  event InvocationEvent < DsoaEvent
  	data
  		String consumerId
  		String serviceId required
  		String operationName
  		Long requestTimestamp required
  		Long responseTimestamprequired
  		Boolean success
  		String exceptionMessage
  		Map parameterTypes
  		Map parameterValues
  		String returnType
  		Object returnValue
  	end
  end

  event BindEvent < DsoaEvent
  	data
  		String consumerId required
  		String serviceId required
  		String serviceInterface
  	end
  end

  event UnbindEvent < DsoaEvent
  	data
  		String consumerId required
  		String serviceId required
  		String serviceInterface
  	end
  end

  event AvgResponseTimeEvent < DsoaEvent
  	data do
  		Double value required
  	end
  end

  agent ResponseTimeAgent
    inputEvent InvocationEvent i
    outputEvent ResponseTimeEvent e

    derivationExpressions
  		e.metadata.id = generateId()  // built in
  		e.metadata.timestamp = generateTimestamp() // built in

  		e.data.consumerId = i.data.consumerId
  		e.data.serviceId = i.data.serviceId
  		e.data.operationName = i.data.operationName
  		e.data.value = i.data.responseTime - i.data.requestTime
    end
  end

  agent AvgResponseTimeAgent
    //'inputEvent' <eventType> <id>
    //'outputEvent' <eventType> <id>

    inputEvent ResponseTimeEvent i
  	outputEvent AvgResponseTimeEvent e
  	window Lenght(10)
    //apenas input events entram no context
  	context [i.data.consumerId, i.data.serviceId, i.data.operationName]

  	derivationExpressions
  		e.metadata.id = generateId()
  		e.metadata.timestamp = generateTimestamp()

  		e.data.consumerId = i.data.consumerId
  		e.data.serviceId = i.data.serviceId
  		e.data.operationName = i.data.operationName
  		e.data.value = avg(i.data.responseTime - i.data.requestTime)
  	end
  end
end
```
