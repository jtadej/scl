<cfoutput>
	<cfif StructKeyExists( rc, "result" ) and rc.result.hasMessage()>
  	<div class="row spacer">
  		<div class="col-md-12">
  			<span class="label <cfif rc.result.getIsSuccess()>label-success<cfelse>label-danger</cfif>">#rc.result.getMessage()#</span>
  		</div>
		</div>
	</cfif>
</cfoutput>