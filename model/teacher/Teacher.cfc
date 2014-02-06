component accessors="true" persistent="true" table="users" cachetype="transactional" output="false" extends="model.user.User" {
	// ------------------------ PROPERTIES ------------------------ //	
	property name="students" type="array" fieldtype="one-to-many" cfc="model.student.Student" singularname="student" linktable="teachers_students" fkcolumn="teacher_id" inversejoincolumn="student_id" lazy="false" cascade="save-update";

	
	// ------------------------ PUBLIC METHODS ------------------------ //
	/**
	 * I return the number of students a user has checked out
	 */	
	public numeric function numOfStudents() {
		return ArrayLen( variables.students );
		} 
	 
	/**
	 * I overried the getStudents function to ensure ordering by the students last name
	 * Documents in the following link:
	 * http://cfsimplicity.com/70/coldfusion-orm-quirks-ordering-one-to-many-children-via-a-link-table
	 */	
	public array function getStudents(){
  	return ORMGetSession().createFilter( variables.students, "order by lastName").list();
		}
	}