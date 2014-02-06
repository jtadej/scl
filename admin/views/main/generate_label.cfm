<!doctype>
<html>
	<head>
		<title>Avery Dennison Template</title>
		<style type="text/css">
			@font-face
				{font-family:Calibri;
				panose-1:2 15 5 2 2 2 4 3 2 4;
				mso-font-charset:0;
				mso-generic-font-family:swiss;
				mso-font-pitch:variable;
				mso-font-signature:-536870145 1073786111 1 0 415 0;}
			p.MsoNormal, li.MsoNormal, div.MsoNormal
				{mso-style-unhide:no;
				mso-style-qformat:yes;
				mso-style-parent:"";
				margin-top:0in;
				margin-right:0in;
				margin-bottom:10.0pt;
				margin-left:0in;
				line-height:115%;
				mso-pagination:widow-orphan;
				font-size:11.0pt;
				font-family:"Calibri","sans-serif";
				mso-fareast-font-family:"Times New Roman";
				mso-bidi-font-family:"Times New Roman";}
			p.AveryStyle1, li.AveryStyle1, div.AveryStyle1
				{mso-style-name:"Avery Style 1";
				mso-style-priority:99;
				mso-style-unhide:no;
				mso-style-parent:"";
				margin-top:1.45pt;
				margin-right:1.4pt;
				margin-bottom:1.45pt;
				margin-left:1.4pt;
				text-align:center;
				mso-pagination:widow-orphan;
				font-size:8.0pt;
				mso-bidi-font-size:11.0pt;
				font-family:"Arial","sans-serif";
				mso-fareast-font-family:"Times New Roman";
				color:black;
				mso-bidi-font-weight:bold;}
			.MsoChpDefault
				{mso-style-type:export-only;
				mso-default-props:yes;
				font-size:10.0pt;
				mso-ansi-font-size:10.0pt;
				mso-bidi-font-size:10.0pt;
				font-family:"Calibri","sans-serif";
				mso-ascii-font-family:Calibri;
				mso-hansi-font-family:Calibri;}
			@page WordSection1
				{size:8.5in 11.0in;
				margin:.55in 22.3pt 33.6pt 27.85pt;
				mso-header-margin:0in;
				mso-footer-margin:0in;
				mso-paper-source:0;}
			div.WordSection1
				{page:WordSection1;}
			table.MsoNormalTable
				{mso-style-name:"Table Normal";
				mso-tstyle-rowband-size:0;
				mso-tstyle-colband-size:0;
				mso-style-noshow:yes;
				mso-style-priority:99;
				mso-style-parent:"";
				mso-padding-alt:0in 5.4pt 0in 5.4pt;
				mso-para-margin:0in;
				mso-para-margin-bottom:.0001pt;
				mso-pagination:widow-orphan;
				font-size:10.0pt;
				font-family:"Calibri","sans-serif";}
		</style>
	</head>

	<body lang=EN-US style='tab-interval:.5in'>
		<div class=WordSection1>
			<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 style='border-collapse:collapse;mso-table-layout-alt:fixed;mso-yfti-tbllook:1184;mso-padding-alt:0in 5.75pt 0in 5.75pt'>
				<cfloop index="variables.i" from="1" to="15" step="1">
					
					<tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;height:47.5pt;mso-height-rule:exactly'>
					
						<cfset variables.dataPrinted = 0 />
						<cfloop index="variables.j" from="1" to="4" step="1">
						<cfoutput>
						
							<td width=168 style='width:1.75in;padding:0in 5.75pt 0in 5.75pt;height:47.5pt;mso-height-rule:exactly'>
								<cfif variables.dataPrinted LT qryData.recordCount>
									<cfset variables.dataPrinted += 1 />

									#rc.objCode39Service.DrawCode39Barcode( qryData[ 'barcode' ][ variables.dataPrinted ], 0, 50, "px", 150 )#
								</cfif>
							</td>
							
							<cfif variables.j LT 4 AND variables.i EQ 1>
							
								<td width=29 rowspan=15 valign=top style='width:.3in;border-top:solid white 1.0pt;border-left:none;border-bottom:solid white 1.0pt;border-right:none;padding:0in 0in 0in 0in;height:47.5pt;mso-height-rule:exactly'>
									<p class=MsoNormal><o:p>&nbsp;</o:p></p>
								</td>
							
							</cfif>
							
						</cfoutput>
						</cfloop>
						
				 </tr>
			 
				</cfloop>
			</table>
		</div>
	</body>
</html>