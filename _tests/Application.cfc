component{
	this.applicationroot = ReReplace( getDirectoryFromPath( getCurrentTemplatePath() ), "_tests.$", "", "all" );
	this.name = ReReplace( "[^W]", this.applicationroot & "_tests", "", "all" );
	this.sessionmanagement = true;
	// prevent bots creating lots of sessions
	if ( structKeyExists( cookie, "CFTOKEN" ) ) this.sessiontimeout = createTimeSpan( 0, 0, 5, 0 );
	else this.sessiontimeout = createTimeSpan( 0, 0, 0, 1 );	
	this.mappings[ "/frameworks" ] = this.applicationroot & "frameworks/";
	this.mappings[ "/scl/model" ] = this.applicationroot & "model/";
	this.mappings[ "/model" ] = this.applicationroot & "model/";
	this.mappings[ "/ValidateThis" ] = this.applicationroot & "lib/ValidateThis/";	
}