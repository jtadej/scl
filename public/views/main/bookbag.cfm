<cfoutput>
	<div>
		<fieldset>
			<legend>Your bookbag ( #ArrayLen( rc.arrCheckedOutBooks )# )</legend>
				<ul>
					<cfloop from="1" to="#ArrayLen( rc.arrCheckedOutBooks )#" index="variables.i">
						<cfset variables.book = rc.arrCheckedOutBooks[ variables.i ] /> 
						<li style="display: inline-block; width: 100px; text-align: center; vertical-align: top;">
							#rc.objImageService.createImage( variables.i, rc.intThumbnailSize, variables.book.getCoverThumbnailURL(), 'normal' )#
							<br />
							<a><small>#variables.book.getTitle()#</small></a>
						</li>
					</cfloop>
					<cfloop from="1" to="#rc.intAvailableBooks#" index="i">
						<li style="display: inline-block; width: 100px; text-align: center; vertical-align: top;">#rc.objImageService.createImage( "?", rc.intThumbnailSize )#</li>
					</cfloop>
				</ul>
		</fieldset>
	</div>
</cfoutput>