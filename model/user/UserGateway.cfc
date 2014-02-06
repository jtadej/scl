component accessors="true" extends="model.abstract.BaseGateway" {
	// ------------------------ DEPENDENCY INJECTION ------------------------ //
	property name="config" getter="false";


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
	 * I save a user
	 */	
	User function saveUser( required User theUser ){
		return save( arguments.theUser );
		}
		
	/**
	 * I return a user matching a email address and password
	 */	
	User function getUserByCredentials( required User theUser ) {
		local.User = '';
		
		if ( arguments.theUser.getBarcode() NEQ '' ) {
			local.User = ORMExecuteQuery( "from User where barcode=:barcode", { barcode = arguments.theUser.getBarcode() }, true );
			}
		else {
			local.User = ORMExecuteQuery( "from User where username=:username and password=:password", { username = arguments.theUser.getUsername(), password = arguments.theUser.getPassword() }, true);
			}

		if ( IsNull( local.User ) ) local.User = new( "User" );

		return local.User;
		}
	}