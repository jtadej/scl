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
	 * I return an array of checked out books
	 */		
/*
	array function getCheckedOutBooks( numeric userID ) {
		return variables.BookGateway.getCheckedOutBooks( arguments.userID );
		}
*/
		
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
		
	/**
	 * I check out a book for a user
	 */		
	void function checkOut( required any theBook, required any currentUser ) {
		return variables.BookGateway.checkOut( arguments.theBook, arguments.currentUser );
		}
		
	/**
	 * I check in a book for a user
	 */		
	void function checkIn( required any currentUser ) {
		return variables.BookGateway.checkIn( arguments.currentUser );
		}
	}