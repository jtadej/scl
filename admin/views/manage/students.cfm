<cfoutput>
	<table border="1">
		<thead>
			<th>Name</th>
			<th>Books</th>
		</thead>
		<tbody>
			<cfloop index="variables.student" array="#rc.currentUser.getStudents()#">
				<tr>
					<td>#variables.student.getName()#</td>
					<td>#variables.student.numOfBooksCheckedOut()# / #variables.student.getNumBooksAllowed()#</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
</cfoutput>