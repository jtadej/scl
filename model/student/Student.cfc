component accessors="true" persistent="true" table="users" cachetype="transactional" output="false" extends="model.user.User" {
	// ------------------------ PROPERTIES ------------------------ //	
	property name="numBooksAllowed" column="num_books_allowed" ormtype="integer" length="11";
	property name="books"	type="array" fieldtype="one-to-many" cfc="model.book.Book" singularname="book" linktable="checked_out" fkcolumn="user_id" inversejoincolumn="book_id" lazy="false" cascade="save-update";
	
	// ------------------------ PUBLIC METHODS ------------------------ //
	/**
	 * I return the number of books a user has checked out
	 */	
	public numeric function numOfBooksCheckedOut() {
		return ArrayLen( variables.books );
		} 
	 
	/**
	 * I overried the getBooks function to ensure ordering by the checked out timestamp
	 * Documents in the following link:
	 * http://cfsimplicity.com/70/coldfusion-orm-quirks-ordering-one-to-many-children-via-a-link-table
	 */	
	public array function getBooks(){
  	return ORMGetSession().createFilter( variables.books, "order by checkedOutTimestamp").list();
		}
	
	/**
	 * I remove a book from the books property
	 */	
	public void function checkInBook( required any theBook ) {
		removeBook( arguments.theBook );
		arguments.theBook.setCheckedOut( false );
		arguments.theBook.setCheckedOutTimestamp( JavaCast( "null", "" ) );
		}
		
	/**
	 * I add a book to the books property
	 */	
	public void function checkOutBook( required any theBook ) {
		addBook( arguments.theBook );
		arguments.theBook.setCheckedOut( true );
		arguments.theBook.setCheckedOutTimestamp( Now() );
		}
	}