component persistent="true" table="books" cachetype="transactional" output="false" {
	// ------------------------ PROPERTIES ------------------------ //	
	property name="id" fieldtype="id" required="true" column="id" ormtype="integer" length="11" unique="true" generator="native" setter="false";
	property name="title" column="title" required="true" ormtype="string" length="200" notnull="true";
	property name="author" column="author" required="true" ormtype="string" length="150" notnull="true";
	property name="illustrator" column="illustrator" ormtype="string" length="150";
	property name="description" column="description" ormtype="text";
	property name="isbn10" column="isbn10" ormtype="string" length="10";
	property name="isbn13" column="isbn13" ormtype="string" length="13";
	property name="upc" column="upc" ormtype="string" length="12";
	property name="binding" column="binding" ormtype="string" length="1";
	property name="arLevel" column="ar_level" ormtype="string" length="3";
	property name="arPoint" column="ar_points" ormtype="string" length="4";
	property name="gradeLevel" column="grade_level" ormtype="string" length="1";
	property name="minInterestLevel" column="min_interest_level" ormtype="string" length="2";
	property name="maxInterestLevel" column="max_interest_level" ormtype="string" length="2";
	property name="lexileLevel" column="lexile_level" ormtype="integer" length="11";
	property name="readingLevel" column="reading_level" ormtype="string" length="1";
	property name="readingRecoveryLevel" column="reading_recovery_level" ormtype="integer" length="11";
	property name="guidedReadingLevel" column="guided_reading_level" ormtype="string" length="1";
	property name="classification" column="classification" ormtype="string" length="1";
	property name="numOfPages" column="page_count" ormtype="integer" length="11";
	property name="numOfWords" column="word_count" ormtype="integer" length="11";
	property name="coverURL" column="cover_url" ormtype="string" length="2048";
	property name="coverThumbnailURL" column="cover_url_thumbnail" ormtype="string" length="2048";
	property name="checkedOutTimestamp" column="checked_out_timestamp" ormtype="timestamp";
	property name="checkedOut" dbdefault="false" column="checked_out" ormtype="boolean";
	property name="spanish" column="spanish" ormtype="boolean";
	property name="apiVerified" dbdefault="false" column="api_verified" ormtype="boolean";
	
	// ------------------------ CONSTRUCTOR ------------------------ //
	/**
	 * I initialise this component
	 */		
	Book function init() {
		return this;
		}	
		
	// ------------------------ PUBLIC METHODS ------------------------ //
	/**
	 * I return true if the book is persisted
	 */	
	boolean function isPersisted() {
		return !IsNull( variables.id );
		}
		
	/**
	 * I return true if the book is checked out
	 */		
	boolean function isCheckedOut() {
		return ( variables.checkedout ) ? true : false;
		}
	}