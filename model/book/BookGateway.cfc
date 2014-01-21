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
	 * I return an array of Books matching criteria
	 */		
	array function getBooks( required string filterCriteria, boolean checkedOut ) {
		// add functionality to search using author:'name' or title:'title' or isbn:'number'
		local.hql = "from Book where ( ";
		local.params = {};
		
		if ( filterCriteria NEQ '' ) {
			local.hql &= "( author like :author or title like :title ) ";
			structInsert( local.params, 'author', '%' & arguments.filterCriteria & '%' );
			structInsert( local.params, 'title', '%' & arguments.filterCriteria & '%' );
			}
		if ( StructKeyExists( arguments, 'checkedOut' ) ) {
			if ( StructCount( local.params ) ) {
				local.hql &= "and ";
				}
			local.hql &= "checkedOut = :checkedOut ";
			structInsert( local.params, 'checkedOut', arguments.checkedOut );
			}
		
		local.hql &= " ) order by title, author";
		
		return ORMExecuteQuery( local.hql, local.params );
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
		
	/**
	 * I find a book matching passed in criteria
	 */	
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
	</cfscript>
</cfcomponent>