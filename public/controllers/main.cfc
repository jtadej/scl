component accessors="true" extends="abstract" {
	// ------------------------ DEPENDENCY INJECTION ------------------------ //	
	property name="config" setter="true" getter="false";
	property name="BookService" setter="true" getter="false";
	property name="imageService" setter="true" getter="false";
	property name="TokenService" setter="true" getter="false";
	
	void function default( required struct rc ) {
		rc.Book = variables.BookService.newBook();
		rc.Validator = variables.BookService.getValidator( rc.Book );
		if( !StructKeyExists( rc, "result" ) ) rc.result = rc.Validator.newResult();
		
		rc.context = "bookUpdate";
		
		rc.sessionName = variables.config.session.token_name;
		rc.token = variables.TokenService.generate();
		
		rc.intThumbnailSize = variables.config.display.thumbnail_size;
		rc.objImageService = variables.imageService;
		rc.arrCheckedOutBooks = variables.BookService.getCheckedOutBooks( Val( rc.currentUser.getId() ) );
		rc.intAvailableBooks = rc.currentUser.getNumBooksAllowed() - ArrayLen( rc.arrCheckedOutBooks );
		}
	}