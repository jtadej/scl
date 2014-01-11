component accessors="true" extends="model.abstract.BaseService" {
	// ------------------------ DEPENDENCY INJECTION ------------------------ //	
	property name="config" getter="false";
	property name="SecurityService" getter="false";
	
	string function generate() {
		variables.SecurityService.getCurrentStorage()[ variables.config.session.token_name ] = Hash( CreateUUID(), 'MD5' );
		return variables.SecurityService.getCurrentStorage()[ variables.config.session.token_name ];
		}
		
	boolean function check( required string token = '' ) {
		LOCAL.tokenName = variables.config.session.token_name;

		if ( StructKeyExists( variables.SecurityService.getCurrentStorage(), LOCAL.tokenName ) AND ARGUMENTS.token EQ variables.SecurityService.getCurrentStorage()[ variables.config.session.token_name ] ) {
			StructDelete( variables.SecurityService.getCurrentStorage(), LOCAL.tokenName );
			return true;
			}
		
		return false;
		}
	}