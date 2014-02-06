component accessors="true" {
	// ------------------------ DEPENDENCY INJECTION ------------------------ //	
	property name="config" setter="true" getter="false";
	property name="SecurityService" setter="true" getter="false";
	property name="UserService" setter="true" getter="false";
	property name="TokenService" setter="true" getter="false";
	property name="Validator" setter="true" getter="false";
	
	// ------------------------ PUBLIC METHODS ------------------------ //
	void function init( required any fw ) {
		variables.fw = arguments.fw;
		}
	
	void function default( required struct rc ) {
		param name="rc.context" default="login";
		rc.loggedin = variables.SecurityService.hasCurrentUser();
		
		if ( rc.loggedin ) {
			variables.fw.redirect( "main" );
			}
		else {
			rc.User = variables.UserService.newUser();
			rc.Validator = variables.UserService.getValidator( rc.User );
			if( !StructKeyExists( rc, "result" ) ) rc.result = rc.Validator.newResult();
			rc.sessionName = variables.config.session.token_name;
			rc.token = variables.TokenService.generate();
			}
		}
		
	void function login( required struct rc ){
		param name="rc.barcode" default="";
		param name="rc.username" default="";
		param name="rc.password" default="";
		param name="rc.token" default="";

		var redirect = "security" & ( ( rc.context EQ 'loginFull' ) ? "?context=" & rc.context : "" );
		
		if ( variables.TokenService.check( rc.token ) ) {
			rc.result = variables.SecurityService.loginUser( rc );
			if( rc.result.getIsSuccess() ) variables.fw.redirect( "main", "result" );
			else variables.fw.redirect( local.redirect, "result" );
			}
		else {
			rc.result = variables.Validator.newResult();
			var message = "Tokens do not match!";
			rc.result.setErrorMessage( message );
			variables.fw.redirect( local.redirect, "result" );
			}
		}
		
	void function logout( required struct rc ){
		rc.result = variables.SecurityService.deleteCurrentUser();
		variables.fw.redirect( "security", "result" );
		}
	}