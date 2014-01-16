<cfset rc.title = "Main View" />	<!--- set a variable to be used in a layout --->

<cfoutput>
	#view( 'helpers/messages' )#	
	
	#view( 'book/results' )#

	<div class="row spacer">
		<div class="col-md-4">
			<form id="frmBookUpdate" class="form-inline" role="form" action="#buildURL( 'book.update' )#" method="POST">
				<div class="form-group">
					<label for="barcode" class="sr-only">Book barcode</label>
					<div class="input-group">
						<span class="input-group-addon">
							<span class="glyphicon glyphicon-barcode"></span>
						</span>
						<input type="text" id="barcode" name="barcode" class="form-control" placeholder="Scan the book's barcode" autofocus />
						<input type="hidden" name="#rc.sessionName#" value="#rc.token#" />
						<input type="hidden" name="context" value="#rc.context#" />
						<span class="input-group-btn">
							<input type="submit" id="btnUpdate" name="btnUpdate" class="btn btn-default" value="Update">
						</span>
					</div>
				</div>
				
			</form>
		</div>
		<div class="col-md-4 col-md-offset-4">
			<h4 class="text-right"></string>You can check out #rc.intAvailableBooks# more #( rc.intAvailableBooks LT 2 ) ? 'book' : 'books'#!</h4>
		</div>
	</div>

	#view( 'main/bookbag' )#
	
	#rc.Validator.getInitializationScript()#

	#rc.Validator.getValidationScript( formName="frmBookUpdate", context="#rc.context#" )#
</cfoutput>