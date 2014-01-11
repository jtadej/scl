component accessors="true" extends="abstract" {
	// ------------------------ DEPENDENCY INJECTION ------------------------ //	
	property name="TokenService" setter="true" getter="false";
	property name="BookService" setter="true" getter="false";
	property name="Validator" setter="true" getter="false";
	
	// ------------------------ PUBLIC METHODS ------------------------ //
	void function update( required struct rc ) {
		param name="rc.barcode" default="";
		param name="rc.token" default="";
		
		if ( variables.TokenService.check( rc.token ) ) {
			rc.result = variables.BookService.processBook( rc ); 
			variables.fw.redirect( "main", "result" );
			}
		else {
			rc.result = variables.Validator.newResult();
			var message = "Tokens do not match!";
			rc.result.setErrorMessage( message );
			variables.fw.redirect( "main", "result" );
			}
		}
	}