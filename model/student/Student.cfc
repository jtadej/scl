component accessors="true"  extends="model.user.User" {
	// ------------------------ PROPERTIES ------------------------ //	
	property name="id";
	property name="barcode";
	property name="username";
	property name="password";
	property name="firstName";
	property name="lastName";
	property name="numBooksAllowed";
	property name="role";
/*
	property name="id" column="id" fieldtype="id" setter="false" generator="native";
	property name="barcode" column="barcode" fieldtype="column" ormtype="int";
	property name="username" column="username" fieldtype="column" ormtype="string" length="21";
	property name="password" column="password" fieldtype="column" ormtype="string" length="65";
	property name="firstName" column="first_name" fieldtype="column" ormtype="string" length="10";
	property name="lastName" column="last_name" fieldtype="column" ormtype="string" length="20";
	property name="numBooksAllowed" column="num_books_allowed" fieldtype="column" ormtype="int";
	property name="role" column="role" fieldtype="column" ormtype="int";
*/

	array function getCheckedOutBooks() {
		}
	}