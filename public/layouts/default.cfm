<cfset request.layout = false>

<!doctype html>
<cfoutput>
	<html lang="en">
		<head>
			<meta charset="utf-8">
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
			
			<base href="#rc.basehref#">
			
			<!--- title set by a view - there is no default --->
			<title>Classroom Library - <cfoutput>#rc.title#</cfoutput></title>
			
	    <!-- Bootstrap -->
			<!-- Latest compiled and minified CSS -->
			<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css">
			<!-- Optional theme -->
			<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap-theme.min.css">
			<link rel="stylesheet" href="public/assets/css/signin.css" />
			<link rel="stylesheet" href="public/assets/css/sticky-footer-navbar.css" />
			
			<!-- JavaScript Libraries -->
			<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
			<script src="//ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.min.js" type="text/javascript"></script>
			<!-- Latest compiled and minified JavaScript -->
			<script src="//netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>		
			
	    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
	    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	    <!--[if lt IE 9]>
	      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
	      <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
	    <![endif]-->
		</head>
		
		<body>
			
			<div id="wrap">
				<div class="navbar navbar-default navbar-fixed-top" role="navigation">
					<div class="container">
	          <div class="navbar-header">
							<a class="navbar-brand">Mr. Mulligan's Classroom Library</a>
						</div>
						<div class="navbar-collapse collapse">
							<ul class="nav navbar-nav navbar-right">
								<cfif StructKeyExists( rc, "CurrentUser" )>
									<form class="navbar-form navbar-left" action="#buildURL( 'book/search' )#" role="search">
									  <div class="form-group">
											<label for="filterCriteria" class="sr-only">Enter search criteria for book</label>
											<input type="text" id="filterCriteria" name="filterCriteria" class="form-control" placeholder="Find a book"  />
											<input type="hidden" name="#rc.sessionName#" value="#rc.token#" />
											<input type="hidden" name="context" value="bookSearch" />
									  </div>
									  <button type="submit" id="btnSearch" name="btnSearch" class="btn btn-default">Search</button>
									</form>
			            <li><a href="#buildURL( 'security/logout' )#">Logout</a></li>
								</cfif>
		          </ul>							
		        </div>						
					</div>
				</div>
				
				<div class="container">
					<cfif StructKeyExists( rc, "CurrentUser" )>
						<div class="row spacer">
							<div class="col-md-12">
		        		<h3>Welcome, #rc.CurrentUser.getName()#!</h3>
							</div>
						</div>
					</cfif>

					#body#
				</div>
			</div>

			<div id="footer">
				<div class="container">
					<p class="text-muted">
						Powered by FW/1 version <cfoutput>#variables.framework.version#</cfoutput>.<br />
					</p>
				</div>
			</div>
				
		</body>
	</html>
</cfoutput>