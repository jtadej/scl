component accessors="true" {
	// ------------------------ PROPERTIES ------------------------ //	
	property name="id";
	property name="title";
	property name="author";
	property name="description";
	property name="isbn10";
	property name="isbn13";
	property name="upc";
	property name="coverURL";
	property name="coverThumbnailURL";
	property name="numOfPages";
	
	// ------------------------ CONSTRUCTOR ------------------------ //
	/**
	 * I initialise this component
	 */		
	Book function init( any collection ) {
		setId( arguments.collection.id );
		setTitle( arguments.collection.title );
		setAuthor( arguments.collection.author );
		setDescription( arguments.collection.description );
		setISBN10( arguments.collection.isbn10 );
		setISBN13( arguments.collection.isbn13 );
		setUPC( arguments.collection.upc );
		setCoverURL( arguments.collection.cover_url );
		setCoverThumbnailURL( arguments.collection.cover_url_thumbnail );
		setNumOfPages( arguments.collection.page_count );
		
		return this;
		}	
		
	// ------------------------ PUBLIC METHODS ------------------------ //
	/**
	 * I return true if the book is persisted
	 */	
	boolean function isPersisted() {
		return !IsNull( variables.id );
		}
	}