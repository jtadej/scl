component accessors="true" {
	// ------------------------ PROPERTIES ------------------------ //	
	property name="id";
	property name="barcode";
	property name="username";
	property name="password";
	property name="firstName";
	property name="lastName";
	property name="numBooksAllowed";
	property name="role";
	
	// ------------------------ CONSTRUCTOR ------------------------ //
	/**
	 * I initialise this component
	 */		
	User function init( any collection ) {
		setId( arguments.collection.id );
		setBarcode( arguments.collection.barcode );
		setUsername( arguments.collection.username );
		setPassword( arguments.collection.password );
		setFirstName( arguments.collection.first_name );
		setLastName( arguments.collection.last_name );
		setNumBooksAllowed( arguments.collection.num_books_allowed );
		setRole( arguments.collection.role );
		
		return this;
		}	


	// ------------------------ PUBLIC METHODS ------------------------ //
	/**
	 * I return true if the user is persisted
	 */	
	boolean function isPersisted() {
		return !IsNull( variables.id );
		}
		
	string function getName() {
		return variables.firstName & ' ' & variables.lastName;
		}

	/**
	* I override the implicit setter to include hashing of the password
	*/
	string function setPassword( required password ){
		if( arguments.password != "" ){
			variables.password = arguments.password;
			// to help prevent rainbow attacks hash several times
			for ( var i=0; i<50; i++ ) variables.password = Hash( variables.password, "SHA-256" );
			}
		}	
	}