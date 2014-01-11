<cfquery name="qryBooks" datasource="scl">
	SELECT *
	FROM scl.books
	WHERE api_verified = 0
</cfquery>

<!--- use this to set values in the db --->
<cfloop query="qryBooks">
	<cfset strURL = "http://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" & qryBooks.ISBN13 />
	<cfhttp url="#strURL#" result="httpResults" />
	<cfset jsonResults = deserializeJSON( httpResults.fileContent ) /> 
	<cfset updated = false />
	
	<cfif StructKeyExists( jsonResults, "ISBN:" & qryBooks.ISBN13 )>
		<cfset volumeInfo = jsonResults[ "ISBN:" & qryBooks.ISBN13 ] />
		
		<cfif StructKeyExists( volumeInfo, "cover" )>
			<cfquery datasource="scl" result="stcResult">
				UPDATE scl.books
				SET cover_url = <cfqueryparam value="#volumeInfo.cover.large#" null="#NOT StructKeyExists( volumeInfo, 'cover' )#" cfsqltype="cf_sql_varchar" />
					, cover_url_thumbnail = <cfqueryparam value="#volumeInfo.cover.small#" null="#NOT StructKeyExists( volumeInfo, 'cover' )#" cfsqltype="cf_sql_varchar" />
					, api_verified = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
				WHERE id = <cfqueryparam value="#qryBooks.id#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfset updated = true />
		</cfif>
	</cfif>
	
	<cfif NOT updated>
		<cfquery datasource="scl" result="stcResult">
			UPDATE scl.books
			SET api_verified = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
			WHERE id = <cfqueryparam value="#qryBooks.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
	</cfif>
</cfloop>

<!---

<!---
<script src="https://openlibrary.org/api/books?bibkeys=ISBN:0451526538"></script>
--->
<cffunction name="resizeImage">
	<cfargument name="image_url" />
	<cfargument name="image_size" />
	
	<!---Read the image into an object --->
	<cfimage action="read" name="myImage" source="#Replace( arguments.image_url, 'https://', 'http://' )#">
	
	<!--- Set the square size of the thumb --->
	<cfset sq_size = arguments.image_size />
	
	<!--- Write the result to a file. --->
	<cfset ImageSetAntialiasing(myImage, "on")>
	<cfset ImageScaleToFit(myImage, sq_size, sq_size)>
	
	<!--- Calculate the x and y position to paste the image --->
	<cfif myImage.width GTE myImage.height>
	    <cfset x = 0 />
	    <cfset y = ceiling( ( myImage.width - myImage.height ) / 2 ) />
	<cfelse>
	    <cfset x = ceiling( ( myImage.height - myImage.width ) / 2 ) />
	    <cfset y = 0 />
	</cfif>
	
	<cfset newimg = ImageNew( "", sq_size, sq_size, "rgb", "D3D3D3" ) />
	
	<cfset ImagePaste( newimg, myImage, x, y ) />
	
	<cfimage action="border" name="newimg" source="#newimg#" color="A9A9A9" thickness="3" />	
	<cfimage action="WRITETOBROWSER" source="#newimg#" format="JPG" />										
</cffunction>

