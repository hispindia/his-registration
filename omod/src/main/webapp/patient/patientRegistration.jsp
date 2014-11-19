<%--
 *  Copyright 2014 Society for Health Information Systems Programmes, India (HISP India)
 *
 *  This file is part of Registration module.
 *
 *  Registration module is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  Registration module is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Registration module.  If not, see <http://www.gnu.org/licenses/>.
 * 
 *  
--%>

<%@ include file="/WEB-INF/template/include.jsp" %>
<%@ include file="/WEB-INF/template/header.jsp" %>
<%@ include file="../includes/js_css.jsp" %>
<openmrs:require privilege="Add Patients" otherwise="/login.htm" redirect="/findPatient.htm" />

<style>

</style>

<script type="text/javascript">

</script>

<h3 align="center" style="color:black">PATIENT REGISTRATION<br><br></h3>
<body>
<div>
<form>
<table width="100%" height="50%">
<tr height="30%" valign="top">
<td width="40%">
<td width="10%"><input type="radio" name="patient" value="New Patient" onclick="javascript:window.location.href='newPatientRegistration.htm'">New Patient</td>
<td><input type="radio" name="patient" value="Revisit Patient" onclick="javascript:window.location.href='revisitPatientRegistration.htm'">Revisit Patient</td>
</tr>
</table>
</form>
</div>
</body>
