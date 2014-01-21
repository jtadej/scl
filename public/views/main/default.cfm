<cfset rc.title = "Main View" />	<!--- set a variable to be used in a layout --->

<cfoutput>
	<div id="myModal" name="myModal" class="modal fade" tabindex="-1">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	        <h4 class="modal-title">Search Results</strong></h4>
	      </div>
	      <div class="modal-body">
					#view( 'book/results' )#
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
	      </div>
	    </div><!-- /.modal-content -->
	  </div><!-- /.modal-dialog -->
	</div><!-- /.modal -->

	<div class="row spacer">
		<div class="col-xs-8 col-sm-6 col-md-4">
			<form id="frmBookUpdate" class="form-inline" role="form" action="#buildURL( 'book/update' )#" method="POST">
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
	</div>

	#view( 'main/bookbag' )#
	
	<script language="JavaScript">
		$(function() {
			<cfif StructKeyExists( rc, "results" )>
				$('##myModal').modal('show');
			</cfif> 
			});
	</script>
	
	#rc.Validator.getInitializationScript()#

	#rc.Validator.getValidationScript( formName="frmBookUpdate", context="#rc.context#" )#
</cfoutput>