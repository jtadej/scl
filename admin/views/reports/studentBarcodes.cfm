<cfset request.layout = false />

THIS IS THE STUDENT BARCODE REPORT!

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


<h1>ColdFusion Users</h1>
<table>
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
						#rc.objCode39Service.DrawCode39Barcode( qryStudents.barcode, 0, 0.25 )#
					</td>
				<cfif qryStudents.currentRow MOD 2 EQ 0>
					</tr>
				</cfif>
			</cfloop>
		</cfoutput>
	</tbody>
</table>
