component accessors="true" persistent="true" table="users" cachetype="transactional" output="false" extends="model.user.User" {
	// ------------------------ PROPERTIES ------------------------ //	
	property name="numBooksAllowed" column="num_books_allowed" ormtype="integer" length="11";
	property name="books"	type="array" fieldtype="one-to-many" cfc="model.book.Book" singularname="book" linktable="checked_out" fkcolumn="user_id" inversejoincolumn="book_id" lazy="false" cascade="save-update";
	
	// ------------------------ PUBLIC METHODS ------------------------ //
	/**
	 * I return true if the user has book passed in
	 */	
	public numeric function numOfBooksCheckedOut() {
		return ArrayLen( variables.books );
		} 
	 
	public boolean function hasBook( required any theBook ) {
		local.found = ArrayFind( variables.books, arguments.theBook );
		
		if ( local.found ) {
			return true;
			}
		
		return false;
		}
		
	public void function checkInBook( required any theBook ) {
		removeBook( arguments.theBook );
		arguments.theBook.setCheckedOut( false );
		arguments.theBook.setCheckedOutTimestamp( JavaCast( "null", "" ) );
		}
		
	public void function checkOutBook( required any theBook ) {
		addBook( arguments.theBook );
		arguments.theBook.setCheckedOut( true );
		arguments.theBook.setCheckedOutTimestamp( Now() );
		}
	}