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
 *  author: Ghanshyam
 *  date:   20-02-2013
--%>

<style>
.cell {
	border-top: 1px solid lightgrey;
	padding: 20px;
}

td.border {
	border-width: 1px;
	border-right: 0px;
	border-bottom: 1px;
	border-color: lightgrey;
	border-style: solid;
}

td.bottom {
	border-width: 1px;
	border-bottom: 1px;
	border-right: 0px;
	border-top: 0px;
	border-left: 0px;
	border-color: lightgrey;
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
background-color: #bde9ba;
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

				// Fill data into address dropdowns
				PAGE.fillOptions("#districts", {
					data : MODEL.districts
				});
				PAGE.fillOptions("#upazilas", {
					data : MODEL.upazilas[0].split(',')
				});

				// Set value for patient information
				formValues = "patient.surName==" + MODEL.surName + "||";
				formValues += "patient.firstName==" + MODEL.firstName + "||";
				formValues += "patient.givenName==" + MODEL.givenName + "||";
				formValues += "patient.otherName==" + MODEL.otherName + "||";
				formValues += "patient.birthdate==" + MODEL.patientBirthdate
						+ "||";
				formValues += "patient.gender==" + MODEL.patientGender + "||";
				formValues += "patient.identifier==" + MODEL.patientIdentifier
						+ "||";
				formValues += "patient.gender==" + MODEL.patientGender[0]
						+ "||";
				formValues += "person.attribute.8=="
						+ MODEL.patientAttributes[8] + "||";

						formValues += "person.attribute.26=="
						+ MODEL.patientAttributes[26] + "||";
						
				formValues += "person.attribute.27=="
						+ MODEL.patientAttributes[27] + "||";
						
				if (!StringUtils.isBlank(MODEL.patientAttributes[39]) && MODEL.patientAttributes[27]=="Other") {
				formValues += "person.attribute.39=="
						+ MODEL.patientAttributes[39] + "||";
				}
				else{
				jQuery("#otherNationality").hide();
				}
								
				attributes = MODEL.patientAttributes[14];
				jQuery("#catGen").hide();
				jQuery("#healthIdField").hide();
				
				jQuery.each(attributes.split(","), function(index, value) {
					jQuery("#patientRegistrationForm").fillForm(
							"person.attribute.14==" + value + "||");
				});				
					
					
				if (!StringUtils.isBlank(MODEL.patientAttributes[16])) {
					formValues += "person.attribute.16=="
							+ MODEL.patientAttributes[16] + "||";
				}
				
				if (!StringUtils.isBlank(MODEL.patientAttributes[20])) {
					formValues += "patient.attribute.20=="
							+ MODEL.patientAttributes[20] + "||";
				}
				
				if (!StringUtils.isBlank(MODEL.patientAttributes[38])) {
					formValues += "patient.attribute.38=="
							+ MODEL.patientAttributes[38] + "||";
				}
				
				if (!StringUtils.isBlank(MODEL.patientAttributes[25])) {
					formValues += "patient.attribute.25=="
							+ MODEL.patientAttributes[25] + "||";
				}
				
				if (!StringUtils.isBlank(MODEL.patientAttributes[28])) {
					formValues += "person.attribute.28=="
							+ MODEL.patientAttributes[28] + "||";
				}
				
				if (!StringUtils.isBlank(MODEL.patientAttributes[29])) {
					formValues += "person.attribute.29=="
							+ MODEL.patientAttributes[29] + "||";
				}
				
				if (!StringUtils.isBlank(MODEL.patientAttributes[30])) {
					formValues += "person.attribute.30=="
							+ MODEL.patientAttributes[30] + "||";
				}

				if (!StringUtils.isBlank(MODEL.patientAttributes[37])) {
					formValues += "person.attribute.37=="
							+ MODEL.patientAttributes[37] + "||";
				}
				
				if (!StringUtils.isBlank(MODEL.patientAttributes[36])) {
					jQuery("#patientRegistrationForm").fillForm(
							"person.attribute.36=="
									+ MODEL.patientAttributes[36] + "||");
				} else {
					jQuery("#exemptionField1").hide();
					jQuery("#exemptionField2").hide();
				}
				
				if (!StringUtils.isBlank(MODEL.patientAttributes[33])) {
					jQuery("#patientRegistrationForm").fillForm(
							"person.attribute.33=="
									+ MODEL.patientAttributes[33] + "||");
				} else {
					jQuery("#nhifCardField1").hide();
					jQuery("#nhifCardField2").hide();
				}
				
				if (!StringUtils.isBlank(MODEL.patientAttributes[32])) {
					jQuery("#patientRegistrationForm").fillForm(
							"person.attribute.32=="
									+ MODEL.patientAttributes[32] + "||");
				} else {
					jQuery("#waiverField1").hide();
					jQuery("#waiverField2").hide();
				}
				
				if (MODEL.patientAttributes[14]=="General") {
				jQuery("#exemptionField1").hide();
				jQuery("#exemptionField2").hide();
				jQuery("#nhifCardField1").hide();
				jQuery("#nhifCardField2").hide();
				jQuery("#waiverField1").hide();
				jQuery("#waiverField2").hide();
				}
				
				if (MODEL.patientAttributes[14]=="HIV" || MODEL.patientAttributes[14]=="Child Less Than 5 yr"
				|| MODEL.patientAttributes[14]=="TB" || MODEL.patientAttributes[14]=="Expectant Mother"
				|| MODEL.patientAttributes[14]=="Other Insurance" || MODEL.patientAttributes[14]=="Malaria") {
				jQuery("#nhifCardField1").hide();
				jQuery("#nhifCardField2").hide();
				jQuery("#waiverField1").hide();
				jQuery("#waiverField2").hide();
				}
				
				if (MODEL.patientAttributes[14]=="NHIF") {
				jQuery("#waiverField1").hide();
				jQuery("#waiverField2").hide();
				}
				
				if (MODEL.patientAttributes[14]=="Waiver") {
				jQuery("#exemptionField1").hide();
				jQuery("#exemptionField2").hide();
				jQuery("#nhifCardField1").hide();
				jQuery("#nhifCardField2").hide();
				}
				
				// Set value for address 
				addressParts = MODEL.patientAddress.split(',');
				formValues += "patient.address.postalAddress==" + StringUtils.trim(addressParts[0]) + "||";
				jQuery("#districts").val(StringUtils.trim(addressParts[2]));
				PAGE.changeDistrict();
				jQuery("#upazilas").val(StringUtils.trim(addressParts[1]));
				
				jQuery("#patientRegistrationForm").fillForm(formValues);
				PAGE.checkBirthDate();
				VALIDATORS.genderCheck();
				jQuery("#patientRegistrationForm").fillForm(
						"person.attribute.15==" + MODEL.patientAttributes[15]
								+ "||");


				// binding
				jQuery("#patCatGeneral").click(function() {
					VALIDATORS.generalCheck();
				});
				jQuery("#patCatHIV").click(function() {
					VALIDATORS.hivCheck();
				});
				jQuery("#patCatChildLessThan5yr").click(function() {
					VALIDATORS.childYearCheck();
				});
				jQuery("#patCatNHIF").click(function() {
					VALIDATORS.nhifCheck();
				});
				jQuery("#patCatTB").click(function() {
					VALIDATORS.tvCheck();
				});
				jQuery("#patCatMother").click(function() {
					VALIDATORS.motherCheck();
				});
				jQuery("#patCatOtherInsurance").click(function() {
					VALIDATORS.otherInsuranceCheck();
				});
				jQuery("#patCatMalaria").click(function() {
					VALIDATORS.malariaCheck();
				});
				jQuery("#patCatWaiver").click(function() {
					VALIDATORS.waiverCheck();
				});

				jQuery("#sameAddress").click(function() {
					VALIDATORS.copyaddress();
				});

				jQuery('#calendar').datepicker({
					yearRange : 'c-100:c+100',
					dateFormat : 'dd/mm/yy',
					changeMonth : true,
					changeYear : true
				});
				jQuery('#birthdate').change(PAGE.checkBirthDate);
				
				//ghanshyam 25-feb-2013 New Requirement #966[Billing]Add Paid Bill/Add Free Bill for Bangladesh module(removed Patient Category)
				/*
				jQuery("#free").click(function() {
					VALIDATORS.freeCheck();
				});
				jQuery("#patCatGeneral").click(function() {
					VALIDATORS.generalCheck();
				});
				*/
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

			// Capitalize fullname and relative name
			fullNameInCapital = StringUtils.capitalize(jQuery("#patientName",
					jQuery("#patientRegistrationForm")).val());
			jQuery("#patientName", jQuery("#patientRegistrationForm")).val(
					fullNameInCapital);
			relativeNameInCaptital = StringUtils.capitalize(jQuery("#patientRelativeName").val());
			jQuery("#patientRelativeName").val(relativeNameInCaptital);

			// Validate and submit
			if (this.validateRegisterForm()) {
				jQuery("#patientRegistrationForm")
						.mask(
								"<img src='" + openmrsContextPath + "/moduleResources/hospitalcore/ajax-loader.gif" + "'/>&nbsp;");
				jQuery("#patientRegistrationForm").ajaxSubmit(
						{
							success : function(responseText, statusText, xhr) {
								json = jQuery.parseJSON(responseText);
								if (json.status == "success") {
									window.location.href = openmrsContextPath
											+ "/findPatient.htm";
								} else {
									alert(json.message);
								}
								jQuery("#patientRegistrationForm").unmask();
							}
						});
			}
		},

		 //ghanshya,3-july-2013 #1962 Create validation for length of Health ID and National ID
		//Add Validation for checking duplicate National Id and Health Id
		checkNationalIDPassportNumber : function() {
		        patientId=MODEL.patientId;
				nationalId=jQuery("#patientNationalId").val();
				passportNumber=jQuery("#passportNumber").val();
				jQuery.ajax({
				type : "GET",
				url : getContextPath() + "/module/registration/validatenationalidandpassportnumberedit.form",
				data : ({
					patientId			: patientId,
					nationalId			: nationalId,
					passportNumber		: passportNumber
				}),
				success : function(data) {	
				    jQuery("#validationMessage").html(data);	
					 
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
		changeDistrict : function() {

			// get the list of upazilas
			upazilaList = "";
			selectedDistrict = jQuery("#districts option:checked").val();
			jQuery.each(MODEL.districts, function(index, value) {
				if (value == selectedDistrict) {
					upazilaList = MODEL.upazilas[index];
				}
			});

			// fill upazilas into upazila dropdown
			this.fillOptions("#upazilas", {
				data : upazilaList.split(",")
			});
		},

		/** VALIDATE FORM */
		validateRegisterForm : function() {

			if (StringUtils.isBlank(jQuery("#surName").val())) {
				alert("Please enter the surname of the patient ");
				return false;
			}
			else{
			    value = jQuery("#surName").val();
				value = value.toUpperCase();
				pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -";
				for (i = 0; i < value.length; i++) {
					if (pattern.indexOf(value[i]) < 0) {
						alert("Please enter surname/identifier in correct format");
						return false;
					}
				}
			}
			
			if (StringUtils.isBlank(jQuery("#firstName").val())) {
				alert("Please enter firstname in correct format");
				return false;
			}
			else{
			    value = jQuery("#firstName").val();
				value = value.toUpperCase();
				pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -";
				for (i = 0; i < value.length; i++) {
					if (pattern.indexOf(value[i]) < 0) {
						alert("Please enter firstname in correct format");
						return false;
					}
				}
			}
			
			if (!StringUtils.isBlank(jQuery("#givenName").val())) {
			 value = jQuery("#givenName").val();
				value = value.toUpperCase();
				pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -";
				for (i = 0; i < value.length; i++) {
					if (pattern.indexOf(value[i]) < 0) {
						alert("Please enter givenname in correct format");
						return false;
					}
				}
			}
			
			if (!StringUtils.isBlank(jQuery("#otherName").val())) {
			 value = jQuery("#otherName").val();
				value = value.toUpperCase();
				pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -";
				for (i = 0; i < value.length; i++) {
					if (pattern.indexOf(value[i]) < 0) {
						alert("Please enter othername in correct format");
						return false;
					}
				}
			}

			if (StringUtils.isBlank(jQuery("#patientRelativeName").val())) {
				alert("Please enter the patient's relative name");
				return false;
			}/* else {
				if (jQuery("#patientRegistrationForm input[name=person.attribute.15]:checked").length == 0) {
					alert("Please select relative name type");
					return false;
				}
			}*/
			
			if (jQuery("#relationshipType").val() == "Relationship") {
				alert("Please enter the patient's relationship type with the NOK");
				return false;
			}

			if (StringUtils.isBlank(jQuery("#birthdate").val())) {
				alert("Please enter age or DOB of the patient");
				return false;
			}

			if (jQuery("#patientGender").val() == "Any") {
				alert("Please select gender of the patient");
				return false;
			}
			
			if (jQuery("#patientGender").val() == "M" &&  jQuery("#patientMaritalStatus").val() == "Widow") {
				alert("Widow marital status is only for Female");
				return false;
			}		

			if (jQuery("#patientGender").val() == "F" &&  jQuery("#patientMaritalStatus").val() == "Widower") {
				alert("Widower marital status is only for Male");
				return false;
			}
			
			if (jQuery("#patientMaritalStatus").val() == "Marital") {
				alert("Please select marital status of the patient");
				return false;
			} 
			
			if (StringUtils.isBlank(jQuery("#patientPostalAddress").val())) {
				alert("Please enter the physical address of the patient");
				return false;
			} 
			
            //ghanshyam 25-feb-2013 New Requirement #966[Billing]Add Paid Bill/Add Free Bill for Bangladesh module(removed Patient Category)
            /*
			if (!VALIDATORS.validatePatientCategory()) {
				return false;
			}
			*/

			if (!StringUtils.isBlank(jQuery("#patientPhoneNumber").val())) {
				if (!StringUtils.isDigit(jQuery("#patientPhoneNumber").val())) {
					alert("Please enter the patient's contact number in correct format");
					return false;
				}
			}

			if (!StringUtils.isBlank(jQuery("#relativePhoneNumber").val())) {
				if (!StringUtils.isDigit(jQuery("#relativePhoneNumber").val())) {
					alert("Please enter the NOK's contact number in correct format");
					return false;
				}
			}
			
			
			/*
			if (!StringUtils.isBlank(jQuery("#patientEmail").val())) {
				var x=jQuery("#patientEmail").val();
				var atpos=x.indexOf("@");
				var dotpos=x.lastIndexOf(".");
				if (atpos<1 || dotpos<atpos+2 || dotpos+2>=x.length)
				  {
				  alert("Please enter the patient's e-mail address in correct format");
				  return false;
				  }
			}
			
			if (!StringUtils.isBlank(jQuery("#relativeEmail").val())) {
				var x=jQuery("#relativeEmail").val();
				var atpos=x.indexOf("@");
				var dotpos=x.lastIndexOf(".");
				if (atpos<1 || dotpos<atpos+2 || dotpos+2>=x.length)
				  {
				  alert("Please enter the NOK's e-mail address in correct format");
				  return false;
				  }
			}
			*/
			
			if (!StringUtils.isBlank(jQuery("#patientEmail").val())) {
			var x=jQuery("#patientEmail").val();
			var regExpForEmail = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
			if (regExpForEmail.test(x)) {
			return true;
			}
			else {
			alert("Please enter the patient's e-mail address in correct format");
			return false;
			}
			
			}
			
			if (!StringUtils.isBlank(jQuery("#relativeEmail").val())) {
			var x=jQuery("#relativeEmail").val();
			var regExpForEmail = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
			if (regExpForEmail.test(x)) {
			return true;
			}
			else {
			alert("Please enter the NOK's e-mail address in correct format");
			return false;
			}
			}
			
			if (!StringUtils.isBlank(jQuery("#estimatedAge").html())) {
				estAge = jQuery("#estimatedAge").html();
				var rest=estAge.slice(1,-6); 
				if (rest>5) {
					if (jQuery("#patCatChildLessThan5yr").is(':checked')) {
						alert("This category is only valid for patient under 5 years of age");
						jQuery("#patCatChildLessThan5yr").removeAttr("checked");
						jQuery("#exemptionNumber1").val("");
						jQuery("#exemptionField1").hide();
						jQuery("#exemptionField2").hide();
						//jQuery("#bdate").show();
						return false;
					}
				}
			}

			if (jQuery("#patientGender").val() == "M" && jQuery("#patCatMother").is(':checked') ) {
					jQuery("#patCatMother").removeAttr("checked");
					jQuery("#exemptionNumber1").val("");
					jQuery("#exemptionField1").hide();
					jQuery("#exemptionField2").hide();
					alert("This category is only valid for female patient");
					return false;
				}		
			

			if (jQuery("#patCatGeneral").attr('checked') == false
					&& jQuery("#patCatHIV").attr('checked') == false
					&& jQuery("#patCatChildLessThan5yr").attr('checked') == false
					&& jQuery("#patCatNHIF").attr('checked') == false
					&& jQuery("#patCatTB").attr('checked') == false
					&& jQuery("#patCatMother").attr('checked') == false
					&& jQuery("#patCatOtherInsurance").attr('checked') == false
					&& jQuery("#patCatMalaria").attr('checked') == false
					&& jQuery("#patCatWaiver").attr('checked') == false) {
				jQuery("#patCatGeneral").attr("checked", "checked");				
				return true;
			} else {
			    if (jQuery("#patCatHIV").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
				}
				
				if (jQuery("#patCatChildLessThan5yr").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
				}
				
				if (jQuery("#patCatNHIF").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
					
					if (jQuery("#nhifCardNumber").val().length <= 0) {
						alert('Please enter the NHIF Card Number');
						return false;
					}
				}
				
				if (jQuery("#patCatTB").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
				}

				if (jQuery("#patCatMother").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
				}
				
				if (jQuery("#patCatOtherInsurance").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
				}
				
				if (jQuery("#patCatMalaria").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
				}
				
				if (jQuery("#patCatWaiver").attr('checked')) {
					if (jQuery("#waiverNumber").val().length <= 0) {
						alert('Please enter the Waiver Number');
						return false;
					}
				}
			}
			
			        //ghanshya,3-july-2013 #1962 Create validation for length of Health ID and National ID
			       //Add Validation for checking duplicate National Id and Health Id
			        PAGE.checkNationalIDPassportNumber();
		            alert("click ok to proceed");
		            abc=jQuery("#abc").val();
					def=jQuery("#def").val();
					nd=jQuery("#nId").val();
					pn=jQuery("#pNum").val();
					nId=jQuery("#nId").val();
					pNum=jQuery("#pNum").val();
				
					if(typeof nId!="undefined" || typeof pNum!="undefined"){
					if(nId=="1" && pNum=="1"){
					//document.getElementById("nationalIdValidationMessage").innerHTML="Patient already registered with this National id";
					//document.getElementById("healthIdValidationMessage").innerHTML="Patient already registered with this Health id";
                    //jQuery("#nationalIdValidationMessage").show();
                    //jQuery("#healthIdValidationMessage").show();
		            alert("Patient already registered with the same National ID and Passport Number");
					return false
		            }
		            else if(nId=="1"){
                    //document.getElementById("nationalIdValidationMessage").innerHTML="Patient already registered with this National id";
                    //jQuery("#nationalIdValidationMessage").show();
                    //jQuery("#healthIdValidationMessage").hide();
		            alert("Patient already registered with the same National ID");
                    return false;					
		            }
		            else if(pNum=="1"){
		             //document.getElementById("healthIdValidationMessage").innerHTML="Patient already registered with this Health id";
                     //jQuery("#healthIdValidationMessage").show();
                     //jQuery("#nationalIdValidationMessage").hide();
		             alert("Patient already registered with the same Passport Number");	
					 return false;
		            }
		            }
		            else{
		            alert("please try again");
		            return false;
		            }

			return true;
		}
	};

	/**
	 ** VALIDATORS
	 **/
	 VALIDATORS = {

	/** VALIDATE PATIENT CATEGORY */
		
		validatePatientCategory : function() {
			if (jQuery("#patCatGeneral").attr('checked') == false
					&& jQuery("#patCatHIV").attr('checked') == false
					&& jQuery("#patCatChildLessThan5yr").attr('checked') == false
					&& jQuery("#patCatNHIF").attr('checked') == false
					&& jQuery("#patCatTB").attr('checked') == false
					&& jQuery("#patCatMother").attr('checked') == false
					&& jQuery("#patCatOtherInsurance").attr('checked') == false
					&& jQuery("#patCatMalaria").attr('checked') == false
					&& jQuery("#patCatWaiver").attr('checked') == false) {
				jQuery("#patCatGeneral").attr("checked", "checked");					
			} else {
			    if (jQuery("#patCatHIV").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
				}
				
				if (jQuery("#patCatChildLessThan5yr").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
				}
				
				if (jQuery("#patCatNHIF").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
					
					if (jQuery("#nhifCardNumber").val().length <= 0) {
						alert('Please enter the NHIF Card Number');
						return false;
					}
				}
				
				if (jQuery("#patCatTB").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
				}

				if (jQuery("#patCatMother").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
				}
				
				if (jQuery("#patCatOtherInsurance").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
				}
				
				if (jQuery("#patCatMalaria").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
				}
				
				if (jQuery("#patCatWaiver").attr('checked')) {
					if (jQuery("#waiverNumber").val().length <= 0) {
						alert('Please enter the Waiver Number');
						return false;
					}
				}
				return true;
			  }
			},
		
		/** CHECK WHEN HIV CATEGORY IS SELECTED */
		hivCheck : function() {
			if (jQuery("#patCatHIV").is(':checked')) {
				if (jQuery("#patCatGeneral").is(":checked")) {
					jQuery("#patCatGeneral").removeAttr("checked");
				}
				
					jQuery("#patCatChildLessThan5yr").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatNHIF").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					jQuery("#nhifCardNumber").val("");
					jQuery("#nhifCardField1").hide();
				    jQuery("#nhifCardField2").hide();
				
					jQuery("#patCatTB").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatMother").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatOtherInsurance").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatMalaria").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatWaiver").removeAttr("checked");
				    jQuery("#waiverNumber").val("");
					jQuery("#waiverField1").hide();
				    jQuery("#waiverField2").hide();
				    
				    jQuery("#exemptionField1").show();
				    jQuery("#exemptionField2").show();

			}
			else {
			jQuery("#exemptionNumber").val("");
			jQuery("#exemptionField1").hide();
			jQuery("#exemptionField2").hide();
			}
		},

		/** CHECK WHEN child < 5 yr CATEGORY IS SELECTED */
		childYearCheck : function() {
			if (jQuery("#patCatChildLessThan5yr").is(':checked')) {
				if (jQuery("#patCatGeneral").is(":checked")) {
					jQuery("#patCatGeneral").removeAttr("checked");
				}

					jQuery("#patCatHIV").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatNHIF").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					jQuery("#nhifCardNumber").val("");
					jQuery("#nhifCardField1").hide();
				    jQuery("#nhifCardField2").hide();
				
					jQuery("#patCatTB").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatMother").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatOtherInsurance").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatMalaria").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatWaiver").removeAttr("checked");
				    jQuery("#waiverNumber").val("");
					jQuery("#waiverField1").hide();
				    jQuery("#waiverField2").hide();

					if (!VALIDATORS.checkPatientAgeForChildLessThan5yr()) {
					jQuery("#patCatChildLessThan5yr").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
					jQuery("#exemptionField2").hide();
					return false;
				}
				    jQuery("#exemptionField1").show();
				    jQuery("#exemptionField2").show();
			}
			else{
			jQuery("#exemptionNumber").val("");
			jQuery("#exemptionField1").hide();
			jQuery("#exemptionField2").hide();
			}
		},
		
		/** CHECK WHEN NHIF CATEGORY IS SELECTED */
		nhifCheck : function() {
			if (jQuery("#patCatNHIF").is(':checked')) {
				if (jQuery("#patCatGeneral").is(":checked")) {
					jQuery("#patCatGeneral").removeAttr("checked");
				}
				
					jQuery("#patCatHIV").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatChildLessThan5yr").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				
					jQuery("#patCatTB").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatMother").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatOtherInsurance").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatMalaria").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatWaiver").removeAttr("checked");
				    jQuery("#waiverNumber").val("");
					jQuery("#waiverField1").hide();
				    jQuery("#waiverField2").hide();
				    
				    jQuery("#exemptionField1").show();
				    jQuery("#exemptionField2").show();
				    jQuery("#nhifCardField1").show();
				    jQuery("#nhifCardField2").show();
			}
			else {
			jQuery("#exemptionNumber").val("");
			jQuery("#nhifCardNumber").val("");
			jQuery("#exemptionField1").hide();
			jQuery("#exemptionField2").hide();
			jQuery("#nhifCardField1").hide();
			jQuery("#nhifCardField2").hide();
			}
		},

		/** CHECK WHEN TV CATEGORY IS SELECTED */
		tvCheck : function() {
			if (jQuery("#patCatTB").is(':checked')) {
				if (jQuery("#patCatGeneral").is(":checked")) {
					jQuery("#patCatGeneral").removeAttr("checked");
				}
				
					jQuery("#patCatHIV").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatChildLessThan5yr").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatNHIF").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					jQuery("#nhifCardNumber").val("");
					jQuery("#nhifCardField1").hide();
				    jQuery("#nhifCardField2").hide();
					
					jQuery("#patCatMother").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatOtherInsurance").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatMalaria").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatWaiver").removeAttr("checked");
				    jQuery("#waiverNumber").val("");
					jQuery("#waiverField1").hide();
				    jQuery("#waiverField2").hide();
				    
				    jQuery("#exemptionField1").show();
				    jQuery("#exemptionField2").show();
			}
			else {
			jQuery("#exemptionNumber").val("");
			jQuery("#exemptionField1").hide();
			jQuery("#exemptionField2").hide();
			}
		},
		
		/** CHECK WHEN Expectant mother CATEGORY IS SELECTED */
		motherCheck : function() {
			if (jQuery("#patCatMother").is(':checked')) {
				if (jQuery("#patCatGeneral").is(":checked")) {
					jQuery("#patCatGeneral").removeAttr("checked");
				}
				
					jQuery("#patCatHIV").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatChildLessThan5yr").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatNHIF").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					jQuery("#nhifCardNumber").val("");
					jQuery("#nhifCardField1").hide();
				    jQuery("#nhifCardField2").hide();
				    
				    jQuery("#patCatTB").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatOtherInsurance").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatMalaria").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatWaiver").removeAttr("checked");
				    jQuery("#waiverNumber").val("");
					jQuery("#waiverField1").hide();
				    jQuery("#waiverField2").hide();
				    
				if (jQuery("#patientGender").val() == "M") {
					jQuery("#patCatMother").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
					jQuery("#exemptionField2").hide();
					alert("This category is only valid for female patient");
					return false;
				}
					jQuery("#exemptionField1").show();
				    jQuery("#exemptionField2").show();
			}
			else {
			jQuery("#exemptionNumber").val("");
			jQuery("#exemptionField1").hide();
			jQuery("#exemptionField2").hide();
			}

		},
		
		/** CHECK WHEN OTHER INSURANCE CATEGORY IS SELECTED */
		otherInsuranceCheck : function() {
			if (jQuery("#patCatOtherInsurance").is(':checked')) {
				if (jQuery("#patCatGeneral").is(":checked")) {
					jQuery("#patCatGeneral").removeAttr("checked");
				}
				
					jQuery("#patCatHIV").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatChildLessThan5yr").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatNHIF").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					jQuery("#nhifCardNumber").val("");
					jQuery("#nhifCardField1").hide();
				    jQuery("#nhifCardField2").hide();
				    
				    jQuery("#patCatTB").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatMother").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatMalaria").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatWaiver").removeAttr("checked");
				    jQuery("#waiverNumber").val("");
					jQuery("#waiverField1").hide();
				    jQuery("#waiverField2").hide();
				    
				    jQuery("#exemptionField1").show();
				    jQuery("#exemptionField2").show();
			}
			else {
			jQuery("#exemptionNumber").val("");
			jQuery("#exemptionField1").hide();
			jQuery("#exemptionField2").hide();
			}
		},
		
		/** CHECK WHEN MALARIA CATEGORY IS SELECTED */
		malariaCheck : function() {
			if (jQuery("#patCatMalaria").is(':checked')) {
				if (jQuery("#patCatGeneral").is(":checked")) {
					jQuery("#patCatGeneral").removeAttr("checked");
				}
				
					jQuery("#patCatHIV").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatChildLessThan5yr").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatNHIF").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					jQuery("#nhifCardNumber").val("");
					jQuery("#nhifCardField1").hide();
				    jQuery("#nhifCardField2").hide();
				    
				    jQuery("#patCatTB").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatMother").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatOtherInsurance").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatWaiver").removeAttr("checked");
				    jQuery("#waiverNumber").val("");
					jQuery("#waiverField1").hide();
				    jQuery("#waiverField2").hide();
				    
				    jQuery("#exemptionField1").show();
				    jQuery("#exemptionField2").show();
			}
			else {
			jQuery("#exemptionNumber").val("");
			jQuery("#exemptionField1").hide();
			jQuery("#exemptionField2").hide();
			}
		},
		
		/** CHECK WHEN WAIVER CASE CATEGORY IS SELECTED */
		waiverCheck : function() {
			if (jQuery("#patCatWaiver").is(':checked')) {
				if (jQuery("#patCatGeneral").is(":checked")) {
					jQuery("#patCatGeneral").removeAttr("checked");
				}
				
					jQuery("#patCatHIV").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatChildLessThan5yr").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatNHIF").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					jQuery("#nhifCardNumber").val("");
					jQuery("#nhifCardField1").hide();
				    jQuery("#nhifCardField2").hide();
				    
				    jQuery("#patCatTB").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatMother").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatOtherInsurance").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatMalaria").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
					jQuery("#waiverField1").show();
				    jQuery("#waiverField2").show();
			}
			else {
			jQuery("#waiverNumber").val("");
			jQuery("#waiverField1").hide();
		    jQuery("#waiverField2").hide();
			}
		},
		
		/** CHECK WHEN GENERAL CATEGORY IS SELECTED */
		generalCheck : function(obj) {
			if (jQuery("#patCatGeneral").is(':checked')) {
				
					jQuery("#patCatHIV").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatChildLessThan5yr").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatNHIF").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					jQuery("#nhifCardNumber").val("");
					jQuery("#nhifCardField1").hide();
				    jQuery("#nhifCardField2").hide();
				    
				    jQuery("#patCatTB").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatMother").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatOtherInsurance").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatMalaria").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatWaiver").removeAttr("checked");
				    jQuery("#waiverNumber").val("");
					jQuery("#waiverField1").hide();
				    jQuery("#waiverField2").hide();
			}
		},

		
		copyaddress : function () {
			if (jQuery("#sameAddress").is(':checked')) {
				jQuery("#relativePostalAddress").val(jQuery("#patientPostalAddress").val());
		}
		else {	jQuery("#relativePostalAddress").val('');
		}
		},
		
		checkPatientAgeForChildLessThan5yr : function() {
			estAge = jQuery("#estimatedAge").html();
			var rest=estAge.slice(1,-6); 
			if (rest>5) {
				if (jQuery("#patCatChildLessThan5yr").is(':checked')) {
					alert("This category is only valid for patient under 5 years of age");
					return false;
				}
			}
			return true;
		},

				/*
				 * Check patient gender
				 */
				genderCheck : function() {

					jQuery("#patientRelativeNameSection").empty();
					if (jQuery("#patientGender").val() == "M") {
						jQuery("#patientRelativeNameSection")
								.html(
										'<input type="radio" name="person.attribute.15" value="Son of" checked="checked"/> Son of');
					} else if(jQuery("#patientGender").val() == "F"){
						jQuery("#patientRelativeNameSection")
								.html(
										'<input type="radio" name="person.attribute.15" value="Daughter of"/> Daughter of <input type="radio" name="person.attribute.15" value="Wife of"/> Wife of');
					}
				},
			};
			
