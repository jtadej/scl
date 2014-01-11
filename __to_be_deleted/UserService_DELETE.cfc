component accessors="true" extends="model.abstract.BaseService" {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //
	property name="UserGateway" getter="false";
	property name="Validator" getter="false";

	// ------------------------ PUBLIC METHODS ------------------------ //
	/**
	 * I return a new user
	 */		
	User function newUser() {
		return variables.UserGateway.newUser();
		}
	}