﻿component accessors="true" extends="abstract" {
	// ------------------------ DEPENDENCY INJECTION ------------------------ //	
	property name="code39Service" setter="true" getter="false";
	
	
	// ------------------------ PUBLIC METHODS ------------------------ //
	void function students( required struct rc ) {
		rc.objCode39Service = variables.code39Service;
		}
	}