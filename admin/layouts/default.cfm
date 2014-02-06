<cfset request.layout = false>

<!doctype html>
<cfoutput>
	<html>
		<head lang="en">
			<meta charset="utf-8">
			
			<base href="#rc.basehref#">
			
			<!--- title set by a view - there is no default --->
			<title>My Classroom Library Admin - <cfoutput>#rc.title#</cfoutput></title>
			
	    <!-- Bootstrap -->
			<!-- Latest compiled and minified CSS -->
			<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css" />
			<!-- Optional theme -->
			<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap-theme.min.css" />
			<link rel="stylesheet" href="public/assets/css/signin.css" />
			<link rel="stylesheet" href="public/assets/css/sticky-footer-navbar.css" />
			<!-- jQuery DataTables plug-in -->
			<link rel="stylesheet" href="http://datatables.net/media/blog/bootstrap_2/DT_bootstrap.css" />
			
			<!-- JavaScript Libraries -->
			<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
			<script src="//ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.min.js" type="text/javascript"></script>
			<!-- Latest compiled and minified JavaScript -->
			<script src="//netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>		
			<!-- jQuery DataTables plug-in -->
			<script src="//ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.4/jquery.dataTables.min.js"></script>

			
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
							<a class="navbar-brand" href="#buildURL( 'main' )#">Mr. Mulligan's Classroom Library</a>
							<cfif StructKeyExists( rc, "CurrentUser" )>
								<button class="navbar-toggle collapsed" type="button" data-toggle="collapse" data-target=".bs-navbar-collapse">
					        <span class="sr-only">Toggle navigation</span>
					        <span class="icon-bar"></span>
					        <span class="icon-bar"></span>
					        <span class="icon-bar"></span>
					      </button>
							</cfif>
						</div>
						<div class="navbar-collapse bs-navbar-collapse navbar-collapse collapse">
							<ul class="nav navbar-nav navbar-right">
								<cfif StructKeyExists( rc, "CurrentUser" )>
									<li class="dropdown">
						        <a href="##" class="dropdown-toggle" data-toggle="dropdown">Reports <b class="caret"></b></a>
						        <ul class="dropdown-menu">
					            <li><a href="#buildURL( 'reports/studentBarcodes' )#" data-target="##myModal" data-toggle="modal">Student Barcode List</a></li>
					            <li><a data-target="##myModal" data-toggle="modal">Checked Out Books</a></li>
						        </ul>
						      </li>
									<li class="dropdown">
						        <a href="##" class="dropdown-toggle" data-toggle="dropdown">Manage <b class="caret"></b></a>
						        <ul class="dropdown-menu">
											<cfif rc.CurrentUser.isAdmin()>
						            <li><a href="#buildURL( 'manage/teachers' )#">Teachers</a></li>
											</cfif>
											<cfif rc.CurrentUser.isTeacher()>
						            <li><a href="#buildURL( 'manage/students' )#">Students</a></li>
											</cfif>
						        </ul>
						      </li>
			            <li><a href="#buildURL( 'security/logout' )#">Logout</a></li>
								</cfif>
		          </ul>							
		        </div>						
					</div>
				</div>
				
				<div class="container">
						<div class="pull-left">
							<cfif StructKeyExists( rc, "CurrentUser" )>
		        		<h2>Welcome, #rc.CurrentUser.getName()#!</h2>
							</cfif>
						</div>
						<div class="pull-right">
							#view( 'helpers/messages' )#	
						</div>
						
					<div class="row header_row">
					</div>

					#view( 'modal/report' )#
					
					#body#
				</div>
			</div>
				
			<div id="footer">
				<div class="container">
					<p class="pull-right text-muted">
						Powered by FW/1 version <cfoutput>#variables.framework.version#</cfoutput>.<br />
					</p>
				</div>
			</div>
			
		</body>
	</html>
</cfoutput>