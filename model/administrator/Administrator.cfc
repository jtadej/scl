component accessors="true" persistent="true" table="users" cachetype="transactional" output="false" extends="model.user.User" {
	// ------------------------ PROPERTIES ------------------------ //	
	property name="teachers" type="array" fieldtype="one-to-many" cfc="model.teacher.Teacher" singularname="teacher" linktable="admins_teacherss" fkcolumn="admin_id" inversejoincolumn="teacher_id" lazy="false" cascade="save-update";

	
	// ------------------------ PUBLIC METHODS ------------------------ //
	/**
	 * I return the number of teachers a user has checked out
	 */	
	public numeric function numOfTeachers() {
		return ArrayLen( variables.teachers );
		} 
	 
	/**
	 * I overried the getTeachers function to ensure ordering by the students last name
	 * Documents in the following link:
	 * http://cfsimplicity.com/70/coldfusion-orm-quirks-ordering-one-to-many-children-via-a-link-table
	 */	
	public array function getTeachers(){
  	return ORMGetSession().createFilter( variables.teachers, "order by lastName").list();
		}
	}