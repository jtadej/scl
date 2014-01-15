<cfset rc.title = "Book Search View" />	<!--- set a variable to be used in a layout --->

<cfoutput>
	<div><h1>Welcome</h1></div>
	
	<cfif StructKeyExists( rc, "result" ) and rc.result.hasMessage()>
  	<div>#rc.result.getMessage()#</div>
	</cfif>
	
	#view( 'main/bookbag' )#
	
	<form id="frmBookSearch" action="#buildURL( 'book/search' )#" method="POST">
			
			<div>
				<label for="filterCriteria">Enter search criteria for book</label>
				<div>
					<input type="text" id="filterCriteria" name="filterCriteria" placeholder="Book search criteria" value="#rc.filterCriteria#" autofocus />
				</div>
			</div>
			
			<div>
				<input type="hidden" name="#rc.sessionName#" value="#rc.token#" />
				<input type="hidden" name="context" value="#rc.context#" />
				<input type="submit" name="btnSearch" id="btnSearch" value="Search">
			</div>
	</form>
	
	<cfif StructKeyExists( rc, "results" )>
		<table border="1">
			<thead>
				<tr>
					<th>Cover</th>
					<th>Title</th>
					<th>Author</th>
					<th>Check Out</th>
				</tr>
			</thead>
			<tbody>
				<cfloop from="1" to="#ArrayLen( rc.results )#" index="LOCAL.i">
					<cfset local.book = rc.results[ LOCAL.i ] />
					<tr>
						<td>#rc.objImageService.createImage( LOCAL.i, rc.intThumbnailSize, LOCAL.book.getCoverThumbnailURL() )#</td>
						<td>#LOCAL.book.getTitle()#</td>
						<td>#LOCAL.book.getAuthor()#</td>
						<td><a href="#buildURL( action = 'book.checkout?id=' & LOCAL.book.getId() )#">Check Out</a></td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	</cfif>
	
</cfoutput>
