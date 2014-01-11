<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="barcode" desc="book's barcode">
			<rule type="required" contexts="bookUpdate" />
			<rule type="integer" contexts="bookUpdate" />
		</property>
	</objectProperties>
</validateThis>