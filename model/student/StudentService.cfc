component accessors="true" extends="model.abstract.BaseService" {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //
	property name="StudentGateway" getter="false";
	property name="Validator" getter="false";

	// ------------------------ PUBLIC METHODS ------------------------ //
	/**
	 * I return a new student
	 */		
	Student function newStudent() {
		return variables.StudentGateway.newStudent();
		}
		
	/**
	 * I return the number of books checked out
	 */		
	numeric function numCheckedOut( numeric userId ) {
		return variables.StudentGateway.numCheckedOut( arguments.userId );
		}
	}