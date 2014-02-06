<cfoutput>
	<cfif StructKeyExists( rc, "result" ) and rc.result.hasMessage()>
		<div class="alert alert-pepr alert-dismissable <cfif rc.result.getIsSuccess()>alert-success<cfelse>alert-danger</cfif> fade in">
			<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
			#rc.result.getMessage()#
		</div>
	</cfif>
</cfoutput>