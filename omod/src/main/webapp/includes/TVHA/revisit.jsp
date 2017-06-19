
<style>


td.border {
	border-width: 1px;
	border-right: 0px;
	border-bottom: 1px;
	border-color: lightgrey;
	border-style: solid;
}
</style>
<script type="text/javascript">
	jQuery(document).ready(
			function() {
				jQuery("#searchbox").showPatientSearchBox(
						{
							searchBoxView : hospitalName + "/registration",
							resultView : "/module/registration/patientsearch/"
									+ hospitalName + "/findCreate",
							success : function(data) {
								PAGE.searchPatientSuccess(data);
							},
							beforeNewSearch : PAGE.searchPatientBefore
						});
			});
			PAGE = {submit : function() {

				// Capitalize fullname and relative name
				fullNameInCapital = StringUtils.capitalize(jQuery(
						"#nameOrIdentifier", jQuery("#patientSearchForm")).val());
				jQuery("#patientName", jQuery("#patientRegistrationForm")).val(
						fullNameInCapital);
				jQuery("#nameOrIdentifier", jQuery("#patientSearchForm")).val(
						fullNameInCapital);
				jQuery("#patientName", jQuery("#patientRegistrationForm")).val(
						fullNameInCapital);
				
				

				// Validate and submit
				if (this.validateRegisterForm()) {
					jQuery("#patientRegistrationForm")
							.mask(
									"<img src='" + openmrsContextPath + "/moduleResources/hospitalcore/ajax-loader.gif" + "'/>&nbsp;");
					jQuery("#patientRegistrationForm")
							.ajaxSubmit(
									{
										success : function(responseText,
												statusText, xhr) {
											json = jQuery.parseJSON(responseText);
											if (json.status == "success") {
												window.location.href = openmrsContextPath
														+ "/module/registration/showPatientInfo.form?patientId="
														+ json.patientId
														+ "&encounterId="
														+ json.encounterId;
											} else {
												alert(json.message);
											}
											jQuery("#patientRegistrationForm")
													.unmask();
										}
									});
				}
			},
					searchPatientSuccess : function(data) {
				jQuery("#numberOfFoundPatients")
				.html(
						"Similar patients: "
								+ data.totalRow
								+ "(<a href='javascript:PAGE.togglePatientResult();'>show/hide</a>)");
	},

	/** CALLBACK WHEN BEFORE SEARCHING PATIENT */
	searchPatientBefore : function(data) {
		jQuery("#numberOfFoundPatients")
				.html(
						"<center><img src='" + openmrsContextPath + "/moduleResources/hospitalcore/ajax-loader.gif" + "'/></center>");
		jQuery("#patientSearchResult").hide();
	},

	/** TOGGLE PATIENT RESULT */
	togglePatientResult : function() {
		jQuery("#patientSearchResult").toggle();
	}};
				</script>
				
				<div id="patientSearchResult"></div>
<form>
	<table>
	   <tr> <h3 align="center" style="color:black">Search  Patient<br></h3></tr>
	
		<tr>
		 <table width="73%" height="40%">
		 <tr height="30%">
<td width="69%">
			<td width="30%" valign="top" class="cell">Please enter Patient Name or Identifier <label style="color:red">*</label>
			</td>
			<td class="cell"><input id="patientName" type="hidden"
				name="patient.name" />
				<div id="searchbox"></div>
				<div id="numberOfFoundPatients"></div>
			</td>
		
          </tr>
		  </table>
		  </tr>
</table>
</form>