<cfcomponent hint="I create code 39 barcodes.">

	<cfset variables.CODE39MAP = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","-","."," ","$","/","+","%" ] />

	<cffunction name="DrawCode39Barcode" access="public">
		<cfargument name="data" />
		<cfargument name="checkDigit" />
		<cfargument name="height" default="100" />
		<cfargument name="units" default="px" />
		<cfargument name="width" default="300" />
		<cfargument name="humanReadable" default="yes" />

		<cfreturn DrawBarcode_Code39( arguments.data, arguments.checkDigit, arguments.height, arguments.units, arguments.width, arguments.humanReadable ) /> 
	</cffunction>

	<cffunction name="DrawBarcode_Code39" access="private">
		<cfargument name="data" />
		<cfargument name="checkDigit" />
		<cfargument name="height" default="100" />
		<cfargument name="units" default="px" />
		<cfargument name="width" default="300" />
		<cfargument name="humanReadable" default="yes" />
		<cfargument name="minBarWidth" default="1" />
		<cfargument name="barWidthRatio" default="3" />
		<cfargument name="textLocation" default="bottom" />
		<cfargument name="textAlignment" default="center" />
		<cfargument name="textStyle" default="font-family:arial;font-size:12pt;" />
		<cfargument name="foreColor" default="black" />
		<cfargument name="backColor" default="white" />
		<cfargument name="mode" default="html" />
		
		<cfif NOT ListFindNoCase( "bottom,top", arguments.textLocation )>
			<cfset arguments.textLocation = "bottom" />
		</cfif>
		<cfif NOT ListFindNoCase( "center,left,right", arguments.textAlignment )>
			<cfset arguments.textAlignment = "center" />
		</cfif>
		<cfif arguments.barWidthRatio LT 2 OR arguments.barWidthRatio GT 3>
			<cfset arguments.barWidthRatio = 3 />
		</cfif>
		<cfif arguments.minBarWidth LT 0 OR arguments.minBarWidth GT 2>
			<cfset arguments.minBarWidth = 0 />
		</cfif>
		<cfif NOT ListFindNoCase( "yes,no", arguments.humanReadable )>
			<cfset arguments.humanReadable = "yes" />
		</cfif>
		<cfif arguments.width LTE 0 OR arguments.width GT 150>
			<cfset arguments.width = 1 />
		</cfif>
		<cfif NOT ListFindNoCase( "in,cm,px", arguments.units )>
			<cfset arguments.units = "in" />
		</cfif>
		<cfif arguments.height LTE 0 OR arguments.height GT 150>
			<cfset arguments.height = 1 />
		</cfif>
		
		<cfset arguments.humanReadable = ( arguments.humanReadable ) ? true : false />
		
		<cfset local.encodedData = EncodeCode39( arguments.data, arguments.checkDigit ) />
		<cfset local.humanReadableText = ConnectCode_Encode_Code39( arguments.data, arguments.checkDigit ) />
		<cfset local.encodedLength = 0 />
		<cfset local.thinLength = 0 />
		<cfset local.thickLength = 0.0 />
		<cfset local.totalLength = 0.0 />
		<cfset local.incrementWidth = 0.0 />
		<cfset local.swing = 1 />
		<cfset local.result = "" />
		<cfset local.barWidth = 0 />
		<cfset local.thickWidth = 0.0 />
		
		<cfloop index="local.x" from="1" to="#Len( local.encodedData )#" step="1">
			<cfswitch expression="#Mid( local.encodedData, local.x, 1 )#">
				<cfcase value="t">
					<cfset local.thinLength += 1 />
					<cfset local.encodedLength += 1 />
				</cfcase>
				<cfcase value="w">
					<cfset local.thickLength = local.thickLength + arguments.barWidthRatio />
					<cfset local.encodedLength += 3 />
				</cfcase>
			</cfswitch>
		</cfloop>
		
		<cfset local.totalLength += local.thinLength + local.thickLength />
		
		<cfif arguments.minBarWidth GT 0>
			<cfset local.barWidth = NumberFormat( arguments.minBarWidth, ".00" ) />
			<cfset arguments.width = local.barWidth * local.totalLength />
		<cfelse>
			<cfset local.barWidth = NumberFormat( ( arguments.width / local.totalLength ), ".00" ) />
		</cfif>
		
		<cfset local.thickWidth = local.barWidth * arguments.barWidthRatio />
		
		<cfif arguments.mode EQ "html">
			<cfset local.humanSpan = '<span style="' & arguments.textStyle & '"><small>' & local.humanReadableText & '</small></span>' />

			<cfset local.result = '<div style="text-align:' & arguments.textAlignment & '">' />
			
			<cfif arguments.humanReadable AND arguments.textLocation EQ "top">
				<cfset local.result &= local.humanSpan & '<br />' />
			</cfif>
			
			<cfloop index="local.x" from="1" to="#Len( local.encodedData )#" step="1">
				<cfset local.brush = ( local.swing EQ 0 ) ? arguments.backColor : arguments.foreColor />

				<cfswitch expression="#Mid( local.encodedData, local.x, 1 )#">
					<cfcase value="t">
						<cfset local.displayBarWidth = local.barWidth />
						<cfset local.incrementWidth += local.barWidth />
					</cfcase>
					<cfcase value="w">
						<cfset local.displayBarWidth = local.thickWidth />
						<cfset local.incrementWidth += local.thickWidth />
					</cfcase>
				</cfswitch>
				<cfset local.result &= '<span style="border-left:' & local.displayBarWidth & arguments.units & ' solid ' & local.brush & ';height:' & arguments.height & arguments.units & ';display:inline-block;"></span>' />

				<cfset local.swing = ( local.swing EQ 0 ) ? 1 : 0 />
			</cfloop>
			
			<cfif arguments.humanReadable AND arguments.textLocation EQ "bottom">
				<cfset local.result &= '<br />' & local.humanSpan />
			</cfif>
			
			<cfset local.result &= '</div>' />
		</cfif>
		
		<cfreturn result />
	</cffunction>

	<cffunction name="EncodeCode39" access="private">
		<cfargument name="data" />
		<cfargument name="checkDigit" />
		
		<cfset local.fontOutput = ConnectCode_Encode_Code39( arguments.data, arguments.checkDigit ) />
		<cfset local.output = "" />
		<cfset local.pattern = "" />
		
		<cfloop index="local.x" from="1" to="#Len( local.fontOutput)#" step="1">
			<cfswitch expression="#Mid( local.fontOutput, local.x, 1 )#">
				<cfcase value="1">
					<cfset local.pattern = "wttwttttwt" />
				</cfcase>
				<cfcase value="2">
					<cfset local.pattern = "ttwwttttwt" />
				</cfcase>
				<cfcase value="3">
					<cfset local.pattern = "wtwwtttttt" />
				</cfcase>
				<cfcase value="4">
					<cfset local.pattern = "tttwwtttwt" />
				</cfcase>
				<cfcase value="5">
					<cfset local.pattern = "wttwwttttt" />
				</cfcase>
				<cfcase value="6">
					<cfset local.pattern = "ttwwwttttt" />
				</cfcase>
				<cfcase value="7">
					<cfset local.pattern = "tttwttwtwt" />
				</cfcase>
				<cfcase value="8">
					<cfset local.pattern = "wttwttwttt" />
				</cfcase>
				<cfcase value="9">
					<cfset local.pattern = "ttwwttwttt" />
				</cfcase>
				<cfcase value="0">
					<cfset local.pattern = "tttwwtwttt" />
				</cfcase>
				<cfcase value="A">
					<cfset local.pattern = "wttttwttwt" />
				</cfcase>
				<cfcase value="B">
					<cfset local.pattern = "ttwttwttwt" />
				</cfcase>
				<cfcase value="C">
					<cfset local.pattern = "wtwttwtttt" />
				</cfcase>
				<cfcase value="D">
					<cfset local.pattern = "ttttwwttwt" />
				</cfcase>
				<cfcase value="E">
					<cfset local.pattern = "wtttwwtttt" />
				</cfcase>
				<cfcase value="F">
					<cfset local.pattern = "ttwtwwtttt" />
				</cfcase>
				<cfcase value="G">
					<cfset local.pattern = "tttttwwtwt" />
				</cfcase>
				<cfcase value="H">
					<cfset local.pattern = "wttttwwttt" />
				</cfcase>
				<cfcase value="I">
					<cfset local.pattern = "ttwttwwttt" />
				</cfcase>
				<cfcase value="J">
					<cfset local.pattern = "ttttwwwttt" />
				</cfcase>
				<cfcase value="K">
					<cfset local.pattern = "wttttttwwt" />
				</cfcase>
				<cfcase value="L">
					<cfset local.pattern = "ttwttttwwt" />
				</cfcase>
				<cfcase value="M">
					<cfset local.pattern = "wtwttttwtt" />
				</cfcase>
				<cfcase value="N">
					<cfset local.pattern = "ttttwttwwt" />
				</cfcase>
				<cfcase value="O">
					<cfset local.pattern = "wtttwttwtt" />
				</cfcase>
				<cfcase value="P">
					<cfset local.pattern = "ttwtwttwtt" />
				</cfcase>
				<cfcase value="Q">
					<cfset local.pattern = "ttttttwwwt" />
				</cfcase>
				<cfcase value="R">
					<cfset local.pattern = "wtttttwwtt" />
				</cfcase>
				<cfcase value="S">
					<cfset local.pattern = "ttwtttwwtt" />
				</cfcase>
				<cfcase value="T">
					<cfset local.pattern = "ttttwtwwtt" />
				</cfcase>
				<cfcase value="U">
					<cfset local.pattern = "wwttttttwt" />
				</cfcase>
				<cfcase value="V">
					<cfset local.pattern = "twwtttttwt" />
				</cfcase>
				<cfcase value="W">
					<cfset local.pattern = "wwwttttttt" />
				</cfcase>
				<cfcase value="X">
					<cfset local.pattern = "twttwtttwt" />
				</cfcase>
				<cfcase value="Y">
					<cfset local.pattern = "wwttwttttt" />
				</cfcase>
				<cfcase value="Z">
					<cfset local.pattern = "twwtwttttt" />
				</cfcase>
				<cfcase value="-">
					<cfset local.pattern = "twttttwtwt" />
				</cfcase>
				<cfcase value=".">
					<cfset local.pattern = "wwttttwttt" />
				</cfcase>
				<cfcase value=" ">
					<cfset local.pattern = "twwtttwttt" />
				</cfcase>
				<cfcase value="*">
					<cfset local.pattern = "twttwtwttt" />
				</cfcase>
				<cfcase value="$">
					<cfset local.pattern = "twtwtwtttt" />
				</cfcase>
				<cfcase value="/">
					<cfset local.pattern = "twtwtttwtt" />
				</cfcase>
				<cfcase value="+">
					<cfset local.pattern = "twtttwtwtt" />
				</cfcase>
				<cfcase value="%">
					<cfset local.pattern = "tttwtwtwtt" />
				</cfcase>
				<cfdefaultcase>
				</cfdefaultcase>
			</cfswitch>
			
			<cfset local.output &= local.pattern />
		</cfloop>

		<cfreturn local.output />
	</cffunction>

	<cffunction name="ConnectCode_Encode_Code39" access="private">
		<cfargument name="data" />
		<cfargument name="checkDigit" />
		
		<cfset local.result = "" />
		<cfset local.cd = "" />
		<cfset local.filteredData = "" />
		
		<cfset local.filteredData = filterInput( arguments.data ) />
		<cfset local.filteredLength = Len( local.filteredData ) />
		
		<cfif arguments.checkDigit EQ 1>
			<cfif local.filteredLength GT 254>
				<cfset local.filteredData = Mid( local.filteredData, 1, 254 ) />
			</cfif>
			<cfset local.cd = generateCheckDigit( local.filteredData ) />
		<cfelse>
			<cfif local.filteredLength GT 255>
				<cfset local.filteredData = Mid( local.filteredData, 1, 255 ) />
			</cfif>
		</cfif>
		
		<cfset local.result = "*" & local.filteredData & local.cd & "*" />
		
		<cfreturn htmlEditFormat( local.result ) />
	</cffunction>

	<cffunction name="getCode39Character" access="private">
		<cfargument name="inputdecimal" />
		
		<cfreturn variables.CODE39MAP[ arguments.inputdecimal ] />
	</cffunction>

	<cffunction name="getCode39Value" access="private">
		<cfargument name="inputchar" />
		
		<cfset local.rVal = ArrayFind( variables.CODE39MAP, arguments.inputchar ) - 1 />
		
		<cfreturn local.rVal />
	</cffunction>

	<cffunction name="filterInput" access="private">
		<cfargument name="data" />

		<cfset local.result = "" />
		<cfset local.dataLength = Len( arguments.data ) />
		
		<cfloop index="local.x" from="1" to="#local.dataLength#" step="1">
			<cfif getCode39Value( Mid( arguments.data, local.x, 1 ) ) NEQ -1>
				<cfset local.result &= Mid( arguments.data, local.x, 1 ) />
			</cfif>
		</cfloop>
		
		<cfreturn local.result />
	</cffunction>

	<cffunction name="generateCheckDigit" access="private">
		<cfargument name="data" />
		
		<cfset local.result = "" />
		<cfset local.dataLength = Len( arguments.data ) />
		<cfset local.sumValue = 0 />
		
		<cfloop index="local.x" from="1" to="#local.dataLength#" step="1">
			<cfset local.sumValue += getCode39Value( Mid( arguments.data, local.x, 1 ) ) />
		</cfloop>
		
		<cfset local.sumValue = local.sumValue MOD 43 />
		
		<cfreturn getCode39Character( local.sumValue ) />
	</cffunction>


	<cffunction name="html_escape" access="private">

	</cffunction>
	<cffunction name="html_decode" access="private">

	</cffunction>

</cfcomponent>