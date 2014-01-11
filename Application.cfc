component extends="lib.org.corfield.framework" {

	THIS.Name = "scl";
	THIS.Development = ( isLocalhost( CGI.REMOTE_HOST ) ) ? true : false ;
	THIS.ApplicationRoot = getDirectoryFromPath( getCurrentTemplatePath() );
	THIS.ApplicationTimeout = CreateTimeSpan( 0, 0, 1, 0 );
	THIS.SessionManagement = true;
	THIS.SetClientCookies = false;
	THIS.mappings[ "/scl/model" ] = THIS.ApplicationRoot & "model/";
	THIS.mappings[ "/model" ] = THIS.ApplicationRoot & "model/";
	THIS.mappings[ "/org" ] = THIS.ApplicationRoot & "lib/org/";
	THIS.mappings[ "/Hoth" ] = THIS.ApplicationRoot & "lib/Hoth/";
	THIS.mappings[ "/ValidateThis" ] = THIS.ApplicationRoot & "lib/ValidateThis/";
	
	// ------------------------ FW/1 SETTINGS ------------------------ //
	VARIABLES.framework = {
			reloadApplicationOnEveryRequest = THIS.Development
		, trace = !THIS.Development
 		, generateSES = true
		, maxNumContextsPreserved = 1
		, usingSubsystems = true
		, defaultSubsystem = "public"
		, SESOmitIndex = false /* set this to true if you have url rewrite enabled */
		, subsystemDelimiter = ":" // see note below
		, base = getDirectoryFromPath( CGI.SCRIPT_NAME )
		, baseURL = 'useCgiScriptName'
		};
	
	/*
		This is provided for illustration only - you should not use this in
		a real program! Only override the defaults you need to change!
	variables.framework = {
		// the name of the URL variable:
		action = 'action',
		// whether or not to use subsystems:
		usingSubsystems = false,
		// default subsystem name (if usingSubsystems == true):
		defaultSubsystem = 'home',
		// default section name:
		defaultSection = 'main',
		// default item name:
		defaultItem = 'default',
		// if using subsystems, the delimiter between the subsystem and the action:
		subsystemDelimiter = ':',
		// if using subsystems, the name of the subsystem containing the global layouts:
		siteWideLayoutSubsystem = 'common',
		// the default when no action is specified:
		home = defaultSubsystem & ':' & defaultSection & '.' & defaultItem,
		-- or --
		home = defaultSection & '.' & defaultItem,
		// the default error action when an exception is thrown:
		error = defaultSubsystem & ':' & defaultSection & '.error',
		-- or --
		error = defaultSection & '.error',
		// the URL variable to reload the controller/service cache:
		reload = 'reload',
		// the value of the reload variable that authorizes the reload:
		password = 'true',
		// debugging flag to force reload of cache on each request:
		reloadApplicationOnEveryRequest = false,
		// whether to force generation of SES URLs:
		generateSES = false,
		// whether to omit /index.cfm in SES URLs:
		SESOmitIndex = false,
		// location used to find layouts / views:
		base = getDirectoryFromPath( CGI.SCRIPT_NAME ),
		// either CGI.SCRIPT_NAME or a specified base URL path:
		baseURL = 'useCgiScriptName',
		// location used to find controllers / services:
		// cfcbase = essentially base with / replaced by .
		// whether FW/1 implicit service call should be suppressed:
		suppressImplicitService = true,
		// list of file extensions that FW/1 should not handle:
		unhandledExtensions = 'cfc',
		// list of (partial) paths that FW/1 should not handle:
		unhandledPaths = '/flex2gateway',
		// flash scope magic key and how many concurrent requests are supported:
		preserveKeyURLKey = 'fw1pk',
		maxNumContextsPreserved = 10,
		// set this to true to cache the results of fileExists for performance:
		cacheFileExists = false,
		// change this if you need multiple FW/1 applications in a single CFML application:
		applicationKey = 'org.corfield.framework'
	};
	*/
	
	// ------------------------ CALLED WHEN APPLICATION STARTS ------------------------ //	
	void function setupApplication() {
		// add exception tracker to application scope
		APPLICATION.ExceptionTracker = new Hoth.HothTracker( new Hoth.config.HothConfig() );
		
		// setup bean factory
		var beanfactory = new org.corfield.ioc( "/scl/model", { singletonPattern = "(Service|Gateway)$" } );
		setBeanFactory( beanfactory );
		
		// add validator bean to factory
		var ValidateThisConfig = { definitionPath = '/scl/model', JSIncludes=false, resultPath="model.utility.ValidatorResult" };
		beanFactory.addBean( "Validator", new ValidateThis.ValidateThis( ValidateThisConfig ) );

		// add configuration bean to factory
		beanFactory.addBean( "config", getConfiguration() );
		}

	// ------------------------ CALLED WHEN PAGE REQUEST STARTS ------------------------ //	
	void function setupRequest() {
		// use setupRequest to do initialization per request
		request.context.startTime = getTickCount();
		
		// define base url
		if( CGI.HTTPS EQ "on" )  {
			rc.basehref = "https://";
			}
		else {
			rc.basehref = "http://";
			}
		rc.basehref &= CGI.HTTP_HOST & VARIABLES.framework.base;
	  	
		// store config in request context
		rc.config = getBeanFactory().getBean( "config" );
		}
		
	// ------------------------ CALLED WHEN VIEW RENDERING STARTS ------------------------ //	
	void function setupView(){
		}
	
	// ------------------------ CALLED WHEN EXCEPTION OCCURS ------------------------ //	
	void function onError( Exception, EventName ){	
		if ( StructKeyExists( APPLICATION, "ExceptionTracker" ) ) {
			APPLICATION.ExceptionTracker.track( arguments.Exception );
			}
		super.onError( ARGUMENTS.Exception, ARGUMENTS.EventName );
		}	
	
	// ------------------------ CALLED WHEN VIEW IS MISSING ------------------------ //	
	any function onMissingView( required rc ){
		}
	
	// ------------------------ CONFIGURATION ------------------------ //	
	private struct function getConfiguration() {
		var config = { development = this.development
								 , webroot = THIS.applicationRoot
								 , cfcroot = 'model.'
								 , mysql = { datasource = 'scl'
								 					 , schema = 'scl' }
								 , remember = { cookie_name = 'hash'
															, cookie_expiry = 604800 }
								 , revision = Hash( Now() )
								 , display = { thumbnail_size = 75 }
								 , session = { session_name = 'user'
														 , token_name = 'token' }
								 , entity = { Student = { cfcfolder = 'student'
								 										 		, table = 'users'
								 										 		, pk = 'id' }
														,	Book = { cfcfolder = 'book'
																		 , table = 'books'
																		 , pk = 'id' } }
								 , security = { whitelist = "security,error,verify"  } // list of unsecure actions - by default all requests require authentication
								 };
									 
		// override config in development mode
		if ( config.development ) {
			} 
			
		return config;
		}
	
}