<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="barcode" desc="User ID">
			<rule type="required" contexts="login" />
			<rule type="integer" contexts="login" />
			<rule type="maxLength">
				<param name="maxLength" value="11" />
			</rule>
		</property>
		<property name="username" desc="Username">
			<rule type="required" contexts="loginFull" />
		</property>
		<property name="password" desc="Password">
			<rule type="required" contexts="loginFull" />
		</property>
	</objectProperties>
</validateThis>