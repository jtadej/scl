component output="false" {
	// ------------------------ DEPENDENCY INJECTION ------------------------ //
	property name="config" getter="false";
	property name="DBService" getter="false";
	
	// ------------------------ CONSTRUCTOR ------------------------ //
/*
	any function init(){
		variables.dbengine = getDBEngine();
		
		return this;		
	}
*/
	
	// ------------------------ PUBLIC METHODS ------------------------ //
	/**
     * I return an entity matching an id
	 */
	function get( required string entityname, required numeric id ) {
//		var Entity = EntityLoadByPK( arguments.entityname, arguments.id );
		local.Entity = myEntityLoadByPK( arguments.entityname, arguments.id );
		if( IsNull( local.Entity ) ) local.Entity = new( arguments.entityname );
		
		return local.Entity;
		}

	/**
     * I return a new entity
	 */
	function new( required string entityname ) {
//		return EntityNew( arguments.entityname );
		return myEntityNew( arguments.entityname );
		}
		
	function myEntityNew( required string entityname ) {
		local.objectPath = VARIABLES.config.cfcroot & VARIABLES.config.entity[ arguments.entityname ].cfcfolder & '.' & arguments.entityname;
		return createObject( 'component', local.objectPath );
		}
		
	function myEntityLoadByPK( required string entityname, required numeric id ) {
		local.entity = variables.config.entity[ arguments.entityname ];
		local.objectPath = variables.config.cfcroot & local.entity.cfcfolder & '.' & arguments.entityname;
		local.results = variables.DBService.get( variables.config.mysql.schema & '.' & local.entity.table, [ [ local.entity.pk, '=', arguments.id ] ] );
		
		return createObject( 'component', local.objectPath ).init( local.results.results() );
		}
		
	function myEntityLoad( required string entityname, required query rows ) {
		local.entity = variables.config.entity[ arguments.entityname ];
		local.arrEntities = [];
		
		for ( local.i = 1; local.i LTE arguments.rows.recordCount; i += 1 ) {
			ArrayAppend( local.arrEntities, myEntityLoadByPK( arguments.entityname, arguments.rows[ local.entity.pk ][ local.i ] ) );
			}
			
		return local.arrEntities;
		}


    // ------------------------ PRIVATE METHODS ------------------------ //
/*
    private string function getDBEngine() {
			var dbinfo = new dbinfo().version();
			return UCase( dbinfo.DATABASE_PRODUCTNAME );
			}
*/
	}