component accessors="true" persistent="true" table="users" cachetype="transactional" discriminatorColumn="user_type" output="false" {
	// ------------------------ PROPERTIES ------------------------ //	
	property name="id" fieldtype="id" required="true" column="id" ormtype="integer" length="11" unique="true" generator="native" setter="false";
	property name="barcode" column="barcode" ormtype="integer" length="11" unique="true";
	property name="username" column="username" required="true" ormtype="string" length="21" unique="true" notnull="true";
	property name="password" column="password" ormtype="string" length="65";
	property name="firstName" column="first_name" ormtype="string" length="10";
	property name="lastName" column="last_name" ormtype="string" length="20";
	property name="role" fkcolumn="role" required="true" fieldtype="many-to-one" cfc="model.role.Role" notnull="true";
	
	// ------------------------ CONSTRUCTOR ------------------------ //
	/**
	 * I initialise this component
	 */		
	User function init() {
		return this;
		}	


	// ------------------------ PUBLIC METHODS ------------------------ //
	/**
	 * I return true if the user is persisted
	 */	
	boolean function isPersisted() {
		return !IsNull( variables.id );
		}
		
	string function getName() {
		return variables.firstName & ' ' & variables.lastName;
		}

	/**
	* I override the implicit setter to include hashing of the password
	*/
	string function setPassword( required password ){
		if( arguments.password != "" ){
			variables.password = arguments.password;
			// to help prevent rainbow attacks hash several times
			for ( var i=0; i<50; i++ ) variables.password = Hash( variables.password, "SHA-256" );
			}
		}	
	}