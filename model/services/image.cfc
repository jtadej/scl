<cfcomponent>
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