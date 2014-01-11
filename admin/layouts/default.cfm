<cfset request.layout = false>

<!doctype html>
<cfoutput>
	<html>
		<head lang="en">
			<meta charset="utf-8">
			
			<base href="#rc.basehref#">
			
			<!--- title set by a view - there is no default --->
			<title>FW/1 Skeleton - <cfoutput>#rc.title#</cfoutput></title>
			
			<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
			<script src="//ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.min.js" type="text/javascript"></script>
		</head>
		<body>

			<div id="container">
				<div id="content">
					<cfif StructKeyExists( rc, "CurrentUser" )>
						<h2><small>Welcome, #rc.CurrentUser.getName()#!</small></h2>
						<a href="#buildURL( 'security/logout' )#">Logout</a>
					</cfif>
					
					#body#
					
				</div>
				
				<footer id="footer">
					<div>
						<p style="font-size: small;">
							Powered by FW/1 version <cfoutput>#variables.framework.version#</cfoutput>.<br />
							This request took <cfoutput>#getTickCount() - rc.startTime#</cfoutput>ms.
						</p>
					</div>
				</footer>
			</div>
		</body>
	</html>
</cfoutput>