function showOtherNationality(){
	var optionValue=jQuery("#patientNation option:selected" ).text();
	if(optionValue=="Other"){
	jQuery("#otherNationality").show();
	  }
	  else{
	  jQuery("#otherNationality").hide();
	  }
	}
</script>
<h3 align="center" style="color:black">EDIT PATIENT INFORMATION</h3>
<br><br>
<form id="patientRegistrationForm" method="POST">
		<div class="floatLeft">
		<table>
			<tr>
				<td><b>Patient Name</b><label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Surname<label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="text" id="surName" name="patient.surName" style='width: 152px; 	border-width: 1px;
	border-right: 1px;
	border-left: 1px;
	border-top: 1px;
	border-bottom: 1px;
	border-color: black;
	border-style: solid;
'>
				</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>First Name<label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="text" id="firstName" name="patient.firstName" style='width: 152px; 	border-width: 1px;
	border-right: 1px;
	border-left: 1px;
	border-top: 1px;
	border-bottom: 1px;
	border-color: black;
	border-style: solid;
'>
				</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Given Name&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="text" id="givenName" name="patient.givenName" style='width: 152px; 	border-width: 1px;
	border-right: 1px;
	border-left: 1px;
	border-top: 1px;
	border-bottom: 1px;
	border-color: black;
	border-style: solid;
