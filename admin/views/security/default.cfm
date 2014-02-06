<cfset rc.title = "Login View" />	<!--- set a variable to be used in a layout --->

<cfoutput>
	<form id="frmLogin" class="form-signin" action="#buildURL( 'security/login' )#" role="form" method="POST">
		<div class="input-group input-group-lg">
			<span class="input-group-addon">
				<span class="glyphicon glyphicon-user"></span>
			</span>
			<label for="username" class="sr-only">Username</label>
			<input type="text" id="username" name="username" class="form-control" placeholder="Username" autofocus />
		</div>
		
		<label for="password" class="sr-only">Password</label>
		<input type="password" id="password" name="password" class="form-control input-lg" placeholder="Password" />
		
		<input type="hidden" name="#rc.sessionName#" value="#rc.token#" />
		<input type="hidden" name="context" value="#rc.context#" />
		<input type="submit" id="login" name="login" class="btn btn-lg btn-block btn-default" value="Login" />
	</form>
	
	#rc.Validator.getInitializationScript()#

	#rc.Validator.getValidationScript( formName="frmLogin", context="#rc.context#" )#
</cfoutput>