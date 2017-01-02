/*
 * generated by Xtext 2.10.0
 */
package br.ufpe.cin.dsoa.ide.scoping

import br.ufpe.cin.dsoa.ide.dsoa.Comparison
import br.ufpe.cin.dsoa.ide.dsoa.DsoaPackage
import br.ufpe.cin.dsoa.ide.dsoa.Specification
import br.ufpe.cin.dsoa.ide.dsoa.Unit
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.scoping.Scopes
import br.ufpe.cin.dsoa.ide.dsoa.Metric

/**
 * This class contains custom scoping description.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#scoping
 * on how and when to use it.
 */
class DsoaScopeProvider extends AbstractDsoaScopeProvider {	
	override getScope(EObject context, EReference reference) {
		if (context instanceof Comparison && reference == DsoaPackage.Literals.COMPARISON__UNIT) {
			val root = EcoreUtil2.getRootContainer(context)
			if (root != null) {
				val specification = root as Specification
				if (specification.library != null) {
					Scopes.scopeFor(
						EcoreUtil2.getAllContentsOfType(specification.library, typeof(Unit))
					)
				}
			}
		} else if (context instanceof Comparison && reference == DsoaPackage.Literals.COMPARISON__METRIC) {
			val root = EcoreUtil2.getRootContainer(context)
			if (root != null) {
				val specification = root as Specification
				if (specification.library != null) {
					Scopes.scopeFor(
						EcoreUtil2.getAllContentsOfType(specification.library, typeof(Metric))
					)
				}
			}				
		} else {
			super.getScope(context, reference)
		}
	}	
}