'>
				</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Other Name&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="text" id="otherName" name="patient.otherName" style='width: 152px; 	border-width: 1px;
	border-right: 1px;
	border-left: 1px;
	border-top: 1px;
	border-bottom: 1px;
	border-color: black;
	border-style: solid;
'>
				</td>
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
					</select>
				</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Marital Status<label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><select id="maritalStatus" name="person.attribute.26" style='width: 152px;'>
										<option value="Marital"></option>
										<option value="Single">Single</option>
										<option value="Married">Married</option>
										<option value="Divorced">Divorced</option>
										<option value="Widow">Widow</option>
										<option value="Widower">Widower</option>
										<option value="Separated">Separated</option>
					</select>
				</td>
			</tr>
			<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
			<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
			<tr>
				<td><b>Address</b><label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Physical Address<label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="patientPostalAddress" name="patient.address.postalAddress" style="width: 152px;"/>
				</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>County&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><select id="districts" name="patient.address.district"
							onChange="PAGE.changeDistrict();" style="width: 152px;">
						</select>
				</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Sub-county&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><select id="upazilas" name="patient.address.upazila"
							style="width: 152px;">
						</select>
				</td>
			</tr>
			<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
			<tr>
				<td><b>Contact Number&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="patientPhoneNumber"
				name="person.attribute.16" style='width: 152px;' />
				</td>
			</tr>
			<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
			<tr>
				<td><b>E-mail Address&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="patientEmail"
				name="person.attribute.37" style='width: 152px;' />
				</td>
			</tr>
			<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
			<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
			<tr>
				<td><b>Next of Kin(NOK)&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
				<td>Relative Name<label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="patientRelativeName" name="person.attribute.8" style='width: 152px;' />
				</td>
			</tr>
			<tr>
				<td><b>Information</b><label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Relationship Type<label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><select id="relationshipType" name="person.attribute.15" style='width: 152px;'>
										<option value="Relationship"></option>
										<option value="Parent">Parent</option>
										<option value="Spouse">Spouse</option>
										<option value="Guardian">Guardian</option>
										<option value="Friend">Friend</option>
										<option value="Other">Other</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Physical Address&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="text" id="relativePostalAddress" name="person.attribute.28" style='width: 152px; 	border-width: 1px;
	border-right: 1px;
	border-left: 1px;
	border-top: 1px;
	border-bottom: 1px;
	border-color: black;
	border-style: solid;
