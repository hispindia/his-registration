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

<style>
.cell {
	border-top: 2px solid black;
	padding: 20px;
}


td.border {
	border-width: 1px;
	border-right: 1px;
	border-left: 1px;
	border-top: 1px;
	border-bottom: 1px;
	border-color: black	;
	border-style: solid;
}

.floatLeft {
	width: 47%;
	float: left;
}

.floatRight {
	width: 52%;
	float: right;
}

.floatBottom {
	position : absolute;
    bottom : 0;
    height : 100px;
    margin-top : 100px;
	right : 50%;
}

.container {
	overflow: hidden;
}

input, select, textarea {

	border-width: 1px;
	border-right: 1px;
	border-left: 1px;
	border-top: 1px;
	border-bottom: 1px;
	border-color: black;
	border-style: solid;

}

</style>
<script type="text/javascript">
	jQuery(document).ready(
			function() {
				jQuery("#patientRegistrationForm").fillForm(
						"patient.identifier==" + MODEL.patientIdentifier);
				jQuery('#calendar').datepicker({
					yearRange : 'c-100:c+100',
					dateFormat : 'dd/mm/yy',
					changeMonth : true,
					changeYear : true
				});
				jQuery("#searchbox").showPatientSearchBox(
						{
							searchBoxView : hospitalName + "/relativeNameSearch",
							resultView : "/module/registration/patientsearch/"
									+ hospitalName + "/searchField",
							success : function(data) {
								PAGE.searchPatientSuccess(data);
							},
							beforeNewSearch : PAGE.searchPatientBefore
						});
				jQuery('#movedToAreaDate').datepicker({
					yearRange : 'c-100:c+100',
					dateFormat : 'dd/mm/yy',
					changeMonth : true,
					changeYear : true,
					maxDate: '+0d'
				});
				
				MODEL.occupations = " , |"
						+ MODEL.occupations;
				PAGE.fillOptions("#occupation", {
					data : MODEL.occupations,
					delimiter : ",",
					optionDelimiter : "|"
				});
				
				jQuery('#birthdate').change(PAGE.checkBirthDate);
				MODEL.bloodGroups = " , |"
						+ MODEL.bloodGroups;
				PAGE.fillOptions("#bloodGroup", {
					data : MODEL.bloodGroups,
					delimiter : ",",
					optionDelimiter : "|"
				});
				MODEL.nationalities = " , |"
						+ MODEL.nationalities;
				PAGE.fillOptions("#patientNation", {
					data : MODEL.nationalities,
					delimiter : ",",
					optionDelimiter : "|"
				});
				PAGE.fillOptions("#towns", {
					data : MODEL.towns
				});
				PAGE.fillOptions("#settlements", {
					data : MODEL.settlements[0].split(',')
				});
		  
				MODEL.paidCategories = " , |"
						+ MODEL.paidCategories;
				PAGE.fillOptions("#paidCategory", {
					data : MODEL.paidCategories,
					delimiter : ",",
					optionDelimiter : "|"
				});
				
				MODEL.programs = " , |"
						+ MODEL.programs;
				PAGE.fillOptions("#program", {
					data : MODEL.programs,
					delimiter : ",",
					optionDelimiter : "|"
				});
				
				PAGE.fillOptions("#regFee", {
					data : MODEL.regFees
				});
		
				MODEL.OPDs = " , |"
						+ MODEL.OPDs;
				PAGE.fillOptions("#opdWard", {
					data : MODEL.OPDs,
					delimiter : ",",
					optionDelimiter : "|"
				});
				
				MODEL.TEMPORARYCAT = " , |"
						+ MODEL.TEMPORARYCAT;
				PAGE.fillOptions("#mlc", {
					data : MODEL.TEMPORARYCAT,
					delimiter : ",",
					optionDelimiter : "|"
				});
							
				MODEL.referredFrom = " ,Referred From|"
						+ MODEL.referredFrom;
				PAGE.fillOptions("#referredFrom", {
					data : MODEL.referredFrom,
					delimiter : ",",
					optionDelimiter : "|"
				});
				MODEL.referralType = " ,Referral Type|"
						+ MODEL.referralType;
				PAGE.fillOptions("#referralType	", {
					data : MODEL.referralType,
					delimiter : ",",
					optionDelimiter : "|"
				});
				
				jQuery("#paidCategoryField").hide();
                jQuery("#programField").hide();
				jQuery("#mlc").hide();
				jQuery("#referredFromColumn").hide();
				jQuery("#referralTypeRow").hide();
				jQuery("#referralDescriptionRow").hide();
				jQuery("#opdWardField").hide();
				
				// binding
				jQuery("#paidCategoryChecked").click(function() {
					VALIDATORS.payingCheck();
				});
				jQuery("#programChecked").click(function() {
					VALIDATORS.programCheck();
				});

				jQuery("#mlcCaseYes").click(function() {
					VALIDATORS.mlcYesCheck();
				});
				
				jQuery("#mlcCaseNo").click(function() {
					VALIDATORS.mlcNoCheck();
				});
				
				jQuery("#referredYes").click(function() {
					VALIDATORS.referredYesCheck();
				});
				
				jQuery("#referredNo").click(function() {
					VALIDATORS.referredNoCheck();
				});
				
				jQuery("#opdRoom").click(function() {
					VALIDATORS.opdRoomCheck();
				});

				
				// hide free reason
				
				jQuery("#calendarButton").click(function() {
					jQuery("#calendar").datepicker("show");
				});
				jQuery("#calendar").change(function() {
					jQuery("#birthdate").val(jQuery(this).val());
					PAGE.checkBirthDate();
				});
				jQuery("#birthdate").click(function() {
					jQuery("#birthdate").select();
				});
				jQuery("#patientGender").change(function() {
					VALIDATORS.genderCheck();
				});

			});

	/**
	 ** FORM
	 **/
	PAGE = {
		/** SUBMIT */
		submit : function() {

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
								+ "(<a href='javascript:PAGE.popUpWindow();'>show/hide</a>)");
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
	},
	popUpWindow : function() {
	var url = "#TB_inline?height=400&width=400&inlineId=patientSearchResult";
    tb_show("Patient Search List",url,false);	
	},
	   
	    checkGreenBookNumber : function() {	
		greenBookNumber=jQuery("#greenBookNo").val();
		jQuery.ajax({
		type : "GET",
		url : getContextPath() + "/module/registration/validateGreenBookAadharNumberAndDohidReg.form",
		data : ({
			greenBookNumber			: greenBookNumber
				}),
		success : function(data) {	
		jQuery("#divForGreenBookNumber").html(data);
		   } 
         });
	   },
	   
	   checkAadharNumber : function() {	
		aadharNumber=jQuery("#adhaarNo").val();
		jQuery.ajax({
		type : "GET",
		url : getContextPath() + "/module/registration/validateGreenBookAadharNumberAndDohidReg.form",
		data : ({
			aadharNumber			: aadharNumber
				}),
		success : function(data) {	
		jQuery("#divForAadharNumber").html(data);
		   } 
         });
	   },
	   
	   checkDOHID : function() {	
		dohid=jQuery("#dohid").val();
		jQuery.ajax({
		type : "GET",
		url : getContextPath() + "/module/registration/validateGreenBookAadharNumberAndDohidReg.form",
		data : ({
			dohid			: dohid
				}),
		success : function(data) {	
		jQuery("#divForDOHID").html(data);
		   } 
         });
	   },
		
		/** VALIDATE BIRTHDATE */
		checkBirthDate : function() {
			jQuery
					.ajax({
						type : "GET",
						url : getContextPath()
								+ "/module/registration/ajax/processPatientBirthDate.htm",
						data : ({
							birthdate : $("#birthdate").val()
						}),
						dataType : "json",
						success : function(json) {
							if (json.error == undefined) {
								if (json.estimated == "true") {
									jQuery("#birthdateEstimated").val("true")
								} else {
									jQuery("#birthdateEstimated").val("false");
								}
								jQuery("#estimatedAge").html(json.age);
								jQuery("#estimatedAgeInYear").val(json.ageInYear);
								jQuery("#birthdate").val(json.birthdate);
								jQuery("#calendar").val(json.birthdate);

							} else {
								alert(json.error);
								jQuery("#birthdate").val("");
							}
						},
						error : function(xhr, ajaxOptions, thrownError) {
							alert(thrownError);
						}
					});
		},

		/** FILL OPTIONS INTO SELECT 
		 * option = {
		 * 		data: list of values or string
		 *		index: list of corresponding indexes
		 *		delimiter: seperator for value and label
		 *		optionDelimiter: seperator for options
		 * }
		 */
		fillOptions : function(divId, option) {
			jQuery(divId).empty();
			if (option.delimiter == undefined) {
				if (option.index == undefined) {
					jQuery.each(option.data, function(index, value) {
						if (value.length > 0) {
							jQuery(divId).append(
									"<option value='" + value + "'>" + value
											+ "</option>");
						}
					});
				} else {
					jQuery.each(option.data, function(index, value) {
						if (value.length > 0) {
							jQuery(divId).append(
									"<option value='" + option.index[index] + "'>"
											+ value + "</option>");
						}
					});
				}
			} else {
				options = option.data.split(option.optionDelimiter);
				jQuery.each(options, function(index, value) {
					values = value.split(option.delimiter);
					optionValue = values[0];
					optionLabel = values[1];
					if (optionLabel != undefined) {
						if (optionLabel.length > 0) {
							jQuery(divId).append(
									"<option value='" + optionValue + "'>"
											+ optionLabel + "</option>");
						}
					}
				});
			}
		},

		/** CHANGE DISTRICT */
		changeTown : function() {

			// get the list of upazilas
			settlementList = "";
			selectedTown = jQuery("#towns option:checked").val();
			jQuery.each(MODEL.towns, function(index, value) {
				if (value == selectedTown) {
					settlementList = MODEL.settlements[index];
				}
			});

			// fill upazilas into upazila dropdown
			this.fillOptions("#settlements", {
				data : settlementList.split(",")
			});
		},

		/** SHOW OR HIDE REFERRAL INFO */
		toogleReferralInfo : function(obj) {
			checkbox = jQuery(obj);
			if (checkbox.is(":checked")) {
				jQuery("#referralDiv").show();
			} else {
				jQuery("#referralDiv").hide();
			}
		},

		/** VALIDATE FORM */
		validateRegisterForm : function() {
		
			if (StringUtils.isBlank(jQuery("#firstName").val())) {
				alert("Please enter the first name of the patient");
				return false;
			}
			else{
			    value = jQuery("#firstName").val();
				value = value.substr(0, 1).toUpperCase() + value.substr(1);
				jQuery("#firstName").val(value);
				//if(/^[a-zA-Z0-9- ]*$/.test(value) == false) {
				if(/^[a-zA-Z- ]*$/.test(value) == false) {
					alert("Please enter firstname in correct format");
					return false;
				}
				
			}
			
			if (StringUtils.isBlank(jQuery("#lastName").val())) {
				alert("Please enter the lastname of the patient");
				return false;
			}
			else{
			    value = jQuery("#lastName").val();
				value = value.substr(0, 1).toUpperCase() + value.substr(1);
				jQuery("#lastName").val(value);
				//if(/^[a-zA-Z0-9- ]*$/.test(value) == false) {
				if(/^[a-zA-Z- ]*$/.test(value) == false) {
					alert('Please enter lastname in correct format');
					return false;
				}
				
			}

			if (StringUtils.isBlank(jQuery("#birthdate").val())) {
				alert("Please enter age or DOB of the patient");
				return false;
			} 
			
			if (jQuery("#patientGender").val() == "Any") {
				alert("Please select gender of the patient");
				return false;
			}
			else{
				
	           }
			
			if (StringUtils.isBlank(jQuery("#patientPostalAddress").val())) {
				alert("Please enter the physical address of the patient");
				return false;
			}
			else{
			if (jQuery("#patientPostalAddress").val().length>255) {
			    alert("Physical Address should not exceed more than 255 characters");
				return false;
			  }
			}
 
			if (!StringUtils.isBlank(jQuery("#patientPhoneNumber").val())) {
				if (!StringUtils.isDigit(jQuery("#patientPhoneNumber").val())) {
					alert("Please enter the patient's contact number in correct format");
					return false;
				}
				if ((jQuery("#patientPhoneNumber").val().length)!=10) {
				    alert("Please enter the patient's contact number with in 10 digits");
					return false;
				  }
		
			}
			
			
			if (!StringUtils.isBlank(jQuery("#greenBookNo").val())) {
				 var input = jQuery("#greenBookNo").val();
				 var regex = new RegExp(/^[a-z]{2}[0-9]{7}$/i);
				 if(regex.test(input)==false){
				 alert("please Enter Green Book No in correct Format");
				 return false;
				 }
			}
			
			if (!StringUtils.isBlank(jQuery("#adhaarNo").val())) {
				 var input = jQuery("#adhaarNo").val();
				 var regex = new RegExp(/^[0-9]{12}$/);
				 if(regex.test(input)==false){
				 alert("please Enter Aadhar Number in correct Format");
				 return false;
				 }
			}
			
			if (!StringUtils.isBlank(jQuery("#dohid").val())) {
				 var input = jQuery("#dohid").val();
				 var regex = new RegExp(/^[a-zA-Z]{3}[-]{1}[0-9]{4}[-]{1}[0-9]{5}$/i);
				 if(regex.test(input)==false){
				 alert("please Enter DOH ID in correct Format");
				 return false;
				 }
			}
			
           var gNum=jQuery("#gNum").val();
           if(gNum=="1"){
           alert("Entered Green Book Number already exit in the system");
           return false;
	       }
   
          var aCardNo=jQuery("#aCardNo").val();
          if(aCardNo=="1"){
          alert("Entered Aadhar Number already exit in the system");
          return false;
	      }
	      
	      var dNum=jQuery("#dNum").val();
          if(dNum=="1"){
          alert("Entered DOH ID already exit in the system");
          return false;
	      }
			
			if (jQuery("#paidCategoryChecked").attr('checked') == false
					&& jQuery("#programChecked").attr('checked') == false) {			
			    alert("You did not choose any of the Patient Category");
				return false;
			}
			else{
			
			if(jQuery("#paidCategoryChecked").attr('checked') == true){
			if (StringUtils.isBlank(jQuery("#paidCategory").val())) {
				alert("Please select Paid Category");
				return false;
			} 
			}
			else if(jQuery("#programChecked").attr('checked') == true){
			if (StringUtils.isBlank(jQuery("#program").val())) {
				alert("Please select Program");
				return false;
			} 
			}
			
			} 
			
			if (jQuery("#regFee").val()=="Select") {
				alert("Please select registration fee");
				return false;
			} 
			
			if (StringUtils.isBlank(jQuery("#patientRelativeName").val())) {
				alert("Please enter the patient's relative name");
				return false;
			} 
		
			
			if (jQuery("#mlcCaseYes").attr('checked') == false
					&& jQuery("#mlcCaseNo").attr('checked') == false) {			
			    alert("You did not choose any of the Medico Legal Case");
				return false;
			}
			else{
			 if (jQuery("#mlcCaseYes").is(':checked')) {
				if (StringUtils.isBlank(jQuery("#mlc").val())){
					alert("Please select the medico legal case");
					return false;
				}
			  }
			}
			
			if (jQuery("#referredYes").attr('checked') == false
					&& jQuery("#referredNo").attr('checked') == false) {			
			    alert("You did not choose any of the Referral Information");
				return false;
			} 
			else{
			
			if (jQuery("#referredYes").attr('checked')) {
			
			if (StringUtils.isBlank(jQuery("#referredFrom").val())) {
				alert("Please enter referral from of the patient");
				return false;
			   }
			 else{
			 
			 if (StringUtils.isBlank(jQuery("#referralType").val())) {
					alert("Please enter referral type of the patient");
					return false;
				} 
			 } 
			 
			 }
			  
			}	
				if (jQuery("#opdRoom").attr('checked')){
				    if (StringUtils.isBlank(jQuery("#opdWard").val())) {
						alert("Please select the OPD room to visit");
						return false;
					}
				}
      
			return true;
		}
	};

	/**
	 ** VALIDATORS
	 **/
	VALIDATORS = {
		
		payingCheck : function() {
			if (jQuery("#paidCategoryChecked").is(':checked')) {
					jQuery("#programChecked").removeAttr("checked");
					jQuery("#paidCategoryField").show();
				    jQuery("#programField").hide();
			}
			else{
			jQuery("#paidCategoryField").hide();
			}
		},
		
		programCheck : function() {
			if (jQuery("#programChecked").is(':checked')) {
					jQuery("#paidCategoryChecked").removeAttr("checked");
				    jQuery("#programField").show();
				    jQuery("#paidCategoryField").hide();
			}
			else{
			jQuery("#programField").hide();
			}
		},
		
		mlcYesCheck : function () {
			if (jQuery("#mlcCaseYes").is(':checked')) {
			        jQuery("#mlcCaseNo").removeAttr("checked");
					jQuery("#mlc").show();	
			}
			else{
			jQuery("#mlc").hide();	
			}
		},
		
		mlcNoCheck : function () {
			if (jQuery("#mlcCaseNo").is(':checked')) {
			    jQuery("#mlcCaseYes").removeAttr("checked");	
				jQuery("#mlc").hide();	
			}
		},
		
		referredYesCheck : function () {
			if (jQuery("#referredYes").is(':checked')) {
			        jQuery("#referredNo").removeAttr("checked");
					jQuery("#referredFromColumn").show();
				    jQuery("#referralTypeRow").show();
				    jQuery("#referralDescriptionRow").show();	
			}
			else{
			jQuery("#referredFromColumn").hide();
			jQuery("#referralTypeRow").hide();
			jQuery("#referralDescriptionRow").hide();
			}
		},
		
		referredNoCheck : function () {
			if (jQuery("#referredNo").is(':checked')) {
			    jQuery("#referredYes").removeAttr("checked");	
				jQuery("#referredFromColumn").hide();
				jQuery("#referralTypeRow").hide();
				jQuery("#referralDescriptionRow").hide();	
			}
		},
		
		opdRoomCheck : function () {
			if (jQuery("#opdRoom").is(':checked')) {
					jQuery("#opdWardField").show();	
			}
			else{
			jQuery("#opdWardField").hide();	
			}
		},

		/*
		 * Check patient gender
		 */
		genderCheck : function() {
			jQuery("#patientRelativeNameSection").empty();
			if (jQuery("#patientGender").val() == "M") {
				jQuery("#patientRelativeNameSection")
						.html(
								'<input type="radio" id="relationShip" name="person.attribute.15" value="Son of" checked="checked"/> Son of');
			} else if(jQuery("#patientGender").val() == "F"){
				jQuery("#patientRelativeNameSection")
						.html(
								'<input type="radio" id="relationShip" name="person.attribute.15" value="Daughter of" checked="checked"/> Daughter of <input type="radio" id="relationShip" name="person.attribute.15" value="Wife of"/> Wife of');
			}
			else if(jQuery("#patientGender").val() == "O"){
				jQuery("#patientRelativeNameSection")
				.html(
				'<input type="radio" id="relationShip" name="person.attribute.15" value="Relative of" checked="checked"/> Relative of');
			}
		}
		
	};
	
	function abc(){
	document.getElementById("movedToAreaDate").disabled = true;
	}
	
	function def(){
	document.getElementById("movedToAreaDate").disabled = false;
	}
	
	function submitGreenBookNumber(){
	PAGE.checkGreenBookNumber();
   }
   
    function submitAadharNumber(){
	PAGE.checkAadharNumber();
   }
   
   function submitDOHID(){
	PAGE.checkDOHID();
   }
   
   function setRelativeName(){
   var relativeName=jQuery("#nameOrgivenNameOrmiddleNameOrfamilyNameOrIdentifier").val();
   jQuery("#patientRelativeName").val(relativeName);
   }
