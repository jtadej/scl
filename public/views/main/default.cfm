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

	#view( 'main/bookbag' )#
	
	<div>
		<a href="#buildURL( 'book' )#">Search for books</a>
	</div>
	
	#rc.Validator.getInitializationScript()#

	#rc.Validator.getValidationScript( formName="frmBookUpdate", context="#rc.context#" )#
</cfoutput>