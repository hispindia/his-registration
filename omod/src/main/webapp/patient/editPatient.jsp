 <%--
 *  Copyright 2009 Society for Health Information Systems Programmes, India (HISP India)
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
--%> 
<%@ include file="/WEB-INF/template/include.jsp" %>
<%@ include file="/WEB-INF/template/header.jsp" %>
<%@ include file="../includes/js_css.jsp" %>
<openmrs:require privilege="Edit Patients" otherwise="/login.htm" redirect="/module/registration/editPatient.form" />
<openmrs:globalProperty key="hospitalcore.hospitalName" defaultValue="ddu" var="hospitalName"/>
<br/>

<script type="text/javascript">
    // Hospital name
	hospitalName = "${hospitalName}";
	
	// Towns
	var _towns = new Array();
	<c:forEach var="town" items="${towns}" varStatus="status">
		_towns[${status.index}] = "${town}";
	</c:forEach>
	
	var _settlements = new Array();
	<c:forEach var="settlement" items="${settlements}" varStatus="status">
		_settlements[${status.index}] = "${settlement}";
	</c:forEach>
	
	// Patient Attribute
	var _attributes = new Array();
	<c:forEach var="entry" items="${patient.attributes}">
		_attributes[${entry.key}] = "${entry.value}";
	</c:forEach>
	
	
	var _paidCategoryMap = new Array();
	<c:forEach var="entry" items="${paidCategoryMap}">
		_paidCategoryMap[${entry.key}] = "${entry.value}";
	</c:forEach>
	
	var _programMap = new Array();
	<c:forEach var="entry" items="${programMap}">
		_programMap[${entry.key}] = "${entry.value}";
	</c:forEach>
	
	/**
	 ** MODEL FROM CONTROLLER
	 **/
	MODEL = {
		patientId: "${patient.patientId}",
		patientIdentifier: "${patient.identifier}",
		patientName: "${patient.fullname}",
		lastName: "${patient.lastName}",
		firstName: "${patient.firstName}",
		patientAge: "${patient.age}",
		patientGender: "${patient.gender}",
		postalAddress: "${patient.postalAddress}",
		town: "${patient.town}",
		settlement: "${patient.settlement}",
		patientBirthdate: "${patient.birthdate}",
		patientAttributes: _attributes,
		towns: _towns,
		settlements: _settlements,
		occupations: "${occupations}",
		bloodGroups: "${bloodGroups}",
		nationalities: "${nationalities}",
		paidCategories: "${paidCategories}",
		programs: "${programs}",
		paidCategoryMap : _paidCategoryMap,
		programMap : _programMap,
		relativeName : "${patSearch.relativeName}",
		relativeId : "${patSearch.relativeId.patientId}"
	};
</script>

<jsp:include page="../includes/${hospitalName}/editPatientForm.jsp"/>

<%@ include file="/WEB-INF/template/footer.jsp" %>  