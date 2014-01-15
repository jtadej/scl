<cfcomponent>
	<cffunction name="createImage">
		<cfargument name="text" default="" />
		<cfargument name="image_size" />
		<cfargument name="image_url" default="" />
		<cfargument name="status" default="" />
	
		<!--- Set the square size of the thumb --->
		<cfset LOCAL.sq_size = arguments.image_size />
		
		<!--- Change from https to http for openlibrary images --->
		<cfset ARGUMENTS.image_url = Replace( ARGUMENTS.image_url, 'https://', 'http://' ) />
		
		<!--- Set colors based on status --->
		<cfswitch expression="#status#">
			<cfcase value="normal">
				<cfset LOCAL.bgColor = "CCFF99" />
				<cfset LOCAL.fgColor = "009900" />
			</cfcase>
			<cfcase value="overdue">
				<cfset LOCAL.bgColor = "DC143C" />
				<cfset LOCAL.fgColor = "8B0000" />
			</cfcase>
			<cfdefaultcase>
				<cfset LOCAL.bgColor = "D3D3D3" />
				<cfset LOCAL.fgColor = "A9A9A9" />
			</cfdefaultcase>
		</cfswitch>
		
		<!--- Create a default image background. --->
		<cfset LOCAL.newimg = ImageNew( "", LOCAL.sq_size, LOCAL.sq_size, "rgb", LOCAL.bgColor ) />
		
		<!--- Setup antialiasing and the drawing color for image --->
		<cfset ImageSetAntialiasing( LOCAL.newimg, "on" )>
		<cfset ImageSetDrawingColor( LOCAL.newimg, LOCAL.fgColor ) />
		
		<cfset LOCAL.defaultImage = true />
		<cfif ARGUMENTS.image_url NEQ ''>
			<cfhttp method="head" url="#ARGUMENTS.image_url#" />
			<cfif cfhttp.statusCode IS '200 OK'>
				<cfset LOCAL.defaultIMage = false />
			</cfif>
		</cfif>
		
		<!--- if there is an image_url read it and paste it on the default image --->
		<cfif NOT LOCAL.defaultImage>
			<!---Read the image into an object, then scale to size --->
			<cfimage action="read" name="LOCAL.myImage" source="#ARGUMENTS.image_url#" />
			<cfset ImageScaleToFit( LOCAL.myImage, LOCAL.sq_size, LOCAL.sq_size ) />

			<!--- Calculate the x and y position to paste the image --->
			<cfif LOCAL.myImage.width GTE LOCAL.myImage.height>
		    <cfset LOCAL.x = 0 />
		    <cfset LOCAL.y = ceiling( ( LOCAL.myImage.width - LOCAL.myImage.height ) / 2 ) />
			<cfelse>
		    <cfset LOCAL.x = ceiling( ( LOCAL.myImage.height - LOCAL.myImage.width ) / 2 ) />
		    <cfset LOCAL.y = 0 />
			</cfif>
			
			<cfset ImagePaste( LOCAL.newimg, LOCAL.myImage, LOCAL.x, LOCAL.y ) />
		<!--- otherwise write the passed in text on the default image --->
		<cfelse>
			<cfset LOCAL.Graphics = ImageGetBufferedImage( newimg ).GetGraphics() />
			<cfset LOCAL.Context = LOCAL.Graphics.getFontRenderContext() />
			<cfset LOCAL.Font = CreateObject( "java", "java.awt.Font") />
			
			<cfset LOCAL.fontName = "Arial" />
			<cfset LOCAL.fontStyleName = "bold" />
			<cfset LOCAL.fontStyle = LOCAL.Font.BOLD />
			<cfset LOCAL.fontSize = ToString( Ceiling( LOCAL.sq_size / 2 ) ) />
			
			<cfset LOCAL.text = JavaCast( "string", ARGUMENTS.text ) />
			
			<cfset LOCAL.textFont = LOCAL.Font.Init( JavaCast( "string", LOCAL.fontName ), JavaCast( "int", LOCAL.fontStyle ), JavaCast( "int", LOCAL.fontSize ) ) />
			<cfset LOCAL.textLayout = createObject( "java", "java.awt.font.TextLayout").init( LOCAL.text, LOCAL.textFont, LOCAL.Context ) />
			<cfset LOCAL.textBounds = LOCAL.textLayout.getBounds() />
			
			<cfset LOCAL.dimen.width = textBounds.getWidth() />
			<cfset LOCAL.dimen.height = textBounds.getHeight() />
			
			<cfset ImageDrawText( LOCAL.newimg, LOCAL.text, LOCAL.newimg.width / 2 - LOCAL.dimen.width / 2, LOCAL.newimg.height / 2 + LOCAL.dimen.height / 2, { font="#LOCAL.fontName#", size="#LOCAL.fontSize#", style="#LOCAL.fontStyleName#" } ) />
		</cfif>
		
		<cfimage action="border" name="LOCAL.newimg" source="#LOCAL.newimg#" color="#LOCAL.fgColor#" thickness="3" />	
		<cfimage action="WriteToBrowser" source="#LOCAL.newimg#" format="JPG" />										
	</cffunction>
	<cffunction name="createDefaultImage">
		<cfargument name="text" />
		<cfargument name="image_size" />
	
		<!--- Set the square size of the thumb --->
		<cfset sq_size = arguments.image_size />
		
		<!--- Write the result to a file. --->
		<cfset newimg = ImageNew( "", sq_size, sq_size, "rgb", "D3D3D3" ) />
		<cfset ImageSetAntialiasing( newimg, "on" )>
		
		<cfset ImageSetDrawingColor( newimg, "A9A9A9" ) />
		
		<cfset LOCAL.Graphics = ImageGetBufferedImage( newimg ).GetGraphics() />
		<cfset LOCAL.Context = LOCAL.Graphics.getFontRenderContext() />
		<cfset LOCAL.Font = CreateObject( "java", "java.awt.Font") />
		
		<cfset LOCAL.fontName = "Arial" />
		<cfset LOCAL.fontStyleName = "bold" />
		<cfset LOCAL.fontStyle = LOCAL.Font.BOLD />
		<cfset LOCAL.fontSize = ToString( Ceiling( sq_size / 2 ) ) />
		
		<cfset LOCAL.text = JavaCast( "string", arguments.text ) />
		
		<cfset LOCAL.textFont = LOCAL.Font.Init( JavaCast( "string", LOCAL.fontName ), JavaCast( "int", LOCAL.fontStyle ), JavaCast( "int", LOCAL.fontSize ) ) />
		<cfset LOCAL.textLayout = createObject( "java", "java.awt.font.TextLayout").init( LOCAL.text, LOCAL.textFont, LOCAL.Context ) />
		<cfset LOCAL.textBounds = LOCAL.textLayout.getBounds() />
		
		<cfset LOCAL.dimen.width = textBounds.getWidth() />
		<cfset LOCAL.dimen.height = textBounds.getHeight() />
		
		<cfset ImageDrawText( newimg, LOCAL.text, newimg.width / 2 - LOCAL.dimen.width / 2, newimg.height / 2 + LOCAL.dimen.height / 2, { font="#LOCAL.fontName#", size="#LOCAL.fontSize#", style="#LOCAL.fontStyleName#" } ) />
		
		<cfimage action="border" name="newimg" source="#newimg#" color="A9A9A9" thickness="3" />	
		<cfimage action="WRITETOBROWSER" source="#newimg#" format="JPG" />										
	</cffunction>

	<cffunction name="resizeImage">
		<cfargument name="image_url" />
		<cfargument name="image_size" />
		
		<!---Read the image into an object --->
		<cfimage action="read" name="myImage" source="#Replace( arguments.image_url, 'https://', 'http://' )#">
		
		<!--- Set the square size of the thumb --->
		<cfset sq_size = arguments.image_size />
		
		<!--- Write the result to a file. --->
		<cfset ImageSetAntialiasing(myImage, "on")>
		<cfset ImageScaleToFit(myImage, sq_size, sq_size)>
		
		<!--- Calculate the x and y position to paste the image --->
		<cfif myImage.width GTE myImage.height>
		    <cfset x = 0 />
		    <cfset y = ceiling( ( myImage.width - myImage.height ) / 2 ) />
		<cfelse>
		    <cfset x = ceiling( ( myImage.height - myImage.width ) / 2 ) />
		    <cfset y = 0 />
		</cfif>
		
		<cfset newimg = ImageNew( "", sq_size, sq_size, "rgb", "D3D3D3" ) />
		
		<cfset ImagePaste( newimg, myImage, x, y ) />
		
		<cfimage action="border" name="newimg" source="#newimg#" color="A9A9A9" thickness="3" />	
		<cfimage action="WRITETOBROWSER" source="#newimg#" format="JPG" />										
	</cffunction>
</cfcomponent>