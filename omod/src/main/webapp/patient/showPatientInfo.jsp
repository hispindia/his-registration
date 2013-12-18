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
<openmrs:require privilege="View Patients" otherwise="/login.htm" redirect="/module/registration/showPatientInfo.form" />
<openmrs:globalProperty key="hospitalcore.hospitalName" defaultValue="ddu" var="hospitalName"/>

<script type="text/javascript">
	var _attributes = new Array();
	<c:forEach var="entry" items="${patient.attributes}">
		_attributes[${entry.key}] = "${entry.value}";
	</c:forEach>
	
	var _observations = new Array();
	<c:forEach var="entry" items="${observations}">
		_observations[${entry.key}] = "${entry.value}";
	</c:forEach>
	
	/**
	 ** VALUES FROM MODEL
	 **/
	MODEL = {
		patientId: "${patient.patientId}",
		patientIdentifier: "${patient.identifier}",
		patientName: "${patient.fullname}",
		patientAge: "${patient.age}",
		patientGender: "${patient.gender}",
		patientAddress: "${patient.address}",
		patientAttributes: _attributes,
		observations: _observations,
		currentDateTime: "${currentDateTime}",	
		selectedTRIAGE: "${selectedTRIAGE}",
		TRIAGE: "${TRIAGE}",
		dueDate: "${dueDate}",
		daysLeft: "${daysLeft}",
		reprint: "${param.reprint eq 'true'}",
		tempCategoryId: "${tempCategoryId}",
		triageId: "${triageId}",
		//ghanshyam,11-dec-2013,#3327 Defining patient categories based on Kenyan requirements
		selectedCategory: "${selectedCategory}",
		//ghanshyam,18-dec-2013,# 3457 Exemption number for selected category should show on registration receipt
		categoryValue1: "${categoryValue1}",
		categoryValue2: "${categoryValue2}",
		categoryValue3: "${categoryValue3}",
		categoryValue4: "${categoryValue4}",
		categoryValue5: "${categoryValue5}",
		categoryValue6: "${categoryValue6}"
	};
</script>

<jsp:include page="../includes/${hospitalName}/patientInfoForm.jsp"/>

<%@ include file="/WEB-INF/template/footer.jsp" %>  