<cffunction name="createDefaultImage">
	<cfargument name="image_size" />

	<!--- Set the square size of the thumb --->
	<cfset sq_size = arguments.image_size />
	
	<!--- Write the result to a file. --->
	<cfset ImageSetAntialiasing(myImage, "on")>
	<cfset newimg = ImageNew( "", sq_size, sq_size, "rgb", "D3D3D3" ) />
	
	<cfset ImageSetDrawingColor( newimg, "A9A9A9" ) />
	
	<cfset LOCAL.Graphics = ImageGetBufferedImage( newimg ).GetGraphics() />
	<cfset LOCAL.Context = LOCAL.Graphics.getFontRenderContext() />
	<cfset LOCAL.Font = CreateObject( "java", "java.awt.Font") />
	
	<cfset LOCAL.fontName = "Courier New" />
	<cfset LOCAL.fontStyleName = "bold" />
	<cfset LOCAL.fontStyle = LOCAL.Font.BOLD />
	<cfset LOCAL.fontSize = ToString( Ceiling( sq_size / 2 ) ) />
	
	<cfset LOCAL.text = "?" />
	
	<cfset LOCAL.textFont = LOCAL.Font.Init( JavaCast( "string", LOCAL.fontName ), JavaCast( "int", LOCAL.fontStyle ), JavaCast( "int", LOCAL.fontSize ) ) />
	<cfset LOCAL.textLayout = createObject( "java", "java.awt.font.TextLayout").init( LOCAL.text, LOCAL.textFont, LOCAL.Context ) />
	<cfset LOCAL.textBounds = LOCAL.textLayout.getBounds() />
	
	<cfset LOCAL.dimen.width = textBounds.getWidth() />
	<cfset LOCAL.dimen.height = textBounds.getHeight() />
	
	<cfset ImageDrawText( newimg, LOCAL.text, newimg.width / 2 - LOCAL.dimen.width / 2, newimg.height / 2 + LOCAL.dimen.height / 2, { font="#LOCAL.fontName#", size="#LOCAL.fontSize#", style="#LOCAL.fontStyleName#" } ) />
	
	<cfimage action="border" name="newimg" source="#newimg#" color="A9A9A9" thickness="3" />	
	<cfimage action="WRITETOBROWSER" source="#newimg#" format="JPG" />										
</cffunction>

<cfloop query="qryBooks" startrow="1" endrow="100">
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
		
<!---
		<cfdump var="#jsonResults#" />
--->		
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
					<cfflush interval="10">
					<cfloop list="#qryBooks.ColumnList#" index="column">
						<tr>
							<td>#column#</td>
							<td>#qryBooks[column][currentRow]#</td>
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
<!---
	USING OPENLIBRARY API
--->
						<cfif StructKeyExists( jsonResults, "ISBN:" & qryBooks.ISBN13 )>
							<cfset volumeInfo = jsonResults[ "ISBN:" & qryBooks.ISBN13 ] />
							<td>
								<cfswitch expression="#column#">
									<cfcase value="AR_LEVELS">
									</cfcase>
									<cfcase value="AR_POINTS">
									</cfcase>
									<cfcase value="AUTHOR">
										<cfif structKeyExists( volumeInfo, "authors" )>
											<cfset authors = '' />
											<cfloop from="1" to="#ArrayLen( volumeInfo.authors )#" index="i">
												<cfset authors &= volumeInfo.authors[ i ][ 'name' ] />
												
												<cfif i LT ArrayLen( volumeInfo.authors )>
													<cfset authors &= ',' />
												</cfif>
											</cfloop>
											#authors#
										</cfif>
									</cfcase>
									<cfcase value="BINDING">
									</cfcase>
									<cfcase value="CLASSIFICATION">
									</cfcase>
									<cfcase value="COVER_URL">
										<cfif structKeyExists( volumeInfo, "cover" )>
											#volumeInfo.cover.large#
											<img src="#volumeInfo.cover.large#" />
											<cfset resizeImage( volumeInfo.cover.large, 200 ) />
										<cfelse>
											<cfset createDefaultImage( 200 ) />
										</cfif>
									</cfcase>
									<cfcase value="COVER_URL_THUMBNAIL">
										<cfif structKeyExists( volumeInfo, "cover" )>
											#volumeInfo.cover.small#
											<cfset resizeImage( volumeInfo.cover.small, 50 ) />
										<cfelse>
											<cfset createDefaultImage( 50 ) />
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
										<cfif structKeyExists( volumeInfo, "identifiers" )>
											<cfloop collection="#volumeInfo.identifiers#" item="ident">
												<cfif ident EQ 'isbn_10'>
													#volumeInfo.identifiers[ ident ][1]#
												</cfif>
											</cfloop>
										</cfif>
									</cfcase>
									<cfcase value="ISBN13">
										<cfif structKeyExists( volumeInfo, "identifiers" )>
											<cfloop collection="#volumeInfo.identifiers#" item="ident">
												<cfif ident EQ 'isbn_13'>
													#volumeInfo.identifiers[ ident ][1]#
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
										<cfif structKeyExists( volumeInfo, "number_of_pages" )>
											#volumeInfo.number_of_pages#
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
						<cfelse>
							<td></td>
						</cfif>
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

--->