component  accessors="true" extends="model.abstract.BaseService" {
	// ------------------------ DEPENDENCY INJECTION ------------------------ //	
	property name="config" getter="false";
	
	VARIABLES.private = { _instance = ''
										 , _query = ''
										 , _queryService = ''
										 , _error = false
										 , _results = ''
										 , _count = 0 }; 

	public function init( any config ) {
			setConfig( ARGUMENTS.config );
			
			VARIABLES.private._queryService = new Query();
			VARIABLES.private._queryService.setDatasource( VARIABLES.config.mysql.datasource );
			
			return this;
		}

	private function query( sql = '', params = structNew() ) {
		VARIABLES.private._error = false;
		VARIABLES.private._query = ARGUMENTS.sql;
		
		VARIABLES.private._queryService.clearParams();
		
		VARIABLES.private._queryService.setSQL( ARGUMENTS.sql );
		
		for ( LOCAL.param in ARGUMENTS.params ) {
/*
			LOCAL.type = 'cf_sql_varchar';

			if ( FindNoCase( 'date', getMetaData( ARGUMENTS.params[ LOCAL.param ] ).getName() ) ) {
				LOCAL.type = 'cf_sql_date'; 
				}
			else if ( isNumeric( ARGUMENTS.params[ LOCAL.param ] ) ) {
				LOCAL.type = 'cf_sql_integer';
				}
*/

			VARIABLES.private._queryService.addParam( name = LOCAL.param, value = ARGUMENTS.params[ LOCAL.param ]); //, cfsqltype = LOCAL.type );
			}
			
		try {
			LOCAL.execute = VARIABLES.private._queryService.execute();

			VARIABLES.private._results = LOCAL.execute.getResult();
			VARIABLES.private._count = LOCAL.execute.getPrefix().RecordCount;
			}
		catch ( database e ) {
			VARIABLES.private._error = true;
			rethrow;
			}
			
		return this;
		}
		
	private function action( action, table, filters = [ [ ] ] ) {
		LOCAL.where = '';
		LOCAL.params = {};
		
		for ( LOCAL.i = 1; LOCAL.i LTE ArrayLen( ARGUMENTS.filters ); LOCAL.i += 1 ) {
			LOCAL.filter = ARGUMENTS.filters[ LOCAL.i ];
			
			LOCAL.operators = [ '=', '>', '<', '>=', '<=', 'LIKE' ];
			
			LOCAL.field = LOCAL.filter[ 1 ];
			LOCAL.operator = LOCAL.filter[ 2 ];
			LOCAL.value = LOCAL.filter[ 3 ];
			LOCAL.connector = '';
			
			if ( ArrayLen( LOCAL.filter ) EQ 4 ) {
				LOCAL.connector = LOCAL.filter[ 4 ];
				}
			
			if ( ArrayContains( LOCAL.operators, LOCAL.operator ) ) {
				LOCAL.where &= LOCAL.connector & ' ' & LOCAL.field & ' ' & LOCAL.operator & ' :' & LOCAL.field & ' ';
				LOCAL.params[ LOCAL.field ] = LOCAL.value;
				}
			}
			
		LOCAL.sql = ARGUMENTS.action & ' FROM ' & ARGUMENTS.table;
		if ( LOCAL.where NEQ '' ) {
			LOCAL.sql &= ' WHERE ' & LOCAL.where;
			}
			
		if ( NOT query( LOCAL.sql, LOCAL.params ).error() ) {
			return this;
			}
		return false;
		}
		
	public function insert( table, fields = structNew() ) {
		VARIABLES.private._error = false;
		
		if ( structCount( ARGUMENTS.fields ) ) {
			LOCAL.keys = StructKeyList( ARGUMENTS.fields );
			LOCAL.values = '';
			LOCAL.x = 1;
			
			for ( LOCAL.field in ARGUMENTS.fields ) {
				LOCAL.values &= ":" & LOCAL.field;
				
				if ( LOCAL.x < structCount( ARGUMENTS.fields ) ) {
					LOCAL.values &= ", "; 
					}
				
				LOCAL.x += 1;
				}
			
			LOCAL.sql = "INSERT INTO " & ARGUMENTS.table & " (" & LOCAL.keys & ") VALUES (" & LOCAL.values & ")";
			VARIABLES.private._queryService.setSQL( LOCAL.sql );
			
			VARIABLES.private._queryService.clearParams();
			
			for ( LOCAL.i = 1; LOCAL.i LTE ListLen( LOCAL.keys ); LOCAL.i += 1 ) {
				LOCAL.key = ListGetAt( LOCAL.keys, LOCAL.i );
				LOCAL.value = ARGUMENTS.fields[ LOCAL.key ];
				LOCAL.type = 'cf_sql_varchar';
				
				if ( FindNoCase( 'date', getMetaData( LOCAL.value ).getName() ) ) {
					LOCAL.type = 'cf_sql_date'; 
					}
				else if ( isNumeric( LOCAL.value ) ) {
					LOCAL.type = 'cf_sql_integer';
					}

				VARIABLES.private._queryService.addParam( name = LOCAL.key, value = LOCAL.value, cfsqltype = LOCAL.type );
				}

			try {
				LOCAL.execute = VARIABLES.private._queryService.execute();
			
				VARIABLES.private._results = LOCAL.execute.getResult();
				}
			catch ( database e ) {
				VARIABLES.private._error = true;
				rethrow;
				}			
			
			if ( NOT error() ) {
				return true;
				}
			}
		return false;
		}
		
	public function update( table, id, fields = StructNew() ) {
		LOCAL.set = '';
		LOCAL.x = 1;

		VARIABLES.private._queryService.clearParams();
					
		for ( LOCAL.field in ARGUMENTS.fields ) {
			LOCAL.set &= LOCAL.field & " = :" & LOCAL.field;
			
			if ( LOCAL.x < structCount( ARGUMENTS.fields ) ) {
				LOCAL.set &= ", ";
				}
			
			VARIABLES.private._queryService.addParam( name = LOCAL.field, value = ARGUMENTS.fields[ LOCAL.field ] );
			
			LOCAL.x += 1;
			}
			
		LOCAL.sql = "UPDATE " & ARGUMENTS.table & " SET " & LOCAL.set & " WHERE id = " & ARGUMENTS.id;
		VARIABLES.private._queryService.setSQL( LOCAL.sql );
		
		try {
			LOCAL.execute = VARIABLES.private._queryService.execute();
		
			VARIABLES.private._results = LOCAL.execute.getResult();
			}
		catch ( database e ) {
			VARIABLES.private._error = true;
			rethrow;
			}			
		
		if ( NOT error() ) {
			return true;
			}
			
		return false;
		}
		
	public function get( table, filters ) {
		return action( "SELECT *", ARGUMENTS.table, ARGUMENTS.filters );
		}
		
	public function delete( table, filters ) {
		return action( "DELETE", ARGUMENTS.table, ARGUMENTS.filters );
		}

	public function count() {
		return VARIABLES.private._count;
		}
		
	public function results() {
		return VARIABLES.private._results;
		}
		
	public function first() {
		return queryGetRow( results(), 1 );
		}
		
	public function error() {
		return VARIABLES.private._error;
		}
		
	/**
	 * Return a single row from a query.
	 * 
	 * @param qry      Query to inspect. (Required)
	 * @param row      Numeric row to retrieve. (Required)
	 * @return Returns a query. 
	 * @author Tony Felice (tfelice@reddoor.biz) 
	 * @version 0, February 14, 2009 
	 */
	private function queryGetRow( qry, row ){
    LOCAL.result = queryNew( '' );
    LOCAL.cols = listToArray( ARGUMENTS.qry.columnList );
    LOCAL.i = '';

    for ( LOCAL.i = 1; LOCAL.i lte arrayLen( LOCAL.cols ); LOCAL.i += 1 ) {
			// Added a bogus delimter to ensure the listToArray function did not separate a single value
    	queryAddColumn( LOCAL.result, LOCAL.cols[ i ], listToArray( ARGUMENTS.qry[ LOCAL.cols[ LOCAL.i ] ][ ARGUMENTS.row ], '!)@(*$&%&^' ) );
    	}

    return LOCAL.result;
		}
	}