component accessors="true" extends="model.abstract.BaseGateway" {
	// ------------------------ DEPENDENCY INJECTION ------------------------ //
	property name="config" getter="false";
	property name="DBService" getter="false";

	// ------------------------ PUBLIC METHODS ------------------------ //
	/**
	 * I return a user matching an id
	 */		
	User function getUser( required numeric userid ){
		return get( "User", arguments.userid );
		}
		
	/**
	 * I return a new user
	 */		
	User function newUser() {
		return new( "User" );
		}

	/**
	 * I return a user matching a email address and password
	 */	
	User function getUserByCredentials( required User theUser ) {
		var results = '';
		
		if ( arguments.theUser.getBarcode() NEQ '' ) {
			results = variables.DBService.get( variables.config.mysql.schema & '.users' , [ [ 'barcode', '=', arguments.theUser.getBarcode() ] ] );
			}
		else {
			results = variables.DBService.get( variables.config.mysql.schema & '.users' , [ [ 'username', '=', arguments.theUser.getUsername() ], [ 'password', '=', arguments.theUser.getPassword(), 'and' ] ] );
			}
		if ( isNumeric( results.results().id ) ) { 
			var User = getUser( results.results().id );
			}
		
		// var User = ORMExecuteQuery( "from users where barcode=:barcode", { barcode=arguments.theUser.getBarcode() }, true );
		if ( IsNull( local.User ) ) local.User = new( "User" );
		return local.User;
		}
	}