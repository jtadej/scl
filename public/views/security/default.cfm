<cfset rc.title = "Login View" />	<!--- set a variable to be used in a layout --->

<cfoutput>
<!---
	<div class="page-header hide"><h1>Login</h1></div>

	<form id="frmLogin" action="#buildURL( 'security.login' )#" method="POST" class="form-horizontal">
		<fieldset>
			<legend>Login Form</legend>
			
			#view( "helpers/messages" )#
	
			<div class="control-group <cfif rc.result.hasErrors( 'barcode' )>error</cfif>">
				<label class="control-label" for="barcode">User ID</label>
				<div class="controls">
					<input class="input-xlarge" type="text" id="barcode" name="barcode" placeholder="User ID" />
					#view( "helpers/failures", { property="barcode" })#
					<p class="help-block"><a href="#buildURL( 'security.loginPass' )#">Login with username/password</a></p>
				</div>
			</div>
			
			<div class="form-actions">
				<input type="submit" name="login" id="login" value="Login" class="btn btn-primary">
			</div>
		</fieldset>
	</form>
--->
	<div><h1>Login</h1></div>
	
	<cfif StructKeyExists( rc, "result" ) and rc.result.hasMessage()>
  	<div>#rc.result.getMessage()#</div>
	</cfif>
	
	<form id="frmLogin" action="#buildURL( 'security/login' )#" method="POST">
		<fieldset>
			<legend>Login Form</legend>
			
			<cfif rc.context EQ 'loginFull'>
				<div>
					<label for="username">Username</label>
					<div>
						<input type="text" id="username" name="username" placeholder="Username" autofocus />
					</div>
				</div>
				
				<div>
					<label for="password">Password</label>
					<div>
						<input type="password" id="password" name="password" placeholder="Password" />
						<p><a href="#buildURL( 'security' )#">Login with User ID</a></p>
					</div>
				</div>
			<cfelse>
				<div>
					<label for="barcode">User ID</label>
					<div>
						<input type="text" id="barcode" name="barcode" placeholder="User ID" autofocus />
						<p><a href="#buildURL( 'security?context=loginFull' )#">Login with username/password</a></p>
					</div>
				</div>
			</cfif>
			
			<div>
				<input type="hidden" name="#rc.sessionName#" value="#rc.token#" />
				<input type="hidden" name="context" value="#rc.context#" />
				<input type="submit" name="login" id="login" value="Login">
			</div>
		</fieldset>
	</form>
	
	#rc.Validator.getInitializationScript()#

	#rc.Validator.getValidationScript( formName="frmLogin", context="#rc.context#" )#
</cfoutput>