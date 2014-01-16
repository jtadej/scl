component accessors="true"{

	// ------------------------ DEPENDENCY INJECTION ------------------------ //	
	property name="SecurityService" setter="true" getter="false";

	
	void function init( required any fw ) {
		variables.fw = fw;
		}
	
	void function before( required struct rc ) {
		rc.isallowed = variables.SecurityService.isAllowed( variables.fw.getFullyQualifiedAction() );
		if ( !rc.isallowed ) {
			variables.fw.redirect( "security" );
			} 
		else {
			rc.CurrentUser = variables.SecurityService.getCurrentUser();
			}
		}

	void function default( required struct rc ) {
		param name="rc.title" default="";
		}
	}