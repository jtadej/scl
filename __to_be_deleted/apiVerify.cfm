<cfquery name="qryBooks" datasource="scl">
	SELECT *
	FROM scl.books
	WHERE google_verified = 0
</cfquery>

<cfdump var="#qryBooks#" >
<cfabort>

<script src="https://openlibrary.org/api/books?bibkeys=ISBN:0451526538"></script>

<cfloop query="qryBooks" startrow="1" endrow="5">
<!---
	USING GOOGLE BOOKS API
	<cfset strURL = "https://www.googleapis.com/books/v1/volumes?q=isbn:" & qryBooks.ISBN13 />
	<cfhttp url="#strURL#" result="httpResults" />
--->
<!---
	USING FLAT FILES FROM GOOGLE BOOKS API
	<cfset strFile = GetDirectoryFromPath( GetCurrentTemplatePath() ) & 'assets/google_books/' & qryBooks.ISBN13 & '.json' />
--->
<!---
	USING OPENLIBRARY API --->
	<cfset strURL = "http://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" & qryBooks.ISBN13 />
	<cfhttp url="#strURL#" result="httpResults" />
	
	<h3><cfoutput><a href="#strURL#">#qryBooks.ISBN13#</a> -- #qryBooks.title#</cfoutput></h3>


<!--- 
	USING FLAT FILES FROM GOOGLE BOOKS API
	<cfif FileExists( strFile )>
		<cffile action="read" file="#strFile#" variable="httpResults.fileContent" /> 
--->
		<cfset jsonResults = deserializeJSON( httpResults.fileContent ) /> 
		
		<cfdump var="#jsonResults#" />
		
		<cfoutput>
			<table name="tblDBtoGoogle" border="1">
				<thead>
					<tr>
						<th>Columns</th>
						<th>Database</th>
<!---
	USING GOOGLE BOOKS API
						<cfloop from="1" to="#ArrayLen(jsonResults.items)#" index="i">
							<th>Google #i#</th>
						</cfloop>
--->
						<th>OpenLibrary</th>
					</tr>
				</thead>
				<tbody>
					<cfloop list="#qryBooks.ColumnList#" index="column">
						<tr>
							<td>#column#</td>
							<td>#qryBooks[column][currentRow]#</td>
							<td></td>
<!---
	USING GOOGLE BOOKS API
							<cfloop from="1" to="#ArrayLen(jsonResults.items)#" index="i">
								<cfset volumeInfo = jsonResults.items[i].volumeInfo />
								<td>
									<cfswitch expression="#column#">
										<cfcase value="AR_LEVELS">
										</cfcase>
										<cfcase value="AR_POINTS">
										</cfcase>
										<cfcase value="AUTHOR">
											<cfif structKeyExists( volumeInfo, "authors" )>
												#ArrayToList( volumeInfo.authors )#
											</cfif>
										</cfcase>
										<cfcase value="BINDING">
										</cfcase>
										<cfcase value="CLASSIFICATION">
										</cfcase>
										<cfcase value="COVER_URL">
											<cfif structKeyExists( volumeInfo, "thumbnail" )>
												#volumeInfo.imageLinks.thumbnail#
											</cfif>
										</cfcase>
										<cfcase value="COVER_URL_THUMBNAIL">
											<cfif structKeyExists( volumeInfo, "smallThumbnail" )>
												#volumeInfo.imageLinks.smallThumbnail#
											</cfif>
										</cfcase>
										<cfcase value="DESCRIPTION">
											<cfif structKeyExists( volumeInfo, "description" )>
												#volumeInfo.description#
											</cfif>
										</cfcase>
										<cfcase value="GOOGLE_VERIFIED">
										</cfcase>
										<cfcase value="GRADE_LEVEL">
										</cfcase>
										<cfcase value="GUIDED_READING_LEVEL">
										</cfcase>
										<cfcase value="ID">
										</cfcase>
										<cfcase value="ILLUSTRATOR">
										</cfcase>
										<cfcase value="ISBN10">
											<cfif structKeyExists( volumeInfo, "industryIdentifiers" )>
												<cfloop from="1" to="#ArrayLen( volumeInfo.industryIdentifiers )#" index="j">
													<cfif volumeInfo.industryIdentifiers[j].type EQ 'ISBN_10'>
														#volumeInfo.industryIdentifiers[j].identifier#
													</cfif>
												</cfloop>
											</cfif>
										</cfcase>
										<cfcase value="ISBN13">
											<cfif structKeyExists( volumeInfo, "industryIdentifiers" )>
												<cfloop from="1" to="#ArrayLen( volumeInfo.industryIdentifiers )#" index="j">
													<cfif volumeInfo.industryIdentifiers[j].type EQ 'ISBN_13'>
														#volumeInfo.industryIdentifiers[j].identifier#
													</cfif>
												</cfloop>
											</cfif>
										</cfcase>
										<cfcase value="LEXILE_LEVEL">
										</cfcase>
										<cfcase value="MAX_INTEREST_LEVEL">
										</cfcase>
										<cfcase value="MIN_INTEREST_LEVEL">
										</cfcase>
										<cfcase value="PAGE_COUNT">
											<cfif structKeyExists( volumeInfo, "pageCount" )>
												#volumeInfo.pageCount#
											</cfif>
										</cfcase>
										<cfcase value="READING_LEVEL">
										</cfcase>
										<cfcase value="READING_RECOVERY_LEVEL">
										</cfcase>
										<cfcase value="SPANISH">
											<cfif structKeyExists( volumeInfo, "language" )>
												#( volumeInfo.language EQ 'sp' ) ? 1 : 0#
											</cfif>
										</cfcase>
										<cfcase value="TITLE">
											<cfif structKeyExists( volumeInfo, "title" )>
												#volumeInfo.title#
											</cfif>
										</cfcase>
										<cfcase value="UPC">
										</cfcase>
										<cfcase value="WORD_COUNT">
										</cfcase>
									</cfswitch>
								</td>
							</cfloop>
--->
						</tr>
					</cfloop>
				</tbody>
			</table>	
		</cfoutput>
<!---
	USING FLAT FILES FROM GOOGLE BOOKS API
	</cfif>
--->
</cfloop>

