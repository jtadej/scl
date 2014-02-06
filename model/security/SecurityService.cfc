component accessors="true" extends="model.abstract.BaseService" {
	
	// ------------------------ DEPENDENCY INJECTION ------------------------ //	
	property name="config" getter="false";
	property name="UserGateway" getter="false";

	variables.userkey = "userid";

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I return the current storage mechanism
	 */		
	function getCurrentStorage() { 
		return session;
		}

	/**
	 * I delete the current user from the session
	 */	
	struct function deleteCurrentUser(){
		var result = variables.Validator.newResult();
		if( hasCurrentUser() ){
			StructDelete( getCurrentStorage(), variables.userkey );
			result.setSuccessMessage( "You have been logged out." );	
		}else{
			result.setErrorMessage( "You are not logged in." );
		}
		return result;
	}
	
	function getCurrentUser() {
		if ( hasCurrentUser() ) {
			var map = getCurrentStorage();
			var userkey = map[ variables.userkey ];
			return variables.UserGateway.getUser( userkey );
			}
		}

	/**
	 * I return true if the session has a user
	 */	
	boolean function hasCurrentUser() {
		return StructKeyExists( getCurrentStorage(), variables.userkey );
		}
	
	/**
	 * I return true if the user is permitted access to a FW/1 action
	 */		
	boolean function isAllowed( required string action, string whitelist ) {
		param name="arguments.whitelist" default=variables.config.security.whitelist; 
		// user is not logged in
		if( !hasCurrentUser() ) {
			// if the requested action is in the whitelist allow access
			for ( var unsecured in ListToArray( arguments.whitelist ) ){
				if( ReFindNoCase( unsecured, arguments.action ) ) return true;
				}
		// user is logged in so allow access to requested action 
			}
		else if( hasCurrentUser() ) {
			return true;
			}
		// previous conditions not met so deny access to requested action
		return false;
		}	
		
	/**
	 * I verify and login a user
	 */	
	struct function loginUser( required struct properties ){
		param name="arguments.properties.barcode" default="";
		param name="arguments.properties.username" default="";
		param name="arguments.properties.password" default="";
		
		var isAdmin = ( Find( "admin:", arguments.properties.action ) ) ? true : false;

		var User = variables.UserGateway.newUser();
		populate( User, arguments.properties );
		
		var result = variables.Validator.validate( theObject=User, context=arguments.properties.context );

		if ( result.getIsSuccess() ) {
			User = variables.UserGateway.getUserByCredentials( User );
			
			var isAllowed = ( ( isAdmin AND ( User.isAdmin() OR User.isTeacher() ) ) 
										 OR ( NOT isAdmin AND User.isStudent() ) ) ? true : false;

			if ( User.isPersisted() ) {
				if ( isAllowed ) {
					setCurrentUser( User );
					}
				else {
					var message = "Sorry, you do not have permission to log into this application.";
					result.setErrorMessage( message );
					}
				}
			else {
				var message = "Sorry, your login details have not been recognised.";
				result.setErrorMessage( message );
				}
			}
		return result;
		}	

	/**
	 * I add a user to the session
	 */		
	void function setCurrentUser( required any theUser ){
		getCurrentStorage()[ variables.userkey ] = arguments.theUser.getID();
		}
	}