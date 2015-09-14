<%@ include file="/WEB-INF/template/include.jsp" %>
<%@ include file="/WEB-INF/template/header.jsp" %>
<%@ include file="../includes/js_css.jsp" %>
<style>
.radio-toolbar label {
    display:inline-block;
    background-color:#ddd;
    padding:4px 11px;
    font-family:Arial;
    font-size:16px;
}
</style>
<form>
<table>
<tr>
<td> </td>
<td> </td>
<td> </td>
<td> </td>
<td> </td>
<td> </td>
<td colspan="5" align="center"><input type="radio" name="new Patient" value="New Patient Register"   onclick="javascript:window.location.href=openmrsContextPath+'/module/registration/findCreatePatient.form'"/><label>New Patient Registration</label></td>
<td> </td>
<td> </td>
<td> </td>
<td> </td>
<td> </td>
<td> </td>
<td colspan="5" align="center"><input type="radio" name="Revisit Patient" value="Revisit Patient"  onclick="javascript:window.location.href=openmrsContextPath+'/module/registration/revisitPatient.form'"/>Revisit Patient Registration</td>
</tr>
</table>
</form>