<%@ include file="/WEB-INF/template/include.jsp" %>
<c:choose>
	<c:when test="${status eq 'success'}">
		{
			"status": "${status}",
			"patientId": "${patientId}",
			"encounterId": "${encounterId}"
		}
	</c:when>	
	<c:otherwise>
		{
			"status": "${status}",
			"message": "${message}"
		}
	</c:otherwise>
</c:choose>
