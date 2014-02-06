<cfset rc.title = "Book Search View" />	<!--- set a variable to be used in a layout --->

<cfoutput>

	<cfif StructKeyExists( rc, "results" )>
		<table id="tblResults" name="tblResults" class="table table-bordered table-striped table-hover table-condensed">
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
	
	<script language="JavaScript" src="public/assets/js/bootstrap_pagination.js"></script>
	<script language="JavaScript">
	$(document).ready(function(){
	  $('##tblResults').dataTable( {
				"iDisplayLength": 5
			,	"sDom": "<'row'<'col-xs-6'T><'col-xs-6'f>r>t<'row'<'col-xs-6'i><'col-xs-6'p>>"
			, "sPaginationType": "bootstrap"
			, "oLanguage": {
					"sInfo": "_START_ to _END_ of _TOTAL_ books"
				,	"sInfoFiltered": "(filtered from _MAX_)"
				, "oPaginate": {
						"sPrevious": "&larr;"
					,	"sNext": "&rarr;"
						}
					}
			}	);
		});
	</script>
	
</cfoutput>
