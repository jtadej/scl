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
	 * I save a student
	 */	
	Student function saveStudent( required Student theStudent ){
		return save( arguments.theStudent );
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
		local.Student = '';
		
		if ( arguments.theStudent.getBarcode() NEQ '' ) {
			local.Student = ORMExecuteQuery( "from User where barcode=:barcode", { barcode = arguments.theStudent.getBarcode() }, true );
			}
		else {
			local.Student = ORMExecuteQuery( "from User where username=:username and password=:password", { username = arguments.theStudent.getUsername(), password = arguments.theStudent.getPassword() }, true);
			}

		if ( IsNull( local.Student ) ) local.Student = new( "Student" );

		return local.Student;
		}
	}