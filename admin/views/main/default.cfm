<cfoutput>
	<cfif rc.CurrentUser.isTeacher()>
		You have #rc.CurrentUser.numOfStudents()# student#( rc.CurrentUser.numOfStudents() NEQ 1 ) ? 's' : ''# in your class.
	</cfif>
	
	<cfif rc.CurrentUser.isAdmin()>
		You manage #rc.CurrentUser.numOfTeachers()# teacher#( rc.CurrentUser.numOfTeachers() NEQ 1 ) ? 's' : ''#.
	</cfif>
</cfoutput>

<!---

<cfquery name="qryData" datasource="scl">
	SELECT id, username, barcode
	FROM users
	WHERE barcode IS NOT NULL
</cfquery>

<cfsavecontent variable="strMHTData">
	<cfinclude template="generate_label.cfm" />
</cfsavecontent>
<cfset strMHTData = Trim( strMHTData ) />

<cfdocument format="PDF" name="labels" overwrite="Yes">
<cfoutput>#strMHTData#</cfoutput>
</cfdocument>

<cfheader name="content-disposition" value="attachment; filename=shipping-labels.pdf" />
<cfcontent type="application/octet-stream" variable="#labels#" />

--->



<!---
<cfquery name="qryData" datasource="scl">
	SELECT id, username, barcode
	FROM users
	WHERE barcode IS NOT NULL
</cfquery>

<cfsavecontent variable="strMHTData">
	<cfinclude template="generate_label.cfm" />
</cfsavecontent>

<cfset strMHTData = Trim( strMHTData ) />

<cfheader name="content-disposition" value="attachment; filename=shipping-labels.mht" />

<cfcontent type="application/msword" variable="#ToBinary( ToBase64( strMHTData ) )#" />
--->

<cfquery name="qryStudents" datasource="scl">
	SELECT id, username, barcode
	FROM users
	WHERE barcode IS NOT NULL
</cfquery>

<cfquery name="qryBooks" datasource="scl">
	SELECT id, title, isbn13
	FROM books
	WHERE isbn13 IS NOT NULL
	LIMIT 20 
</cfquery>


<script type="text/javascript">
	/* <![CDATA[ */
	$( function() {
		<cfoutput>
			<cfloop query="qryStudents">
				$("##barcode_#qryStudents.id#").html( DrawCode39Barcode( '#qryStudents.barcode#', 0 ) );
				$("##barcode_#qryStudents.id# span").css( "height", "25px" );
			</cfloop>
			
			<cfloop query="qryBooks">
				$("##isbn_#qryBooks.id#").html( DrawCode39Barcode( '#qryBooks.isbn13#', 0 ) );
				$("##isbn_#qryBooks.id# span").css( "height", "25px" );
			</cfloop>
		</cfoutput>
		});
	/* ]]> */
</script>


<h1>ColdFusion Users</h1>
<table border="0">
	<thead>
		<tr>
			<th>Username</th>
			<th>Barcode Image</th>
			<th>Username</th>
			<th>Barcode Image</th>
		</tr>
	</thead>
	<tbody>
		<cfoutput>
			<cfloop query="qryStudents">
				<cfif qryStudents.currentRow MOD 2 EQ 1>
					<tr>
				</cfif>
					<td>#qryStudents.username#</td>
					<td>
						#rc.objCode39Service.DrawCode39Barcode( qryStudents.barcode, 0, 25 )#
					</td>
				<cfif qryStudents.currentRow MOD 2 EQ 0>
					</tr>
				</cfif>
			</cfloop>
		</cfoutput>
	</tbody>
</table>

<h1>ColdFusion Books</h1>
<table border="0">
	<thead>
		<tr>
			<th>Username</th>
			<th>Barcode Image</th>
			<th>Username</th>
			<th>Barcode Image</th>
		</tr>
	</thead>
	<tbody>
		<cfoutput>
			<cfloop query="qryBooks">
				<cfif qryBooks.currentRow MOD 2 EQ 1>
					<tr>
				</cfif>
					<td>#qryBooks.title#</td>
					<td>
						#rc.objCode39Service.DrawCode39Barcode( qryBooks.isbn13, 0, 25 )#
					</td>
				<cfif qryBooks.currentRow MOD 2 EQ 0>
					</tr>
				</cfif>
			</cfloop>
		</cfoutput>
	</tbody>
</table>

<!---

<h1>JavaScript Users</h1>
<table border="1">
	<thead>
		<tr>
			<th>Username</th>
			<th>Barcode Image</th>
			<th>Username</th>
			<th>Barcode Image</th>
		</tr>
	</thead>
	<tbody>
		<cfoutput>
			<cfloop query="qryStudents">
				<cfif qryStudents.currentRow MOD 2 EQ 1>
					<tr>
				</cfif>
					<td>#qryStudents.username#</td>
					<td id="barcode_#qryStudents.id#"></td>
				<cfif qryStudents.currentRow MOD 2 EQ 0>
					</tr>
				</cfif>
			</cfloop>
		</cfoutput>
	</tbody>
</table>


<h1>JavaScript Books</h1>
<table border="1">
	<thead>
		<tr>
			<th>Username</th>
			<th>Barcode Image</th>
			<th>Username</th>
			<th>Barcode Image</th>
		</tr>
	</thead>
	<tbody>
		<cfoutput>
			<cfloop query="qryBooks">
				<cfif qryBooks.currentRow MOD 2 EQ 1>
					<tr>
				</cfif>
					<td>#qryBooks.title#</td>
					<td id="isbn_#qryBooks.id#"></td>
				<cfif qryBooks.currentRow MOD 2 EQ 0>
					</tr>
				</cfif>
			</cfloop>
		</cfoutput>
	</tbody>
</table>
--->


<!---
<cfquery name="qryStudents" datasource="scl">
	SELECT id, username, barcode
	FROM users
	WHERE barcode IS NOT NULL
</cfquery>

<script type="text/javascript">
	/* <![CDATA[ */
	$( function() {
		<cfoutput>
			<cfloop query="qryStudents">
				$("##barcode_#qryStudents.id#").html( DrawCode39Barcode( '#qryStudents.barcode#', 0 ) );
				$("##barcode_#qryStudents.id# span").css( "height", "25px" );
			</cfloop>
		</cfoutput>
		});
	/* ]]> */
</script>

<style>
	td.barcode span {
		height: .5in; 
		}
</style>


<table border="1">
	<thead>
		<tr>
			<th>Username</th>
			<th>Barcode Image</th>
			<th>Username</th>
			<th>Barcode Image</th>
		</tr>
	</thead>
	<tbody>
		<cfoutput>
			<cfloop query="qryStudents">
				<cfif qryStudents.currentRow MOD 2 EQ 1>
					<tr>
				</cfif>
					<td>#qryStudents.username#</td>
					<td id="barcode_#qryStudents.id#" class="barcode"></td>
				<cfif qryStudents.currentRow MOD 2 EQ 0>
					</tr>
				</cfif>
			</cfloop>
		</cfoutput>
	</tbody>
</table>
--->