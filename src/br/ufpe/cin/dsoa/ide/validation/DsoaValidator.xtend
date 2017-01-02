/*
 * generated by Xtext 2.10.0
 */
package br.ufpe.cin.dsoa.ide.validation

import br.ufpe.cin.dsoa.ide.dsoa.DsoaPackage
import br.ufpe.cin.dsoa.ide.dsoa.Multiplicity
import org.eclipse.xtext.validation.Check

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class DsoaValidator extends AbstractDsoaValidator {
	@Check
	def checkUpperIsGreaterThanOrEqualToUpper(Multiplicity multiplicity) {
		if (multiplicity.upper < multiplicity.lower.value) {
			error("Upper must be greater than or equal to lower", DsoaPackage.Literals.MULTIPLICITY__UPPER) 
			
		}
	}	
	
//	public static val INVALID_NAME = 'invalidName'
//
//	@Check
//	def checkGreetingStartsWithCapital(Greeting greeting) {
//		if (!Character.isUpperCase(greeting.name.charAt(0))) {
//			warning('Name should start with a capital', 
//					DsoaPackage.Literals.GREETING__NAME,
//					INVALID_NAME)
//		}
//	}	
}