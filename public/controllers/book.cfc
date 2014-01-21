component accessors="true" extends="abstract" {
	// ------------------------ DEPENDENCY INJECTION ------------------------ //	
	property name="config" setter="true" getter="false";
	property name="imageService" setter="true" getter="false";
	property name="TokenService" setter="true" getter="false";
	property name="BookService" setter="true" getter="false";
	property name="Validator" setter="true" getter="false";
	
	// ------------------------ PUBLIC METHODS ------------------------ //
/*
	void function default( required struct rc ) {
		param name="rc.filterCriteria" default="";
	
		rc.Book = variables.BookService.newBook();
		rc.Validator = variables.BookService.getValidator( rc.Book );
		if( !StructKeyExists( rc, "result" ) ) rc.result = rc.Validator.newResult();
		
		rc.context = "bookSearch";
		
		rc.sessionName = variables.config.session.token_name;
		rc.token = variables.TokenService.generate();
		
		rc.intThumbnailSize = variables.config.display.thumbnail_size;
		rc.objImageService = variables.imageService;
		
		rc.arrCheckedOutBooks = rc.currentUser.getBooks();
		rc.intAvailableBooks = rc.currentUser.getNumBooksAllowed() - ArrayLen( rc.arrCheckedOutBooks );
		}
*/
		
	void function search( required struct rc ) {
		param name="rc.barcode" default="";
		param name="rc.token" default="";

		if ( variables.TokenService.check( rc.token ) ) {
			rc.results = variables.BookService.getBooks( rc.filterCriteria, false );
			if ( ArrayLen( rc.results ) ) {
				variables.fw.redirect( "main", "results" );
				}
			else {
				rc.result = variables.Validator.newResult();
				var message = "No books found for the following criteria: " & rc.filterCriteria & ".";
				rc.result.setErrorMessage( message );
				variables.fw.redirect( "main", "result" );
				}
			}
		else {
			rc.result = variables.Validator.newResult();
			var message = "Tokens do not match!";
			rc.result.setErrorMessage( message );
			variables.fw.redirect( "main", "result" );
			}
		}
		
	void function update( required struct rc ) {
		param name="rc.barcode" default="";
		param name="rc.token" default="";
		
		if ( variables.TokenService.check( rc.token ) ) {
			if ( rc.barcode EQ rc.CurrentUser.getBarcode() ) {
				variables.fw.redirect( "security/logout" );
				}
			else {
				rc.result = variables.BookService.processBook( rc ); 
				variables.fw.redirect( "main", "result" );
				}
			}
		else {
			rc.result = variables.Validator.newResult();
			var message = "Tokens do not match!";
			rc.result.setErrorMessage( message );
			variables.fw.redirect( "main", "result" );
			}
		}
		
	void function processBook( required struct rc ) {
		rc.result = variables.BookService.processBook( rc ); 
		variables.fw.redirect( "main", "result" );
		}
	}