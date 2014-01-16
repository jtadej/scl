component accessors="true" extends="abstract" {
	// ------------------------ DEPENDENCY INJECTION ------------------------ //	
	property name="config" setter="true" getter="false";
	property name="BookService" setter="true" getter="false";
	property name="TokenService" setter="true" getter="false";
	
	void function default( required struct rc ) {
		param name="rc.filterCriteria" default="";
		
		rc.Book = variables.BookService.newBook();
		rc.Validator = variables.BookService.getValidator( rc.Book );
		if( !StructKeyExists( rc, "result" ) ) rc.result = rc.Validator.newResult();
		
		rc.context = "bookUpdate";
		
		rc.sessionName = variables.config.session.token_name;
		rc.token = variables.TokenService.generate();
		
		rc.arrCheckedOutBooks = rc.currentUser.getBooks();
		rc.intAvailableBooks = rc.currentUser.getNumBooksAllowed() - ArrayLen( rc.arrCheckedOutBooks );
		}
	}