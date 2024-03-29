﻿<cfcomponent displayname="Application" output="true" hint="Handle the application.">
	<!--- Set up the application. --->
	<cfset THIS.Name = "scl" />
	<cfset THIS.ApplicationRoot = getDirectoryFromPath( getCurrentTemplatePath() ) />
	<cfset THIS.ApplicationTimeout = CreateTimeSpan( 0, 0, 1, 0 ) />
	<cfset THIS.SessionManagement = true />
	<cfset THIS.SetClientCookies = false />
	<cfset THIS.mappings[ "/Hoth" ] = THIS.ApplicationRoot & "/lib/Hoth" />
  
	<!--- Define the page request properties. --->
	<cfsetting requesttimeout="20" showdebugoutput="false" enablecfoutputonly="false" />
 
	<cffunction name="OnApplicationStart" access="public" returntype="boolean" output="false"
							hint="Fires when the application is first created.">
 
		<!--- Return out. --->
		<cfreturn true />
	</cffunction>
 
	<cffunction name="OnSessionStart" access="public" returntype="void" output="false"
							hint="Fires when the session is first created.">
 
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
	<cffunction name="OnRequestStart" access="public" returntype="boolean" output="false"
							hint="Fires at first part of page processing.">
		<!--- Define arguments. --->
		<cfargument name="TargetPage" type="string" required="true" />
		
		<!--- Place Hoth into Application Memory. --->
    <cfif NOT structKeyExists(APPLICATION, 'HothTracker')>
    	<cflock name="#APPLICATION.ApplicationName#_HothTracker" type="exclusive" timeout="10">
		    <cfif NOT structKeyExists(APPLICATION, 'HothTracker')>
	    		<cfset APPLICATION.HothTracker = new Hoth.HothTracker( new lib.Hoth.config.HothConfig() ) />
				</cfif>	
			</cflock>
    </cfif>
		
		<!--- Return out. --->
		<cfreturn true />
	</cffunction>
 
	<cffunction name="OnRequest" access="public" returntype="void" output="true"
							hint="Fires after pre page processing is complete.">
		<!--- Define arguments. --->
		<cfargument name="TargetPage" type="string" required="true" />
 
		<!--- Include the requested page. --->
		<cfinclude template="#ARGUMENTS.TargetPage#" />
 
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
	<cffunction name="OnRequestEnd" access="public" returntype="void" output="true"
							hint="Fires after the page processing is complete.">
 
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
	<cffunction name="OnSessionEnd" access="public" returntype="void" output="false"
							hint="Fires when the session is terminated.">
		<!--- Define arguments. --->
		<cfargument name="SessionScope" type="struct" required="true" />
		<cfargument name="ApplicationScope" type="struct" required="false" default="#StructNew()#" />
 
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
	<cffunction name="OnApplicationEnd" access="public" returntype="void" output="false"
							hint="Fires when the application is terminated.">
		<!--- Define arguments. --->
		<cfargument name="ApplicationScope" type="struct" required="false" default="#StructNew()#" />
 
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
	<cffunction name="OnError" access="public" returntype="void" output="true"
							hint="Fires when an exception occures that is not caught by a try/catch.">
		<!--- Define arguments. --->
		<cfargument name="Exception" type="any" required="true" />
		<cfargument name="EventName" type="string" required="false" default="" />
		
		<!--- Create an instance of Hoth if one does not exist in the
        	application scope. Hoth should exist in the Application Scope
        	but, if something went wrong there we are ensured tracking. --->
    <cfset VARIABLES.HothTracker = ( structKeyExists(application, 'HothTracker') ) ? application.HothTracker : new Hoth.HothTracker( new lib.Hoth.config.HothConfig() ) />
    <cfset VARIABLES.HothTracker.track(Exception) />
 
 		<cfdump var="#ARGUMENTS#" />
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
</cfcomponent>
