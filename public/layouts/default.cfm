<cfset request.layout = false>

<!doctype html>
<cfoutput>
	<html lang="en">
		<head>
			<meta charset="utf-8">
			
			<base href="#rc.basehref#">
			
			<!--- title set by a view - there is no default --->
			<title>FW/1 Skeleton - <cfoutput>#rc.title#</cfoutput></title>
			
<!---
			<link href="assets/bootstrap/css/bootstrap.min.css" rel="stylesheet">
			<link href="assets/bootstrap/css/bootstrap-responsive.min.css" rel="stylesheet">
			<link href="assets/css/smoothness/jquery-ui-1.8.19.custom.css" rel="stylesheet">
			<link href="assets/css/core.css?r=#rc.config.revision#" rel="stylesheet">
--->

			<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<!---
			<script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.9.2/jquery-ui.min.js"></script>
--->
			<script src="//ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.min.js" type="text/javascript"></script>
<!---
			<script src="assets/js/jquery.field.min.js"></script>
			<script src="assets/bootstrap/js/bootstrap.min.js"></script>
			<script src="assets/ckeditor/ckeditor.js"></script>
			<script src="assets/js/core.js?r=#rc.config.revision#"></script>
--->
		</head>
		<body>
<!---
			<cfif rc.config.development>
</cfoutput>				<span class="dev-mode label label-warning">Development Mode</span>
			</cfif>			
			
			<div id="container" class="container">
				<div id="content" class="row" role="main">
					<div class="span12">
						<h2 class="pull-right"><cfif StructKeyExists( rc, "CurrentUser" )><small class="pull-right">#rc.CurrentUser.getName()#</small></cfif></h2>
					
					#body#
					
						<div class="clearfix append-bottom"></div>
					</div>
				</div>
				
				<footer id="footer" class="row" role="contentinfo">
					<div class="span12">
						<p style="font-size: small;">
							Powered by FW/1 version <cfoutput>#variables.framework.version#</cfoutput>.<br />
							This request took <cfoutput>#getTickCount() - rc.startTime#</cfoutput>ms.
						</p>
					</div>
				</footer>
			</div>
--->
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