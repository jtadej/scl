component accessors="true" extends="model.abstract.BaseService" {
	// ------------------------ DEPENDENCY INJECTION ------------------------ //
	property name="BookGateway" getter="false";
	property name="StudentGateway" getter="false";
	property name="StudentService" getter="false";
	property name="Validator" getter="false";
	
	// ------------------------ PUBLIC METHODS ------------------------ //
	/**
	 * I return a new book
	 */		
	Book function newBook() {
		return variables.BookGateway.newBook();
		}
		
	/**
	 * I return a book matching an id
	 */		
	Book function getBook( required userid ){
		return variables.BookGateway.getBook( Val( arguments.userid ) );
		}

	/**
	 * I return books matching passed in criteria
	 */		
	array function getBooks( string filterCriteria, boolean checkedOut ) {
		param name="arguments.properties.filterCriteria" default="";

		return variables.BookGateway.getBooks( filterCriteria, checkedOut );
		}
				
	/**
	 * I return an array of checked out books
	 */		
	struct function processBook( required struct properties ) {
		param name="arguments.properties.id" default="";
		
		local.defaultCode = ( StructKeyExists( arguments.properties, 'barcode' ) ) ? arguments.properties.barcode : '';
		
		param name="arguments.properties.isbn10" default="#local.defaultCode#";
		param name="arguments.properties.isbn13" default="#local.defaultCode#";
		param name="arguments.properties.upc" default="#local.defaultCode#";

		local.result = variables.Validator.newResult();
		local.currentUser = arguments.properties.currentUser;

		if ( isNumeric( arguments.properties.id ) ) {
			local.Book = getBook( arguments.properties.id );
			}
		else {
			local.Book = variables.BookGateway.newBook();
			populate( local.Book, arguments.properties );
			
			local.Book = variables.BookGateway.findBook( local.Book );
			}
		
		if ( local.Book.isPersisted() ) {
			if ( local.Book.isCheckedOut() ) {
				// check if currentUser has book
				if ( local.currentUser.hasBook( local.Book ) ) {
					// if so, return it
					transaction {
						local.currentUser.checkInBook( local.Book );
						local.Book = variables.BookGateway.saveBook( local.Book );
						local.currentUser = variables.StudentGateway.saveStudent( local.currentUser );
						if ( local.currentUser.isPersisted() AND local.Book.isPersisted() ) {
							local.result.setSuccessMessage( "The book has been successfully checked in." );
							}
						else {
							local.result.setErrorMessage( "The book was unable to be checked in." );
							}
						}
					}
				else {
					// if not, return message the book is already checked out
					local.message = "The book is already checked out.";
					local.result.setErrorMessage( local.message );
					}
				}
			else {
				// check out the book
				if ( local.currentUser.numOfBooksCheckedOut() LT local.currentUser.getNumBooksAllowed() ) {
					transaction {
						local.currentUser.checkOutBook( local.Book );
						local.Book = variables.BookGateway.saveBook( local.Book );
						local.currentUser = variables.StudentGateway.saveStudent( local.currentUser );
						if ( local.currentUser.isPersisted() AND local.Book.isPersisted() ) {
							local.result.setSuccessMessage( "The book has been successfully checked out." );
							}
						else {
							local.result.setErrorMessage( "The book was unable to be checked out." );
							}
						}
					}
				else {
					local.message = "You have checked out your maximum allowed books.";
					local.result.setErrorMessage( local.message );
					}
				}
			}
		else {
			// set message stating book does not exist
			local.message = "Sorry, there is no book with that barcode.";
			local.result.setErrorMessage( local.message );
			}
		return local.result;
		}
	}