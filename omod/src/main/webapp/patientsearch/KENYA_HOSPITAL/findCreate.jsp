 <%--
 *  Copyright 2013 Society for Health Information Systems Programmes, India (HISP India)
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
<%@ page import="java.util.Map" %>
<%@ page import="org.openmrs.Patient" %>

<script type="text/javascript">
	
	PATIENTSEARCHRESULT = {
		oldBackgroundColor: "",
		
		/** Click to view patient info */
		visit: function(patientId,deadInfo,admittedInfo){
		if(deadInfo=="true"){
        alert("This Patient is Dead");
        return false;
        }
        if(admittedInfo=="true"){
        alert("This Patient is admitted");
        return false;
        }							
			window.location.href = openmrsContextPath + "/module/registration/showPatientInfo.form?patientId=" + patientId + "&revisit=true";
		},
		
		/** Edit a patient */
		editPatient: function(patientId,deadInfo){
		if(deadInfo=="true"){
        alert("This Patient is Dead");
        return false;
        }		
			window.location.href = openmrsContextPath + "/module/registration/editPatient.form?patientId=" + patientId;
		},
		
		reprint: function(patientId,deadInfo){
		if(deadInfo=="true"){
        alert("This Patient is Dead");
        return false;
        }		
			window.location.href = openmrsContextPath + "/module/registration/showPatientInfo.form?patientId=" + patientId + "&reprint=true";
		}
	};
	
	jQuery(document).ready(function(){
	
		// hover rows
		jQuery(".patientSearchRow").hover(
			function(event){					
				obj = event.target;
				while(obj.tagName!="TR"){
					obj = obj.parentNode;
				}
				PATIENTSEARCHRESULT.oldBackgroundColor = jQuery(obj).css("background-color");
				jQuery(obj).css("background-color", "#00FF99");									
			}, 
			function(event){
				obj = event.target;
				while(obj.tagName!="TR"){
					obj = obj.parentNode;
				}
				jQuery(obj).css("background-color", PATIENTSEARCHRESULT.oldBackgroundColor);				
			}
		);
		
		// insert images
		jQuery(".editImage").each(function(index, value){
			jQuery(this).attr("src", openmrsContextPath + "/images/edit.gif");
		});		
	});
	
</script>



<c:choose>
	<c:when test="${not empty patients}" >		
	<table style="width:100%">
		<tr>
		<openmrs:hasPrivilege privilege="Edit Patients">
            <td align="center"><b>Edit</b></td>
        </openmrs:hasPrivilege>			
			<td align="center"><b>Patient ID</b></td>
			<td align="center"><b>Name</b></td>
			<td align="center"><b>Age</b></td>
			<td align="center"><b>Gender</b></td>			
			<!-- <td><b>Relative Name</b></td> -->
			<td align="center"><b>Date of Previous Visit</b></td>
			<td align="center"><b>Reprint Slip</b></td>
		</tr>
		<c:forEach items="${patients}" var="patient" varStatus="varStatus">
			<tr class='${varStatus.index % 2 == 0 ? "oddRow" : "evenRow" } patientSearchRow'>
				<openmrs:hasPrivilege privilege="Edit Patients">
					<td onclick="PATIENTSEARCHRESULT.editPatient(${patient.patientId},'${patient.dead}');">
						<center>
							<img class="editImage" title="Edit patient information"/>
						</center>
					</td>
				</openmrs:hasPrivilege>		
				<td align="center" onclick="PATIENTSEARCHRESULT.visit(${patient.patientId},'${patient.dead}','${patient.voided}');">
					${patient.patientIdentifier.identifier}
				</td>
				<td  align="center" onclick="PATIENTSEARCHRESULT.visit(${patient.patientId},'${patient.dead}','${patient.voided}');">${patient.givenName} ${patient.familyName}  ${fn:replace(patient.middleName,',',' ')}</td>
				<td align="center" onclick="PATIENTSEARCHRESULT.visit(${patient.patientId},'${patient.dead}','${patient.voided}');"> 
                	<c:choose>
                		<c:when test="${patient.age == 0}"> &lt 1 </c:when>
                		<c:otherwise >${patient.age}</c:otherwise>
                	</c:choose>
                </td>
				<td align="center" onclick="PATIENTSEARCHRESULT.visit(${patient.patientId},'${patient.dead}','${patient.voided}');">
					<c:choose>
                		<c:when test="${patient.gender eq 'M'}">
                		<!--
							<img src="${pageContext.request.contextPath}/images/male.gif"/>
						-->
						M
						</c:when>
                		<c:otherwise><!-- <img src="${pageContext.request.contextPath}/images/female.gif"/> --> F</c:otherwise>
                	</c:choose>
				</td>                
				<%-- <td onclick="PATIENTSEARCHRESULT.visit(${patient.patientId},'${patient.dead}');"> 
                	<%
						Patient patient = (Patient) pageContext.getAttribute("patient");
						Map<Integer, Map<Integer, String>> attributes = (Map<Integer, Map<Integer, String>>) pageContext.findAttribute("attributeMap");						
						Map<Integer, String> patientAttributes = (Map<Integer, String>) attributes.get(patient.getPatientId());						
						String relativeName = patientAttributes.get(8); 
						if(relativeName!=null)
							out.print(relativeName);
					%>
                </td> --%>
                <td align="center" onclick="PATIENTSEARCHRESULT.visit(${patient.patientId},'${patient.dead}','${patient.voided}');">
	                <openmrs:formatDate date="${lastVisitTime[patient.patientId]}"/>              	
                </td>
                <td align="center" onclick="PATIENTSEARCHRESULT.reprint(${patient.patientId},'${patient.dead}');"> 
                	Reprint slip
                </td>
			</tr>
		</c:forEach>
	</table>
	</c:when>
	<c:otherwise>
	No Patient found.
	</c:otherwise>
</c:choose>