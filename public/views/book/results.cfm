<cfset rc.title = "Book Search View" />	<!--- set a variable to be used in a layout --->

<cfoutput>

	<cfif StructKeyExists( rc, "results" )>
		<table class="table table-bordered table-hover table-condensed">
			<thead>
				<tr>
					<th>Title</th>
					<th>Author</th>
				</tr>
			</thead>
			<tbody>
				<cfloop from="1" to="#ArrayLen( rc.results )#" index="LOCAL.i">
					<cfset local.book = rc.results[ LOCAL.i ] />
					<tr>
						<td><a href="#buildURL( action = 'book.processBook?id=' & LOCAL.book.getId() )#">#LOCAL.book.getTitle()#</a></td>
						<td>#LOCAL.book.getAuthor()#</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	</cfif>
	
</cfoutput>
