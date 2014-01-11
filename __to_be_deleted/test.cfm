<cfspreadsheet action="read" src="assets/book.xls" query="qryBookData" headerrow="1" rows="1-11" />

<style>
.ssTable { width: 100%; 
        border-style:solid;
        border-width:thin;

.ssHeader { background-color: #ffff00; }
.ssTable td, .ssTable th { 
   padding: 10px; 
   border-style:solid;
   border-width:thin;
	}
</style>

<p>
Here is the data in your Excel sheet (assuming first row as headers):
</p>

<!---
<cfhttp url="https://www.googleapis.com/books/v1/volumes?q=isbn:9780717288359" result="stcBooks" />
<cfdump var="#DeserializeJSON(stcBooks.FileContent)#" />

<cfset theData = stcBooks.FileContent />

<!--- Test to make sure you have JSON data. --->
<cfif !IsJSON(theData)>
    <h3>The URL you requested does not provide valid JSON</h3>
    <cfdump var="#theData#" />
<!--- If the data is in JSON format, deserialize it. --->
<cfelse>
    <cfset cfData=DeserializeJSON(theData)>
		<cfdump var="#cfData#" />
</cfif>
--->
TEST

<cfset metadata = getMetadata(qryBookData)>
<cfset colList = "">
<cfloop index="col" array="#metadata#">
    <cfset colList = listAppend(colList, col.name)>
</cfloop>

<cfset colList = "ISBN,Title" />

<cfif qryBookData.recordCount is 1>
    <p>
    This spreadsheet appeared to have no data.
    </p>
<cfelse>
    <table class="ssTable">
        <tr class="ssHeader">
            <cfloop index="c" list="#colList#">
                <cfoutput><th>#c#</th></cfoutput>
            </cfloop>
        </tr>
        <cfoutput query="qryBookData" startRow="2">
            <tr>
            <cfset bookSearchURL = "https://www.googleapis.com/books/v1/volumes?q=isbn:" & qryBookData['ISBN'][currentrow] & "&key=AIzaSyC6wJqUjPPAj4PdmmuCPLjzq8njyf5NMHQ" />
						<cfhttp url="#bookSearchURL#" result="stcBooks" />
						<cfset theData = DeserializeJSON(stcBooks.FileContent) />
						<cfif structKeyExists( theData.items[1].volumeInfo, 'imageLinks')>
							<td><image src="#Replace(theData.items[1].volumeInfo.imageLinks.thumbnail, '&edge=curl', '')#" /></td>
						<cfelse>
							<td></td>
						</cfif>
						
<!---
						<cfdump var="#theData#"/>
            <cfoutput>#bookSearchURL#<br /></cfoutput>
						<cfset theData = DeserializeJSON(stcBooks.FileContent) />
						<td>Found: <cfdump var="#theData#"/></td>
--->
						<cfflush>
            <cfloop index="c" list="#colList#">
                <td>#qryBookData[c][currentRow]#</td>
            </cfloop>
            </tr>                    
        </cfoutput>
    </table>
</cfif>