</script>
<script type="text/javascript">
			
				</script>
<h3 align="center" style="color:black">PATIENT REGISTRATION<br></h3>
<!--  
<h4 align="center" style="color:black">Patient Identifier<label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;${patientIdentifier}<br></h4>
-->
<form id="patientRegistrationForm" method="POST">
		<table width="100%">
		<tr>
		<td width="48%" align="right"><b>Patient Identifier</b><label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td><b><input readonly name="patient.identifier" style="border: none; width: 250px; background-color:white; font-weight:bold" /></b></td>
		</tr>
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		</table>
		
		<div class="floatLeft">
		<table>
			<tr>
				<td valign="top"><b>Patient Name</b><label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>First Name<label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="text" id="firstName" name="patient.firstName" style='width: 152px; 	border-width: 1px;
	border-right: 1px;
	border-left: 1px;
	border-top: 1px;
	border-bottom: 1px;
	border-color: black;
	border-style: solid;'>
				</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td valign="top">Last name<label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="text" id="lastName" name="patient.lastName" style='width: 152px; 	border-width: 1px;
	border-right: 1px;
	border-left: 1px;
	border-top: 1px;
	border-bottom: 1px;
	border-color: black;
	border-style: solid;'>
				</td>
			</tr>
			<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Occupation&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><select id="occupation" name="person.attribute.23" style='width: 152px;'>	</select></td>
		</tr>
			<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
			<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
			<tr>
				<td><b>Demographics</b><label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Age or DOB<label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="hidden" id="calendar" /> <input
							id="birthdate" name="patient.birthdate" style='width: 152px;'/> <img
							id="calendarButton"
							src="moduleResources/registration/calendar.gif" /> <input
							id="birthdateEstimated" type="hidden"
							name="patient.birthdateEstimate" value="true" />
							<input type="hidden" id="estimatedAgeInYear" name="estimatedAgeInYear"/>
							<span id="estimatedAge" />
				</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Gender<label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><select id="patientGender" name="patient.gender" style='width: 152px;'>
								<option value="Any"></option>
								<option value="M">Male</option>
								<option value="F">Female</option>
								<option value="O">Other</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Blood Group</td>
				<td><select id="bloodGroup" name="person.attribute.24" style='width: 152px;'>	
					</select>
				</td>
			</tr>
			<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
			<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
            <tr>
				<td><b>Address</b><label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Lived In area&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="radio" id="livediny" name="livedin" value="YES" onclick="abc();">Yes&nbsp;&nbsp;
				<input type="radio" id="livedinn" name="livedin" value="NO" onclick="def();">No
				</td>
				
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Moved to Area Date&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="movedToAreaDate" name="person.attribute.25" style='width: 152px;' disabled="disabled" />
				</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Postal Address&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="patientPostalAddress" name="patient.address.postalAddress" style='width: 152px;' />
				</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Town&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><select id="towns" name="patient.address.town"
							onChange="PAGE.changeTown();" style="width: 152px;">
						</select>
				</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Settlement&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><select id="settlements" name="patient.address.settlement"
							style="width: 152px;">
						</select>
				</td>
			</tr>
			<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
			<tr>
				<td><b>Phone Number&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="patientPhoneNumber"
				name="person.attribute.16" style='width: 152px;' />
				</td>
			</tr>
			<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
			<tr>
				<td><b>National ID&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
				<td>Nationality&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><select id="patientNation" name="person.attribute.26" style="width: 152px;">
					</select></td>
		    </tr>
		     <tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Green Book No&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="greenBookNo" name="person.attribute.27" style='width: 152px;' onblur="submitGreenBookNumber();"/></td>
		    </tr>
		    <tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Adhaar No&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="adhaarNo" name="person.attribute.20" style='width: 152px;' onblur="submitAadharNumber();"></td>
		    </tr>
		    <tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>DOH ID&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="dohid" name="person.attribute.29" style='width: 152px;' onblur="submitDOHID();"></td>
		    </tr>
		</table>
		</div>
		
		<div class="floatRight">
		<table>
		<tr>
				<td><b>Patient Category <label style="color:red">*</label></b>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="paidCategoryChecked" type="checkbox" name="paidCategoryChecked"/> Paid Category&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td id="paidCategoryField"><select id="paidCategory" name="patient.paidCategory" style="width: 152px;">
						</select></td>
		    </tr>
		    <tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="programChecked" type="checkbox" name="programChecked"/> Programs&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td id="programField"><select id="program" name="patient.program" style="width: 152px;">
						</select></td>
		    </tr>
		    
		    <tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		    
		     <tr>
				<td><b>Registration Fee <label style="color:red">*</label></b>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><select id="regFee" name="person.attribute.28" style='width: 152px;'>
					</select></td>
		    </tr>
		    
		    <tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		    
		    <tr>
				<td><b>Relative Name <label style="color:red">*</label></b>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td id="patientRelativeNameSection">&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><div id="searchbox"></div></td>
				<td><input id="patientRelativeName" name="patientRelativeName" type="hidden" style='width: 152px;'/></td>
				<td><input id="patientRelativeId" name="patientRelativeId" type="hidden" style='width: 152px;'/></td>
		    </tr>
		    <tr>
		    <td></td>
		    <td></td>
		    <td colspan="2">
				<div id="numberOfFoundPatients"></div>
			</td>
			</tr>
			<tr>
			<td></td>
		    <td></td>
			<td colspan="2"><div id="patientSearchResult"></div></td>
		    </tr>
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><b>Visit Information&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
		</tr>
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		<tr>
				<td><b>Medico Legal Case</b><label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="mlcCaseYes" type="checkbox" name="mlcCaseYes"/> Yes&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><select id="mlc" name="patient.mlc" style='width: 152px;'></select></td>
		</tr>
		<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="mlcCaseNo" type="checkbox" name="mlcCaseNo"/> No&nbsp;&nbsp;&nbsp;&nbsp;</td>
		</tr>
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		<tr>
				<td><b>Referral Information</b><label style="color:red">*&nbsp;&nbsp;&nbsp;&nbsp;</label></td>
				<td><input id="referredYes" type="checkbox" name="referredYes"/> Yes&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td id="referredFromColumn"><select id="referredFrom" name="patient.referred.from" style="width: 152px;"></select></td>
		</tr>
		<tr id="referralTypeRow">
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><select id="referralType" name="patient.referred.reason" style="width: 152px;"></select></td>
		</tr>
		<tr id="referralDescriptionRow">
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="referralDescription" name="patient.referred.description" placeholder="Comments" style="width: 152px;"/></td>
		</tr>
		<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="referredNo" type="checkbox" name="referredNo"/> No&nbsp;&nbsp;&nbsp;&nbsp;</td>
		</tr>
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		<tr>
				<td><b>OPD Room to Visit</b><label style="color:red">*&nbsp;&nbsp;&nbsp;&nbsp;</label></td>
				<td><input id="opdRoom" type="checkbox" name="opdRoom"/>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><span id="opdWardField"><select id="opdWard" name="patient.opdWard" style='width: 152px;'>	</select></span></td>
		</tr>
		</table>
		</div>
		
		<div id="divForGreenBookNumber"></div>
		<div id="divForAadharNumber"></div>
		<div id="divForDOHID"></div>
		
		<div class="floatBottom">
		<table>
		<tr valign="bottom">
		<td valign="bottom"><input type="button" value="Next" onclick="PAGE.submit();" style="font-weight:bold"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		                    <input type="button" value="Reset" onclick="window.location.href=window.location.href" style="font-weight:bold"/>
		</td>
		</tr>
		</table>
		</div>

	</form>