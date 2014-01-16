<cfoutput>
	<div class="panel panel-default">
	  <div class="panel-heading">
	    <h3 class="panel-title">Your bookbag ( #ArrayLen( rc.arrCheckedOutBooks )# )</h3>
	  </div>
	  <div class="panel-body">
			<div class="row">
				<cfloop from="1" to="#ArrayLen( rc.arrCheckedOutBooks )#" index="variables.i">
					<cfset variables.book = rc.arrCheckedOutBooks[ variables.i ] /> 
						
				  <div class="col-xs-4 col-md-2">
				    <a class="thumbnail">
				    	<cfset local.emptyText = ( Len( variables.book.getTitle() ) GT 10 ) ? Left( variables.book.getTitle(), 7 ) & '...' : variables.book.getTitle() />
				      <img data-src="holder.js" style="height: 180px; width: 100%; display: block;" src="#( variables.book.getCoverURL() NEQ '' ) ? variables.book.getCoverURL() : 'http://placehold.it/180&text=' & local.emptyText#" />
				    </a>
						<div class="caption">
			        <p class="text-center"><a href="#buildURL( 'book.processBook?id=' & variables.book.getId() )#">#variables.book.getTitle()#</a></p>
			      </div>
				  </div>
				</cfloop>
				<cfloop from="1" to="#rc.intAvailableBooks#" index="i">
				  <div class="col-xs-4 col-md-2">
				    <a class="thumbnail">
				      <img data-src="holder.js" style="height: 180px; width: 100%; display: block;" src="http://placehold.it/180&text=Empty" />
				    </a>
				  </div>
				</cfloop>
			</div>
	  </div>
	</div>
</cfoutput>