<%@ include file="/WEB-INF/template/include.jsp" %>
<%@ include file="/WEB-INF/template/header.jsp" %>
<%@ include file="../includes/js_css.jsp" %>
<style>
    .radio-toolbar label {
        display: inline-block;
        background-color: #ddd;
        padding: 4px 11px;
        font-family: Arial;
        font-size: 16px;
    }
</style>
<form>
    <table>
        <h3 align="center" style="color:black">PATIENT REGISTRATION<br><br></h3>

        <body>
            <div>
                <form>
                    <table width="100%" height="50%">
                        <tr height="30%" valign="top">
                            <td width="40%">
                            <td width="10%"><span><input type="radio" name="new Patient" value="New Patient"
                                        align="center"
                                        onclick="javascript:window.location.href=openmrsContextPath+'/module/registration/findCreatePatient.form'" />New
                                    Patient</span></td>
                            <td><input type="radio" name="Revisit Patient" value="Revisit Patient"
                                    onclick="javascript:window.location.href=openmrsContextPath+'/module/registration/revisitPatient.form'" />Revisit
                                Patient </td>
                        </tr>
                    </table>
                </form>
            </div>
        </body>