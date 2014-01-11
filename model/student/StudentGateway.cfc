component accessors="true" extends="model.abstract.BaseGateway" {
	// ------------------------ DEPENDENCY INJECTION ------------------------ //
	property name="config" getter="false";
	property name="DBService" getter="false";

	// ------------------------ PUBLIC METHODS ------------------------ //
	/**
	 * I return a Student matching an id
	 */		
	Student function getStudent( required numeric userid ){
		return get( "Student", arguments.userid );
		}
		
	/**
	 * I return a new student
	 */		
	Student function newStudent() {
		return new( "Student" );
		}

	/**
	 * I return the number of books checked out
	 */		
	numeric function numCheckedOut( numeric userId ) {
		local.results = variables.DBService.get( variables.config.mysql.schema & '.checked_out' , [ [ 'user_id', '=', arguments.userId ] ] );

		return local.results.count();
		}
		
	/**
	 * I return a user matching a email address and password
	 */	
	Student function getStudentByCredentials( required Student theStudent ) {
		var results = '';
		
		if ( arguments.theStudent.getBarcode() NEQ '' ) {
			results = variables.DBService.get( variables.config.mysql.schema & '.users' , [ [ 'barcode', '=', arguments.theStudent.getBarcode() ] ] );
			}
		else {
			results = variables.DBService.get( variables.config.mysql.schema & '.users' , [ [ 'username', '=', arguments.theStudent.getUsername() ], [ 'password', '=', arguments.theStudent.getPassword(), 'and' ] ] );
			}
		if ( isNumeric( results.results().id ) ) { 
			var Student = getStudent( results.results().id );
			}
		
		// var User = ORMExecuteQuery( "from users where barcode=:barcode", { barcode=arguments.theUser.getBarcode() }, true );
		if ( IsNull( local.Student ) ) local.Student = new( "Student" );
		return local.Student;
		}
	}