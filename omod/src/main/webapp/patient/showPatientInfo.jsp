<%@ include file="/WEB-INF/template/include.jsp" %>
<%@ include file="/WEB-INF/template/header.jsp" %>
<%@ include file="../includes/js_css.jsp" %>
<openmrs:require privilege="View Patient Info" otherwise="/login.htm" redirect="/module/registration/showPatientInfo.form" />
<openmrs:globalProperty key="hospitalcore.hospitalName" defaultValue="ddu" var="hospitalName"/>

<script type="text/javascript">
	var _attributes = new Array();
	<c:forEach var="entry" items="${patient.attributes}">
		_attributes[${entry.key}] = "${entry.value}";
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
		currentDateTime: "${currentDateTime}",	
		selectedOPD: "${selectedOPD}",
		OPDs: "${OPDs}",
		dueDate: "${dueDate}",
		daysLeft: "${daysLeft}"
	};
</script>

<jsp:include page="../includes/${hospitalName}/patientInfoForm.jsp"/>

<%@ include file="/WEB-INF/template/footer.jsp" %>  