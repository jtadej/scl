<cfspreadsheet action="read" src="assets/book.xls" query="qryBookData" headerrow="1" />

<cfset lstColumns="#qryBookData.columnList#" />

<cfloop query="qryBookData">
	<cfoutput>
		<cfif qryBookData.currentRow GT 1>
			<cftry>
				<cfquery datasource="scl">
					INSERT INTO scl.books (	id
																, title
																, author
																, illustrator
																, description
																, isbn13
																, binding
																, ar_level
																, ar_points
																, grade_level
																, min_interest_level
																, max_interest_level
																, lexile_level
																, reading_level
																, reading_recovery_level
																, guided_reading_level
																, classification
																, page_count
																, word_count
																, spanish	)
					VALUES (	<cfqueryparam value="#qryBookData['UNIQUE ID'][currentRow]#" cfsqltype="CF_SQL_INTEGER" />
									, <cfqueryparam value="#qryBookData['TITLE'][currentRow]#" cfsqltype="CF_SQL_VARCHAR" />
									, <cfqueryparam value="#qryBookData['AUTHOR'][currentRow]#" cfsqltype="CF_SQL_VARCHAR" />
									, <cfqueryparam value="#qryBookData['ILLUSTRATOR'][currentRow]#" null="#( Trim( qryBookData['ILLUSTRATOR'][currentRow] ) EQ '' ) ? 'YES' : 'NO'#" cfsqltype="CF_SQL_VARCHAR" />
									, <cfqueryparam value="#qryBookData['ANNOTATION'][currentRow]#" null="#( Trim( qryBookData['ANNOTATION'][currentRow] ) EQ '' ) ? 'YES' : 'NO'#" cfsqltype="CF_SQL_VARCHAR"  />
									, <cfqueryparam value="#qryBookData['ISBN'][currentRow]#" null="#( Trim( qryBookData['ISBN'][currentRow] ) EQ '' ) ? 'YES' : 'NO'#" cfsqltype="CF_SQL_VARCHAR" />
									, <cfqueryparam value="#( Trim(qryBookData['BINDING'][currentRow]) EQ 'Paperback' ) ? 'P' : qryBookData['BINDING'][currentRow]#" null="#( Trim( qryBookData['BINDING'][currentRow] ) EQ '' ) ? 'YES' : 'NO'#" cfsqltype="CF_SQL_VARCHAR" />
									, <cfqueryparam value="#qryBookData['AR LEVEL'][currentRow]#" null="#( Trim( qryBookData['AR LEVEL'][currentRow] ) EQ '' ) ? 'YES' : 'NO'#" cfsqltype="CF_SQL_VARCHAR" />
									, <cfqueryparam value="#qryBookData['AR POINTS'][currentRow]#" null="#( Trim( qryBookData['AR POINTS'][currentRow] ) EQ '' ) ? 'YES' : 'NO'#" cfsqltype="CF_SQL_VARCHAR" />
									, <cfqueryparam value="#qryBookData['GRADE LEVEL'][currentRow]#" null="#( Trim( qryBookData['GRADE LEVEL'][currentRow] ) EQ '' ) ? 'YES' : 'NO'#" cfsqltype="CF_SQL_VARCHAR" />
									, <cfqueryparam value="#qryBookData['INTEREST LEVEL MINIMUM'][currentRow]#" null="#( Trim( qryBookData['INTEREST LEVEL MINIMUM'][currentRow] ) EQ '' ) ? 'YES' : 'NO'#" cfsqltype="CF_SQL_VARCHAR" />
									, <cfqueryparam value="#qryBookData['INTEREST LEVEL MAXIMUM'][currentRow]#" null="#( Trim( qryBookData['INTEREST LEVEL MAXIMUM'][currentRow] ) EQ '' ) ? 'YES' : 'NO'#" cfsqltype="CF_SQL_VARCHAR" />
									, <cfqueryparam value="#qryBookData['LEXILE 0-1200'][currentRow]#" null="#( Trim( qryBookData['LEXILE 0-1200'][currentRow] ) EQ '' ) ? 'YES' : 'NO'#" cfsqltype="CF_SQL_INTEGER" />
									, <cfqueryparam value="#qryBookData['READING LEVEL'][currentRow]#" null="#( Trim( qryBookData['READING LEVEL'][currentRow] ) EQ '' ) ? 'YES' : 'NO'#" cfsqltype="CF_SQL_VARCHAR" />
									, <cfqueryparam value="#qryBookData['READING RECOVERY LEVEL'][currentRow]#" null="#( Trim( qryBookData['READING RECOVERY LEVEL'][currentRow] ) EQ '' ) ? 'YES' : 'NO'#" cfsqltype="CF_SQL_INTEGER" />
									, <cfqueryparam value="#qryBookData['GUIDED READING LEVEL'][currentRow]#" null="#( Trim( qryBookData['GUIDED READING LEVEL'][currentRow] ) EQ '' ) ? 'YES' : 'NO'#" cfsqltype="CF_SQL_VARCHAR" />
									, <cfqueryparam value="#( qryBookData['FICTION/NONFICTION (F/NF)'][currentRow] EQ 'NF' ) ? 'N' : qryBookData['FICTION/NONFICTION (F/NF)'][currentRow]#" null="#( Trim( qryBookData['FICTION/NONFICTION (F/NF)'][currentRow] ) EQ '' ) ? 'YES' : 'NO'#" cfsqltype="CF_SQL_VARCHAR" />
									, <cfqueryparam value="#qryBookData['PAGE COUNT'][currentRow]#" null="#( Trim( qryBookData['PAGE COUNT'][currentRow] ) EQ '' ) ? 'YES' : 'NO'#" cfsqltype="CF_SQL_INTEGER" />
									, <cfqueryparam value="#qryBookData['WORD COUNT'][currentRow]#" null="#( Trim( qryBookData['WORD COUNT'][currentRow] ) EQ '' ) ? 'YES' : 'NO'#" cfsqltype="CF_SQL_INTEGER"  />
									, <cfqueryparam value="#( qryBookData['SPANISH (Y/N)'][currentRow] EQ 'Y' ) ? 1 : 0#" null="#( Trim( qryBookData['SPANISH (Y/N)'][currentRow] ) EQ '' ) ? 'YES' : 'NO'#" cfsqltype="CF_SQL_BIT" /> )
				</cfquery>
				
				#qryBookData.currentRow#. You successfully added #qryBookData['UNIQUE ID'][currentRow]#!<br /><br />
				
		    <cfcatch type = "Database">
					<cfif findNoCase( 'duplicate', cfcatch.detail )>
						<b>#qryBookData.currentRow#. You have already added #qryBookData['UNIQUE ID'][currentRow]#!</b><br /><br />
					<cfelse>
						<!--- the message to display --->
						<h3>You've Thrown a Database <b>Error</b> on #qryBookData.currentRow#. #qryBookData['UNIQUE ID'][currentRow]#</h3>
						
						<!--- and the diagnostic message from the ColdFusion server --->
						<p>#cfcatch.message#</p>
						<p>#cfcatch.detail#</p>
						<p>Caught an exception, type = #CFCATCH.TYPE# </p>
						<p>The contents of the tag stack are:</p>
						<cfloop index = i from = 1 to = #ArrayLen(CFCATCH.TAGCONTEXT)#>
							<cfset sCurrent = #CFCATCH.TAGCONTEXT[i]#>
							<br>
							#i# #sCurrent["ID"]# (#sCurrent["LINE"]#,#sCurrent["COLUMN"]#) #sCurrent["TEMPLATE"]#
						</cfloop>
					</cfif>
		    </cfcatch>
			</cftry>
		</cfif>
	</cfoutput>
</cfloop>