<cfcomponent accessors="true" output="false" extends="model.abstract.BaseGateway">
	<!--- ------------------------ DEPENDENCY INJECTION ------------------------ --->
	<cfproperty name="config" getter="false" />
	<cfproperty name="DBService" getter="false" />

	
	<cfscript>
	// ------------------------ PUBLIC METHODS ------------------------ //
	/**
	 * I return a Book matching an id
	 */		
	Book function getBook( required numeric userid ){
		return get( "Book", arguments.userid );
		}
		
	/**
	 * I return a new book
	 */		
	Book function newBook() {
		return new( "Book" );
		}
		
	/**
	 * I save a book
	 */	
	Book function saveBook( required Book theBook ){
		return save( arguments.theBook );
		}
		
	Book function findBook( required Book theBook ) {
		// find the book matching isbn10, isbn13, or upc
		local.Book = ORMExecuteQuery( "from Book where ( isbn10 = :isbn10 OR isbn13 = :isbn13 or upc = :upc )", { isbn10 = arguments.theBook.getISBN10(), isbn13 = arguments.theBook.getISBN13(), upc = arguments.theBook.getUPC() }, true, { maxResults = 1 } );		

		if ( IsNull( local.Book ) ) local.Book = new( "Book" );
		return local.Book;
		}
		
	/**
	 * I return true if the book is checked out
	 */		
	boolean function isCheckedOut( required numeric bookId, numeric userId ) {
		local.arrParams = [ [ 'book_id', '=', arguments.bookId ] ];
		if ( arguments.userId ) {
			ArrayAppend( local.arrParams, [ 'user_id', '=', arguments.userId, 'AND' ] );
			}
		local.results = variables.DBService.get( variables.config.mysql.schema & '.checked_out', local.arrParams );
		
		return ( local.results.count() ) ? true : false;
		}	
		
	/**
	 * I check out a book for a user
	 */		
	void function checkOut( required numeric bookId, required numeric userId ) {
		variables.DBService.insert( variables.config.mysql.schema & '.checked_out', { book_id = arguments.bookId, user_id = arguments.userId } );
		}	
		
	/**
	 * I check in a book for a user
	 */		
	void function checkIn( required any currentUser ) {
WriteDump( arguments );
Abort;
		variables.DBService.delete( variables.config.mysql.schema & '.checked_out', [ [ 'book_id', '=', arguments.bookId ], [ 'user_id', '=', arguments.userId, 'AND' ] ] );
		}	
	</cfscript>

<!---
	<cffunction name="getCheckedOutBooks" output="false" returntype="array" hint="I return a query of books that are checked out for a user">
		<cfargument name="userID" type="numeric" required="false" />
		
		<cfquery name="qryCheckedOutBooks" datasource="#variables.config.mysql.datasource#">
			SELECT  id
						, title
						, author
						, description
						, isbn10
						, isbn13
						, upc
						, cover_url
						, cover_url_thumbnail
						, page_count
			FROM scl.books
			WHERE id IN ( SELECT book_id
										FROM scl.checked_out
										<cfif StructKeyExists( arguments, "userID")>
											WHERE user_id = <cfqueryparam value="#arguments.userID#" cfsqltype="cf_sql_integer" />
										</cfif>
									 )
		</cfquery>
		
		<cfreturn EntityLoad( "Book", qryCheckedOutBooks ) />
	</cffunction>
--->
</cfcomponent>