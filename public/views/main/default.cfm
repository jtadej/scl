<cfset rc.title = "Main View" />	<!--- set a variable to be used in a layout --->

<cfoutput>
	<div><h1>Welcome</h1></div>
	
	<cfif StructKeyExists( rc, "result" ) and rc.result.hasMessage()>
  	<div>#rc.result.getMessage()#</div>
	</cfif>
	
	<div>
		<p>You can check out #rc.intAvailableBooks# more books!</p>
	</div>
	
	<form id="frmBookUpdate" action="#buildURL( 'book.update' )#" method="POST">
			
			<div>
				<label for="barcode">Scan the book's barcode</label>
				<div>
					<input type="text" id="barcode" name="barcode" placeholder="Book's barcode" autofocus />
				</div>
			</div>
			
			<div>
				<input type="hidden" name="#rc.sessionName#" value="#rc.token#" />
				<input type="hidden" name="context" value="#rc.context#" />
				<input type="submit" name="btnUpdate" id="btnUpdate" value="Update">
			</div>
	</form>
	
	<div>
		<fieldset>
			<legend>Your bookbag ( #ArrayLen( rc.arrCheckedOutBooks )# )</legend>
				<ul>
					<cfloop from="1" to="#ArrayLen( rc.arrCheckedOutBooks )#" index="variables.i">
						<cfset variables.book = rc.arrCheckedOutBooks[ variables.i ] /> 
						<li style="display: inline-block; width: 100px; text-align: center; vertical-align: top;">
							#( variables.book.getCoverThumbnailURL() EQ '') ? 
												rc.objImageService.createDefaultImage( variables.i, rc.intThumbnailSize ) 
											: rc.objImageService.resizeImage( variables.book.getCoverThumbnailURL(), rc.intThumbnailSize )#
							<br />
							<a><small>#variables.book.getTitle()#</small></a>
						</li>
					</cfloop>
					<cfloop from="1" to="#rc.intAvailableBooks#" index="i">
						<li style="display: inline-block; width: 100px; text-align: center; vertical-align: top;">#rc.objImageService.createDefaultImage( "?", rc.intThumbnailSize )#</li>
					</cfloop>
				</ul>
		</fieldset>
	</div>
	
	<div>
		<a href="#buildURL( 'books.search' )#">Search for books</a>
	</div>
	
	#rc.Validator.getInitializationScript()#

	#rc.Validator.getValidationScript( formName="frmBookUpdate", context="#rc.context#" )#
</cfoutput>