'/>
				<input id="sameAddress" type="checkbox"/> Same as above
				</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Contact Number&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="relativePhoneNumber" name="person.attribute.29" style='width: 152px;' />
				</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>E-mail Address&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="relativeEmail" name="person.attribute.30" style='width: 152px;' />
				</td>
			</tr>
			<tr></tr>
			<!--  
			<tr>
				<td><input type="submit" value="Save"></td>
				<td><input type="button" value="Reset"
					onclick="window.location.href=window.location.href"></td>
			</tr>
			-->
		</table>
		</div>
		<div class="floatRight">
		<table>
		<tr>
				<td><b>Patient Identifier</b><label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input readonly name="patient.identifier" style="border: none; width: 250px; background-color:white; font-weight:bold" /></td>
		</tr>
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		<tr>
				<td><b>Client Identification&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
				<td>Nationality</td>
				<td><select id="patientNation" name="person.attribute.27" style="width: 152px;" onchange="showOtherNationality();">
										<option value="Nation"></option>
										<option value="Kenya">Kenya</option>
										<option value="East Africa">East Africa</option>
										<option value="Kenyan">Africa</option>
										<option value="Algeria">Algeria</option>
										<option value="Angola">Angola</option>
										<option value="Benin">Benin</option>
										<option value="Botswana">Botswana</option>
										<option value="Burkina Faso">Burkina Faso</option>
										<option value="Burundi">Burundi</option>
										<option value="Cameroon">Cameroon</option>
										<option value="Cape Verde">Cape Verde</option>
										<option value="Central African Republic">Central African Republic</option>
										<option value="Chad">Chad</option>
										<option value="Comoros">Comoros</option>
										<option value="Cote d'Ivoire">Cote d'Ivoire</option>
										<option value="Democratic Republic of Congo">Democratic Republic of Congo</option>
										<option value="Djibouti">Djibouti</option>
										<option value="Egypt">Egypt</option>
										<option value="Equatorial Guinea">Equatorial Guinea</option>
										<option value="Eritrea">Eritrea</option>
										<option value="Ethiopia">Ethiopia</option>
										<option value="Gabon">Gabon</option>
										<option value="Gambia">Gambia</option>
										<option value="Ghana">Ghana</option>
										<option value="Guinea">Guinea</option>
										<option value="Guinea-Bissau">Guinea-Bissau</option>
										<option value="Lesotho">Lesotho</option>
										<option value="Liberia">Liberia</option>
										<option value="Libya">Libya</option>
										<option value="Madagascar">Madagascar</option>
										<option value="Malawi">Malawi</option>
										<option value="Mali">Mali</option>
										<option value="Mauritania">Mauritania</option>
										<option value="Mauritius">Mauritius</option>
										<option value="Morocco">Morocco</option>
										<option value="Mozambique">Mozambique</option>
										<option value="Namibia">Namibia</option>
										<option value="Niger">Niger</option>
										<option value="Nigeria">Nigeria</option>
										<option value="Republic of Congo">Republic of Congo</option>
										<option value="Rwanda">Rwanda</option>
										<option value="Sao Tome and Principe">Sao Tome and Principe</option>
										<option value="Senegal">Senegal</option>
										<option value="Seychelles">Seychelles</option>
										<option value="Sierra Leone">Sierra Leone</option>
										<option value="Somalia">Somalia</option>
										<option value="South Africa">South Africa</option>
										<option value="South Sudan">South Sudan</option>
										<option value="Sudan">Sudan</option>
										<option value="Swaziland">Swaziland</option>
										<option value="Tanzania">Tanzania</option>
										<option value="Togo">Togo</option>
										<option value="Tunisia">Tunisia</option>
										<option value="Uganda">Uganda</option>
										<option value="Zambia">Zambia</option>
										<option value="Zimbabwe">Zimbabwe</option>
										<option value="Other">Other</option>
						</select></td>
		<td><span id="otherNationality"><input id="otherNationalityId" name="person.attribute.39" placeholder="Please specify" style='width: 152px;'/></span></td>
		</tr>
		<tr>
		<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td>National ID&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td><input id="patientNationalId" name="patient.attribute.20" style='width: 152px;'/></td>
		</tr>
		<tr>
		<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td>Passport Number&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td><input id="passportNumber" name="patient.attribute.38" style='width: 152px;'/></td>
		</tr>
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		<tr>
				<td id="catGen"><input id="patCatGeneral" type="checkbox" name="person.attribute.14" value="General" /> General</td>
				<td><b>Patient Category&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
				<td><input id="patCatHIV" type="checkbox" name="person.attribute.14" value="HIV" /> HIV</td>
				<td><input id="patCatChildLessThan5yr" type="checkbox" name="person.attribute.14" value="Child Less Than 5 yr" /> Child less than 5 years old&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="patCatNHIF" type="checkbox" name="person.attribute.14" value="NHIF" /> NHIF</td>
		</tr>
		<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="patCatTB" type="checkbox" name="person.attribute.14" value="TB" /> TB</td>
				<td><input id="patCatMother" type="checkbox" name="person.attribute.14" value="Expectant Mother" /> Expectant Mother&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="patCatOtherInsurance" type="checkbox" name="person.attribute.14" value="Other Insurance" /> Other Insurance</td>
		</tr>
		<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="patCatMalaria" type="checkbox" name="person.attribute.14" value="Malaria" /> Malaria</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="patCatWaiver" type="checkbox" name="person.attribute.14" value="Waiver" /> Waiver Case</td>
		</tr>
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><span id="exemptionField1">Exemption Number</span></td>
				<td><span id="exemptionField2"><input id="exemptionNumber" name="person.attribute.36" style="width: 152px;"/></span></td>
		</tr>
		<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><span id="nhifCardField1">NHIF Card Number</span></td>
				<td><span id="nhifCardField2"><input id="nhifCardNumber" name="person.attribute.33" style="width: 152px;"/></span></td>
		</tr>
		<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><span id="waiverField1">Waiver Number</span></td>
				<td><span id="waiverField2"><input id="waiverNumber" name="person.attribute.32" style="width: 152px;"/></span></td>
		</tr>
		<tr>
		</tr>
		</table>
		</div>
		<div id="validationMessage"></div>
		
		<table align="left">
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		
		<tr>
		<td><input type="button" value="Save" onclick="PAGE.submit();" style="font-weight:bold"/>
		    <input type="button" value="Reset" onclick="window.location.href=window.location.href" style="font-weight:bold"/>
		</td>
		</tr>
		</table>

	</form>