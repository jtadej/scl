component accessors="true" extends="model.abstract.BaseService" {
	// ------------------------ DEPENDENCY INJECTION ------------------------ //
	property name="BookGateway" getter="false";
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
	 * I return an array of checked out books
	 */		
	array function getCheckedOutBooks( numeric userID ) {
		return variables.BookGateway.getCheckedOutBooks( arguments.userID );
		}
		
	/**
	 * I return an array of checked out books
	 */		
	struct function processBook( required struct properties ) {
		param name="arguments.properties.isbn10" default="#arguments.properties.barcode#";
		param name="arguments.properties.isbn13" default="#arguments.properties.barcode#";
		param name="arguments.properties.upc" default="#arguments.properties.barcode#";

		local.result = variables.Validator.newResult();
		local.currentUser = arguments.properties.currentUser;

		local.Book = variables.BookGateway.newBook();
		populate( local.Book, arguments.properties );
		
		local.Book = variables.BookGateway.findBook( local.Book );
		
		if ( local.Book.isPersisted() ) {
			if ( isCheckedOut( local.Book.getId() ) ) {
				// check if currentUser has book
				if ( isCheckedOut( local.Book.getId(), local.currentUser.getId() ) ) {
					// if so, return it
					checkIn( local.Book.getId(), local.currentUser.getId() );
					local.message = "The book has been successfully checked in.";
					local.result.setErrorMessage( local.message );
					}
				else {
					// if not, return message the book is already checked out
					local.message = "The book is already checked out.";
					local.result.setErrorMessage( local.message );
					}
				}
			else {
				// check out the book
				if ( variables.StudentService.numCheckedOut( local.currentUser.getId() ) LT local.currentUser.getNumBooksAllowed() ) {
					checkOut( local.Book.getId(), local.currentUser.getId() );
					local.message = "The book has been successfully checked out.";
					local.result.setErrorMessage( local.message );
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
		
	/**
	 * I return true if the book is checked out
	 */		
	boolean function isCheckedOut( required numeric bookId, numeric userId ) {
		param name="arguments.userId" default="0";

		return variables.BookGateway.isCheckedOut( arguments.bookId, arguments.userId );
		}
	
	/**
	 * I check out a book for a user
	 */		
	void function checkOut( required numeric bookId, required numeric userId ) {
		return variables.BookGateway.checkOut( arguments.bookId, arguments.userId );
		}
		
	/**
	 * I check in a book for a user
	 */		
	void function checkIn( required numeric bookId, required numeric userId ) {
		return variables.BookGateway.checkIn( arguments.bookId, arguments.userId );
		}
	}