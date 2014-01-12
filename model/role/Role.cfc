component accessors="true" persistent="true" table="roles" cachetype="transactional" output="false" {
	// ------------------------ PROPERTIES ------------------------ //	
	property name="id" fieldtype="id" required="true" column="id" ormtype="integer" length="11" unique="true" generator="native" setter="false";
	property name="name" column="name" required="true" ormtype="string" length="20" notnull="true";
	property name="permissions" column="permissions" ormtype="text";
	}