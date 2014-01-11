<cfset rc.title = "Login View" />	<!--- set a variable to be used in a layout --->

<cfoutput>
	<div><h1>Login</h1></div>
	
	<form id="frmLogin" action="#buildURL( 'security/login' )#" method="POST">
		<fieldset>
			<legend>Login Form</legend>
			
			<div>
				<label for="username">Username</label>
				<div>
					<input type="text" id="username" name="username" placeholder="Username" />
				</div>
			</div>
			
			<div>
				<label for="password">Password</label>
				<div>
					<input type="password" id="password" name="password" placeholder="Password" />
				</div>
			</div>
			
			<div>
				<input type="hidden" name="#rc.sessionName#" value="#rc.token#" />
				<input type="submit" name="login" id="login" value="Login">
			</div>
		</fieldset>
	</form>
	
	#rc.Validator.getInitializationScript()#

	#rc.Validator.getValidationScript( formName="frmLogin", context="login" )#
</cfoutput>