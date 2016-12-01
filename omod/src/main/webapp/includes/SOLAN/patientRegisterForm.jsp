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
				jQuery('#birthdate').change(PAGE.checkBirthDate);
				PAGE.fillOptions("#districts", {
					data : MODEL.districts
				});
				PAGE.fillOptions("#tehsils", {
					data : MODEL.tehsils[0].split(',')
				});

				MODEL.OPDs = " ,Please select an OPD room to visit|"
						+ MODEL.OPDs;
				PAGE.fillOptions("#opdWard", {
					data : MODEL.OPDs,
					delimiter : ",",
					optionDelimiter : "|"
				});
				MODEL.referralHospitals = " , Select referral Hospitals|"
					+ MODEL.referralHospitals;
				PAGE.fillOptions("#referralHospitals", {
					data : MODEL.referralHospitals,
					delimiter : ",",
					optionDelimiter : "|"
				});
				MODEL.referralReasons = " , Select referral Reasons|"
					+ MODEL.referralReasons;
				PAGE.fillOptions("#referralReasons	", {
					data : MODEL.referralReasons,
					delimiter : ",",
					optionDelimiter : "|"
				});

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

				// hide bpl and rsby number
				jQuery("#bplField").hide();
				jQuery("#rsbyField").hide();
				jQuery("#patCatGeneral").attr("checked", "checked");
				//17/05/2012 Marta: hide free category description field #188
				jQuery("#freeField").hide();
				document.getElementById("freeCategory").style.visibility = "hidden";

				// binding
				jQuery("#bpl").click(function() {
					VALIDATORS.bplCheck();
				});
				jQuery("#rsby").click(function() {
					VALIDATORS.rsbyCheck();
				});
				jQuery("#patCatStaff").click(function() {
					VALIDATORS.staffCheck();
				});
				//17/05/2012 Marta: Delete Poor and Governement Employee Categories #188
				/*jQuery("#patCatPoor").click(function() {
					VALIDATORS.poorCheck();
				});*/
				jQuery("#patCatGeneral").click(function() {
					VALIDATORS.generalCheck();
				});
				//17/05/2012 Marta: Delete Poor and Governement Employee Categories #188
				/*jQuery("#patCatGovEmp").click(function() {
					VALIDATORS.governmentCheck();
				});*/
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
				// 26/5/2012 Marta: Changing categories to match with requirements on #240 
				/*jQuery("#patCatSeniorCitizen").click(function() {
					VALIDATORS.seniorCitizenCheck();
				});*/
				jQuery("#patientGender").change(function() {
					VALIDATORS.genderCheck();
				});
				// 11/05/2012: Thai Chuong added for Solan new categories validation - Bug #188
				jQuery("#patCatAntenatal").click(function() {
					VALIDATORS.patCatAntenatalCheck();
				});
				jQuery("#patCatChildLessThan1yr").click(function() {
					VALIDATORS.patCatChildLessThan1yrCheck();
				});
				jQuery("#patCatOtherFree").click(function() {
					VALIDATORS.patCatOtherFreeCheck();
				});
				
				//ghanshyam 07-sept-2013 Support #2686 GUI Changes (spellings/ fonts/ alignments)
				jQuery("#bh").hide();
				//ghanshyam 12-sept-2013 New Requirement #2684 Introducing a field at the time of registration to put Aadhar Card Number
				jQuery("#aadharCardReason").hide();

			});

	/**
	 ** FORM
	 **/
	PAGE = {
		/** SUBMIT */
		submit : function() {

			// Capitalize fullname and relative name
			fullNameInCapital = StringUtils.capitalize(jQuery(
					"#nameOrgivenNameOrmiddleNameOrfamilyNameOrIdentifier", jQuery("#patientSearchForm")).val());
			jQuery("#patientName", jQuery("#patientRegistrationForm")).val(
					fullNameInCapital);
			jQuery("#nameOrgivenNameOrmiddleNameOrfamilyNameOrIdentifier", jQuery("#patientSearchForm")).val(
					fullNameInCapital);
			jQuery("#patientName", jQuery("#patientRegistrationForm")).val(
					fullNameInCapital);
			relativeNameInCaptital = StringUtils.capitalize(jQuery(
					"#patientRelativeName").val());
			jQuery("#patientRelativeName").val(relativeNameInCaptital);

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
		
		//ghanshyam 12-sept-2013 New Requirement #2684 Introducing a field at the time of registration to put Aadhar Card Number
		checkAadharCardNumber : function() {
		        aadharCardNo=jQuery("#aadharCardNo").val();
				jQuery.ajax({
				type : "GET",
				url : getContextPath() + "/module/registration/validateaadharcardnoreg.form",
				data : ({
					aadharCardNo			: aadharCardNo
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
									jQuery("#birthdateEstimated").val("true");
									//ghanshyam 07-sept-2013 Support #2686 GUI Changes (spellings/ fonts/ alignments)
									jQuery("#birthdateh").hide();
									jQuery("#birthdate").hide();
									jQuery("#calendarButton").hide();
									jQuery("#bh").show();
								} else {
									jQuery("#birthdateEstimated").val("false");
								}

								jQuery("#estimatedAge").html(json.age);
								jQuery("#birthdate").val(json.birthdate);
								jQuery("#calendar").val(json.birthdate);
							} else {
								alert(json.error);
								// 09/05/12: Added by Thai Chuong to avoid commiting wrong birthdates - Bug #137
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

			// get the list of tehsils
			tehsilList = "";
			selectedDistrict = jQuery("#districts option:checked").val();
			jQuery.each(MODEL.districts, function(index, value) {
				if (value == selectedDistrict) {
					tehsilList = MODEL.tehsils[index];
				}
			});

			// fill tehsils into tehsil dropdown
			this.fillOptions("#tehsils", {
				data : tehsilList.split(",")
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

		/** CALLBACK WHEN SEARCH PATIENT SUCCESSFULLY */
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
		},

		/** VALIDATE FORM */
		validateRegisterForm : function() {

			if (StringUtils.isBlank(jQuery("#patientName").val())) {
				alert("Please enter patient name");
				return false;
			} // 09/05/2012: Thai Chuong, Added pattern checking to avoid special characters in patient name - Bug #135
			else {
				value = jQuery("#patientName").val();
				value = value.toUpperCase();
				pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -";
				for (i = 0; i < value.length; i++) {
					if (pattern.indexOf(value[i]) < 0) {
						alert("Please enter patient name/identifier in correct format.");
						return false;
					}
				}
			}

			if (StringUtils.isBlank(jQuery("#patientRelativeName").val())) {
				alert("Please enter relative name");
				return false;
			} else {
				if (jQuery("#patientGender").val() == "M"||jQuery("#patientGender").val() == "F") {
					if (jQuery("#patientRegistrationForm input[name=person.attribute.15]:checked").length == 0) {
						alert("Please select relative name type");
						return false;
					}
				}
			}

			if (StringUtils.isBlank(jQuery("#birthdate").val())) {
				alert("Please enter birthdate or age");
				return false;
			} // 26/5/2012 Marta: Changing categories to match with requirements on #240
			else {
				/*if (!VALIDATORS.checkPatientAgeForSeniorCitizen()) {
					return false;*/
				if (!VALIDATORS.checkPatientAgeForChildLessThan1yr()) {
					return false;
				}
			}

			if (jQuery("#patientGender").val() == "Any") {
				alert("Please select gender");
				return false;
			} // 26/5/2012 Marta: Changing categories to match with requirements on #240
			else {
				if (!VALIDATORS.checkGenderForAntenatal()) {
					return false;
				}
			}

			if (StringUtils.isBlank(jQuery("#opdWard").val())) {
				alert("Please select OPD ward");
				return false;
			}
			;

			if (!VALIDATORS.validatePatientCategory()) {
				return false;
			}

			if (!StringUtils.isBlank(jQuery("#patientPhoneNumber").val())) {
				if (!StringUtils.isDigit(jQuery("#patientPhoneNumber").val())) {
					alert("Please enter phone number in correct format");
					return false;
				}
			}
			
			//ghanshyam 12-sept-2013 New Requirement #2684 Introducing a field at the time of registration to put Aadhar Card Number
			if (jQuery("#yes").attr('checked') == false
					&& jQuery("#no").attr('checked') == false) {
				alert('Please select Yes or No for  Aadhar Card Number!');
				return false;
			} else {
			if (jQuery("#yes").attr('checked')) {
					if (jQuery("#aadharCardNo").val().length <= 0 || jQuery("#aadharCardNo").val().length!=12) {
						alert('Please enter 12 digit Aadhar Card');
						return false;
					} 
				}
			else if(jQuery("#no").attr('checked')){
			       if (jQuery("#aadharCardReason").val().length <= 0) {
						alert('Please enter Aadhar Card Reason');
						return false;
					} 
			   }	
			}	
			
			        //PAGE.checkAadharCardNumber();
			        /*
			        var patientCategoryDisabled=document.getElementById('patientCategory').disabled;
			        if(patientCategoryDisabled==false){
			        var patientCategory=document.getElementById('patientCategory');
			        if(patientCategory.value==""){
			        alert("Please select Patient Category");
					return false
			        }
			        }*/
		            //alert("click ok to proceed");
		            //abc=jQuery("#abc").val();
					//def=jQuery("#def").val();
					aadharCardNo=jQuery("#aCardNo").val();
				
					if(typeof aadharCardNo!="undefined"){
					if(aadharCardNo=="1"){
		            alert("Patient already registered with this  Aadhar Card Number");
					return false
		            }
		       
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
			var patientCategoryDisabled=document.getElementById('patientCategory').disabled;
			if (jQuery("#rsby").attr('checked') == false
				&& jQuery("#bpl").attr('checked') == false
				&& patientCategoryDisabled==false) {
				var patientCategory=document.getElementById('patientCategory');
				if(patientCategory.value==""){
				alert('You didn\'t choose any of the patient categories!');
				return false;
				}
				else{
				return true;
				}
			} else {
				if (jQuery("#rsby").attr('checked')) {
					if (jQuery("#rsbyNumber").val().length <= 0) {
						alert('Please enter RSBY number');
						return false;
					}
				}
				if (jQuery("#bpl").attr('checked')) {
					if (jQuery("#bplNumber").val().length <= 0) {
						alert('Please enter BPL number');
						return false;
					}
				}
				//17/05/2012 Marta: Delete Poor and Governement Employee Categories #188
				if (jQuery("#patCatOtherFree").attr('checked')) {
					if (jQuery("#freeCategory").val().length <= 0) {
						alert('Please enter Other Free Category Description');
						return false;
					}
				}
				return true;
			}
		},

		/** CHECK WHEN BPL CATEGORY IS SELECTED */
		bplCheck : function() {
			if (jQuery("#bpl").is(':checked')) {
				jQuery("#bplField").show();
				if (jQuery("#patCatGeneral").is(":checked"))
					jQuery("#patCatGeneral").removeAttr("checked");
				if (jQuery("#patCatStaff").is(":checked")) {
					jQuery("#patCatStaff").removeAttr("checked");
				}
				//17/05/2012 Marta: Delete Poor and Governement Employee Categories #188
				/*if (jQuery("#patCatGovEmp").is(":checked"))
					jQuery("#patCatGovEmp").removeAttr("checked");
				if (jQuery("#patCatPoor").is(":checked"))
					jQuery("#patCatPoor").removeAttr("checked");*/
				// 26/5/2012 Marta: Changing categories to match with requirements on #240
				/*if (jQuery("#patCatSeniorCitizen").is(":checked"))
					jQuery("#patCatSeniorCitizen").removeAttr("checked");*/
				// 11/05/2012: Thai Chuong added for Solan new categories validation - Bug #188
				if (jQuery("#patCatAntenatal").is(":checked"))
					jQuery("#patCatAntenatal").removeAttr("checked");
				if (jQuery("#patCatChildLessThan1yr").is(":checked"))
					jQuery("#patCatChildLessThan1yr").removeAttr("checked");
				//17/05/2012 Marta: Add Free Category text field #188
				if (jQuery("#patCatOtherFree").is(":checked")) {
					jQuery("#patCatOtherFree").removeAttr("checked");
					jQuery("#freeCategory").val("");
					jQuery("#freeField").hide();
				}
			} else {
				jQuery("#bplNumber").val("");
				jQuery("#bplField").hide();
			}
		},

		/** CHECK WHEN RSBY CATEGORY IS SELECTED */
		rsbyCheck : function() {
			if (jQuery("#rsby").is(':checked')) {
				jQuery("#rsbyField").show();
				if (jQuery("#patCatGeneral").is(":checked"))
					jQuery("#patCatGeneral").removeAttr("checked");
				if (jQuery("#patCatStaff").is(":checked")) {
					jQuery("#patCatStaff").removeAttr("checked");
				}
				//17/05/2012 Marta: Delete Poor and Governement Employee Categories #188
				/*if (jQuery("#patCatGovEmp").is(":checked"))
					jQuery("#patCatGovEmp").removeAttr("checked");
				if (jQuery("#patCatPoor").is(":checked"))
					jQuery("#patCatPoor").removeAttr("checked");*/
				// 26/5/2012 Marta: Changing categories to match with requirements on #240
				/*if (jQuery("#patCatSeniorCitizen").is(":checked"))
					jQuery("#patCatSeniorCitizen").removeAttr("checked");*/
				// 11/05/2012: Thai Chuong added for Solan new categories validation - Bug #188
				if (jQuery("#patCatAntenatal").is(":checked"))
					jQuery("#patCatAntenatal").removeAttr("checked");
				if (jQuery("#patCatChildLessThan1yr").is(":checked"))
					jQuery("#patCatChildLessThan1yr").removeAttr("checked");
				//17/05/2012 Marta: Add Free Category text field #188
				if (jQuery("#patCatOtherFree").is(":checked")) {
					jQuery("#patCatOtherFree").removeAttr("checked");
					jQuery("#freeCategory").val("");
					jQuery("#freeField").hide();
				}
			} else {
				jQuery("#rsbyNumber").val("");
				jQuery("#rsbyField").hide();
			}
		},

		/** CHECK WHEN STAFF CATEGORY IS SELECTED */
		staffCheck : function() {
			if (jQuery("#patCatStaff").is(':checked')) {
				if (jQuery("#bpl").is(":checked")) {
					jQuery("#bpl").removeAttr("checked");
					jQuery("#bplNumber").val("");
					jQuery("#bplField").hide();
				}
				if (jQuery("#rsby").is(":checked")) {
					jQuery("#rsby").removeAttr("checked");
					jQuery("#rsbyNumber").val("");
					jQuery("#rsbyField").hide();
				}
				//17/05/2012 Marta: Delete Poor and Governement Employee Categories #188
				/*if (jQuery("#patCatPoor").is(":checked"))
					jQuery("#patCatPoor").removeAttr("checked");
				if (jQuery("#patCatGovEmp").is(":checked"))
					jQuery("#patCatGovEmp").removeAttr("checked");*/
				// 11/05/2012: Thai Chuong added for Solan new categories validation - Bug #188
				if (jQuery("#patCatAntenatal").is(":checked"))
					jQuery("#patCatAntenatal").removeAttr("checked");
				if (jQuery("#patCatChildLessThan1yr").is(":checked"))
					jQuery("#patCatChildLessThan1yr").removeAttr("checked");
				//17/05/2012 Marta: Add Free Category text field #188
				if (jQuery("#patCatOtherFree").is(":checked")) {
					jQuery("#patCatOtherFree").removeAttr("checked");
					jQuery("#freeCategory").val("");
					jQuery("#freeField").hide();
				}
				// 17/05/2012: Marta added for Solan new categories validation - Bug #188
				// 26/5/2012 Marta: Changing categories to match with requirements on #240
				/*if (jQuery("#patCatSeniorCitizen").is(":checked"))
					jQuery("#patCatSeniorCitizen").removeAttr("checked");
				 */if (jQuery("#patCatGeneral").is(":checked"))
					jQuery("#patCatGeneral").removeAttr("checked");
			}
		},

		//17/05/2012 Marta: Delete Poor and Governement Employee Categories #188	
		/** CHECK WHEN POOR CATEGORY IS SELECTED */
		/*poorCheck : function() {
			if (jQuery("#patCatPoor").is(':checked')) {
				if (jQuery("#patCatGeneral").is(":checked"))
					jQuery("#patCatGeneral").removeAttr("checked");
				if (jQuery("#patCatStaff").is(":checked"))
					jQuery("#patCatStaff").removeAttr("checked");
				if (jQuery("#patCatGovEmp").is(":checked"))
					jQuery("#patCatGovEmp").removeAttr("checked");

				if (jQuery("#bpl").is(":checked")) {
					jQuery("#bpl").removeAttr("checked");
					jQuery("#bplNumber").val("");
					jQuery("#bplField").hide();
				}
				if (jQuery("#rsby").is(":checked")) {
					jQuery("#rsby").removeAttr("checked");
					jQuery("#rsbyNumber").val("");
					jQuery("#rsbyField").hide();
				}
				// 11/05/2012: Thai Chuong added for Solan new categories validation - Bug #188
				if (jQuery("#patCatAntenatal").is(":checked"))
					jQuery("#patCatAntenatal").removeAttr("checked");
				if (jQuery("#patCatChildLessThan1yr").is(":checked"))
					jQuery("#patCatChildLessThan1yr").removeAttr("checked");
				if (jQuery("#patCatOtherFree").is(":checked"))
					jQuery("#patCatOtherFree").removeAttr("checked");
				// 17/05/2012: Marta added for Solan new categories validation - Bug #188
				if (jQuery("#patCatSeniorCitizen").is(":checked"))
					jQuery("#patCatSeniorCitizen").removeAttr("checked");
			}
		},*/

		/** CHECK WHEN GENERAL CATEGORY IS SELECTED */
		generalCheck : function(obj) {
			if (jQuery("#patCatGeneral").is(':checked')) {
				if (jQuery("#bpl").is(":checked")) {
					jQuery("#bpl").removeAttr("checked");
					jQuery("#bplNumber").val("");
					jQuery("#bplField").hide();
				}
				if (jQuery("#rsby").is(":checked")) {
					jQuery("#rsby").removeAttr("checked");
					jQuery("#rsbyNumber").val("");
					jQuery("#rsbyField").hide();
				}
				//17/05/2012 Marta: Delete Poor and Governement Employee Categories #188
				/*if (jQuery("#patCatPoor").is(":checked"))
					jQuery("#patCatPoor").removeAttr("checked");*/
				// 26/5/2012 Marta: Changing categories to match with requirements on #215
				/*if (jQuery("#patCatSeniorCitizen").is(":checked"))
					jQuery("#patCatSeniorCitizen").removeAttr("checked");*/
				// 11/05/2012: Thai Chuong added for Solan new categories validation - Bug #188
				if (jQuery("#patCatAntenatal").is(":checked"))
					jQuery("#patCatAntenatal").removeAttr("checked");
				if (jQuery("#patCatChildLessThan1yr").is(":checked"))
					jQuery("#patCatChildLessThan1yr").removeAttr("checked");
				//17/05/2012 Marta: Add Free Category text field #188
				if (jQuery("#patCatOtherFree").is(":checked")) {
					jQuery("#patCatOtherFree").removeAttr("checked");
					jQuery("#freeCategory").val("");
					jQuery("#freeField").hide();
				}
				// 17/05/2012: Marta added for Solan new categories validation - Bug #188
				if (jQuery("#patCatStaff").is(":checked"))
					jQuery("#patCatStaff").removeAttr("checked");
				//17/05/2012 Marta: Delete Poor and Governement Employee Categories #188
				/*if (jQuery("#patCatGovEmp").is(":checked"))
					jQuery("#patCatGovEmp").removeAttr("checked");*/
			}
		},

		//17/05/2012 Marta: Delete Poor and Governement Employee Categories #188
		/** CHECK WHEN GOVERNMENT CATEGORY IS SELECTED */
		/*governmentCheck : function() {
			if (jQuery("#patCatGovEmp").is(':checked')) {
				if (jQuery("#bpl").is(":checked")) {
					jQuery("#bpl").removeAttr("checked");
					jQuery("#bplNumber").val("");
					jQuery("#bplField").hide();
				}
				if (jQuery("#rsby").is(":checked")) {
					jQuery("#rsby").removeAttr("checked");
					jQuery("#rsbyNumber").val("");
					jQuery("#rsbyField").hide();
				}
				if (jQuery("#patCatPoor").is(":checked"))
					jQuery("#patCatPoor").removeAttr("checked");
				if (jQuery("#patCatStaff").is(":checked"))
					jQuery("#patCatStaff").removeAttr("checked");
				// 11/05/2012: Thai Chuong added for Solan new categories validation - Bug #188
				if (jQuery("#patCatAntenatal").is(":checked"))
					jQuery("#patCatAntenatal").removeAttr("checked");
				if (jQuery("#patCatChildLessThan1yr").is(":checked"))
					jQuery("#patCatChildLessThan1yr").removeAttr("checked");
				if (jQuery("#patCatOtherFree").is(":checked"))
					jQuery("#patCatOtherFree").removeAttr("checked");
				// 17/05/2012: Marta added for Solan new categories validation - Bug #188
				if (jQuery("#patCatSeniorCitizen").is(":checked"))
					jQuery("#patCatSeniorCitizen").removeAttr("checked");
				if (jQuery("#patCatGeneral").is(":checked"))
					jQuery("#patCatGeneral").removeAttr("checked");
			}
		},*/

		// 26/5/2012 Marta: Changing categories to match with requirements on #215
		/** CHECK WHEN SENIOR CITIZEN CATEGORY IS SELECTED */
		/*seniorCitizenCheck : function() {
			if (jQuery("#patCatSeniorCitizen").is(':checked')) {
				if (jQuery("#bpl").is(":checked")) {
					jQuery("#bpl").removeAttr("checked");
					jQuery("#bplNumber").val("");
					jQuery("#bplField").hide();
				}
				if (jQuery("#rsby").is(":checked")) {
					jQuery("#rsby").removeAttr("checked");
					jQuery("#rsbyNumber").val("");
					jQuery("#rsbyField").hide();
				}
				//17/05/2012 Marta: Delete Poor and Governement Employee Categories #188
				/*if (jQuery("#patCatPoor").is(":checked"))
					jQuery("#patCatPoor").removeAttr("checked");
				if (jQuery("#patCatGovEmp").is(":checked"))
					jQuery("#patCatGovEmp").removeAttr("checked");*/
		/*if (jQuery("#patCatGeneral").is(":checked"))
			jQuery("#patCatGeneral").removeAttr("checked");
		// 11/05/2012: Thai Chuong added for Solan new categories validation - Bug #188
		if (jQuery("#patCatAntenatal").is(":checked"))
			jQuery("#patCatAntenatal").removeAttr("checked");
		if (jQuery("#patCatChildLessThan1yr").is(":checked"))
			jQuery("#patCatChildLessThan1yr").removeAttr("checked");
		//17/05/2012 Marta: Add Free Category text field #188
		if (jQuery("#patCatOtherFree").is(":checked")){
			jQuery("#patCatOtherFree").removeAttr("checked");
			jQuery("#freeCategory").val("");
			jQuery("#freeField").hide();
		}
		// 17/05/2012: Marta added for Solan new categories validation - Bug #188
		if (jQuery("#patCatStaff").is(":checked"))
			jQuery("#patCatStaff").removeAttr("checked");
			if (!VALIDATORS.checkPatientAgeForSeniorCitizen()) {
			jQuery("#patCatSeniorCitizen").removeAttr("checked");
		}
		;
		}
		},*/

		// 26/5/2012 Marta: Changing categories to match with requirements on #215
		/*
		 * Check patient age for senior citizen
		 */
		// 11/05/2012: Thai Chuong modified for Solan new categories validation - Bug #188
		/*checkPatientAgeForSeniorCitizen : function() {
			// check whether patient age is more than 75
			estAge = jQuery("#estimatedAge").html();
			var digitPattern = /[0-9]+/;
			var age = digitPattern.exec(estAge);
			if (age < 75) {
				if (jQuery("#patCatSeniorCitizen").is(':checked')) {
					alert("Senior citizen category is only for patient over 75 years old!");
					return false;
				}
			}
			return true;
		},*/

		// 26/5/2012 Marta: Changing categories to match with requirements on #240
		checkPatientAgeForChildLessThan1yr : function() {
			// check whether patient age less than one year
			estAge = jQuery("#estimatedAge").html();
			// 6/6/2012 harsh : changed reg ex mapping on bug #243
			var digitPattern = /year/;
			var age = digitPattern.exec(estAge);
			if (age) {
				if (jQuery("#patCatChildLessThan1yr").is(':checked')) {
					alert("Child less than one year is only for patient under 1 year!");
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
			}else if(jQuery("#patientGender").val() == "O"){
				jQuery("#patientRelativeNameSection")
				.html(
				'<input hidden type="radio" name="person.attribute.15" value="Relative of" checked="checked"/>');
			}
		},

		// 26/5/2012 Marta: Changing categories to match with requirements on #240
		checkGenderForAntenatal : function() {
			// check whether patient age less than one year
			if (jQuery("#patientGender").val() == "M") {
				if (jQuery("#patCatAntenatal").is(':checked')) {
					alert("Antenatal Patient is for Female patients!");
					return false;
				}
			}
			return true;
		},
		// 11/05/2012: Thai Chuong added for Solan new categories validation - Bug #188
		/** CHECK WHEN ANTENATAL PATIENT CATEGORY IS SELECTED */
		patCatAntenatalCheck : function() {
			if (jQuery("#patCatAntenatal").is(':checked')) {
				if (jQuery("#bpl").is(":checked")) {
					jQuery("#bpl").removeAttr("checked");
					jQuery("#bplNumber").val("");
					jQuery("#bplField").hide();
				}
				if (jQuery("#rsby").is(":checked")) {
					jQuery("#rsby").removeAttr("checked");
					jQuery("#rsbyNumber").val("");
					jQuery("#rsbyField").hide();
				}
				//17/05/2012 Marta: Delete Poor and Governement Employee Categories #188
				/*if (jQuery("#patCatPoor").is(":checked"))
					jQuery("#patCatPoor").removeAttr("checked");
				if (jQuery("#patCatGovEmp").is(":checked"))
					jQuery("#patCatGovEmp").removeAttr("checked");*/
				if (jQuery("#patCatGeneral").is(":checked"))
					jQuery("#patCatGeneral").removeAttr("checked");
				// 11/05/2012: Thai Chuong modified for Solan new categories validation - Bug #188
				if (jQuery("#patCatChildLessThan1yr").is(":checked"))
					jQuery("#patCatChildLessThan1yr").removeAttr("checked");
				//17/05/2012 Marta: Add Free Category text field #188
				if (jQuery("#patCatOtherFree").is(":checked")) {
					jQuery("#patCatOtherFree").removeAttr("checked");
					jQuery("#freeCategory").val("");
					jQuery("#freeField").hide();
				}
				if (jQuery("#patCatStaff").is(":checked"))
					jQuery("#patCatStaff").removeAttr("checked");
				// 17/05/2012: Marta added for Solan new categories validation - Bug #188
				// 26/5/2012 Marta: Changing categories to match with requirements on #240
				/*if (jQuery("#patCatSeniorCitizen").is(":checked"))
					jQuery("#patCatSeniorCitizen").removeAttr("checked");
				 */
				if (!VALIDATORS.checkGenderForAntenatal()) {
					jQuery("#patCatAntenatal").removeAttr("checked");
				}
			}
		},

		/** CHECK WHEN CHILD LESS THAN 1YR CATEGORY IS SELECTED */
		patCatChildLessThan1yrCheck : function() {
			if (jQuery("#patCatChildLessThan1yr").is(':checked')) {
				if (jQuery("#bpl").is(":checked")) {
					jQuery("#bpl").removeAttr("checked");
					jQuery("#bplNumber").val("");
					jQuery("#bplField").hide();
				}
				if (jQuery("#rsby").is(":checked")) {
					jQuery("#rsby").removeAttr("checked");
					jQuery("#rsbyNumber").val("");
					jQuery("#rsbyField").hide();
				}
				//17/05/2012 Marta: Delete Poor and Governement Employee Categories #188
				/*if (jQuery("#patCatPoor").is(":checked"))
					jQuery("#patCatPoor").removeAttr("checked");
				if (jQuery("#patCatGovEmp").is(":checked"))
					jQuery("#patCatGovEmp").removeAttr("checked");*/
				if (jQuery("#patCatGeneral").is(":checked"))
					jQuery("#patCatGeneral").removeAttr("checked");
				// 11/05/2012: Thai Chuong modified for Solan new categories validation - Bug #188
				if (jQuery("#patCatAntenatal").is(":checked"))
					jQuery("#patCatAntenatal").removeAttr("checked");
				//17/05/2012 Marta: Add Free Category text field #188
				if (jQuery("#patCatOtherFree").is(":checked")) {
					jQuery("#patCatOtherFree").removeAttr("checked");
					jQuery("#freeCategory").val("");
					jQuery("#freeField").hide();
				}
				if (jQuery("#patCatStaff").is(":checked"))
					jQuery("#patCatStaff").removeAttr("checked");
				// 17/05/2012: Marta added for Solan new categories validation - Bug #188
				// 26/5/2012 Marta: Changing categories to match with requirements on #240
				/*if (jQuery("#patCatSeniorCitizen").is(":checked"))
					jQuery("#patCatSeniorCitizen").removeAttr("checked");
				 */
				if (!VALIDATORS.checkPatientAgeForChildLessThan1yr()) {
					jQuery("#patCatChildLessThan1yr").removeAttr("checked");
				}
				;
			}
		},

		/** CHECK WHEN OTHER FREE CATEGORY IS SELECTED */
		patCatOtherFreeCheck : function() {
			if (jQuery("#patCatOtherFree").is(':checked')) {
				jQuery("#freeField").show();
				if (jQuery("#bpl").is(":checked")) {
					jQuery("#bpl").removeAttr("checked");
					jQuery("#bplNumber").val("");
					jQuery("#bplField").hide();
				}
				if (jQuery("#rsby").is(":checked")) {
					jQuery("#rsby").removeAttr("checked");
					jQuery("#rsbyNumber").val("");
					jQuery("#rsbyField").hide();
				}
				//17/05/2012 Marta: Delete Poor and Governement Employee Categories #188
				/*if (jQuery("#patCatPoor").is(":checked"))
					jQuery("#patCatPoor").removeAttr("checked");
				if (jQuery("#patCatGovEmp").is(":checked"))
					jQuery("#patCatGovEmp").removeAttr("checked");*/
				if (jQuery("#patCatGeneral").is(":checked"))
					jQuery("#patCatGeneral").removeAttr("checked");
				if (jQuery("#patCatStaff").is(":checked"))
					jQuery("#patCatStaff").removeAttr("checked");
				// 11/05/2012: Thai Chuong modified for Solan new categories validation - Bug #188
				if (jQuery("#patCatAntenatal").is(":checked"))
					jQuery("#patCatAntenatal").removeAttr("checked");
				if (jQuery("#patCatChildLessThan1yr").is(":checked"))
					jQuery("#patCatChildLessThan1yr").removeAttr("checked");
				// 17/05/2012: Marta added for Solan new categories validation - Bug #188
				// 26/5/2012 Marta: Changing categories to match with requirements on #240
				// if (jQuery("#patCatSeniorCitizen").is(":checked"))
				//	jQuery("#patCatSeniorCitizen").removeAttr("checked");

			} else {
				jQuery("#freeCategory").val("");
				jQuery("#freeField").hide();
			}
		}

	};
</script>

<!-- ghanshyam 12-sept-2013 New Requirement #2684 Introducing a field at the time of registration to put Aadhar Card Number -->
<script type="text/javascript">
function yesClick(){
if (jQuery("#yes").attr('checked') == true){
jQuery("#aadharCardNo").show();
jQuery("#aadharCardReason").val('');
jQuery("#aadharCardReason").hide();
jQuery("#no").removeAttr("checked");
}
else{
jQuery("#aadharCardNo").val('');
jQuery("#aadharCardNo").hide();
}
}

function noClick(){
if (jQuery("#no").attr('checked') == true){
jQuery("#aadharCardNo").val('');
jQuery("#aadharCardNo").hide();
jQuery("#aadharCardReason").show();
jQuery("#yes").removeAttr("checked");
}
else{
jQuery("#aadharCardReason").val('');
jQuery("#aadharCardReason").hide();
}
}

function disablePatientCategory(){
if (jQuery("#rsby").attr('checked') == true || jQuery("#bpl").attr('checked') == true){
 document.getElementById('patientCategory').disabled=true;
 document.getElementById('freeCategory').style.visibility = "hidden";
}
else{
document.getElementById('patientCategory').disabled=false;
document.getElementById('freeCategory').style.visibility = "hidden";
}
}

function patientCategorySelection(){
var patientCategory = document.getElementById('patientCategory').value;
if(patientCategory=="Other Free"){
document.getElementById('freeCategory').style.visibility = "visible";
}
else{
var fCat = document.getElementById('freeCategory');
fCat.value='';
document.getElementById('freeCategory').style.visibility = "hidden";
}
}

function checkAadharCardNumberr() {
		        aadharCardNo=jQuery("#aadharCardNo").val();
		        if(aadharCardNo.length==11){
		         //alert("yyyyyyyyyyyy"+aadharCardNo);
				jQuery.ajax({
				type : "GET",
				url : getContextPath() + "/module/registration/validateaadharcardnoreg.form",
				data : ({
					aadharCardNo			: aadharCardNo
				}),
				success : function(data) {	
				    jQuery("#validationMessage").html(data);	
					 
		           } 
               });
             }
		  }
</script>


<h2>Patient Registration</h2>
<!-- ghanshyam 07-sept-2013 Support #2686 GUI Changes (spellings/ fonts/ alignments) -->
<b>Visit Information</b> <br />
<div id="patientSearchResult"></div>
<form id="patientRegistrationForm" method="POST">
	<table cellspacing="0">
		<tr>
			<td valign="top" class="cell"><b>Name <label style="color:red">*</label> </b>
			</td>
			<td class="cell"><input id="patientName" type="hidden"
				name="patient.name" />
				<div id="searchbox"></div>
				<div id="numberOfFoundPatients"></div>
			</td>
			<%-- Sagar Bele,Ghanshyam Kumar - 12-12-2012 - Bug #467 [Registration]Duplicate Identifier --%>
			<td class="cell"><b>ID Number<label style="color:red">*</label></b> <input readonly
						name="patient.identifier" style="border: none;" />
			
			</td>

		</tr>
		<tr>
			<td class="cell"><b>Demographics <label style="color:red">*</label></b>
			</td>
			<td class="cell">dd/mm/yyyy<br />
				<table>
					<tr>
						<td>Age</td>
						<!-- ghanshyam 07-sept-2013 Support #2686 GUI Changes (spellings/ fonts/ alignments) -->
						<td id="birthdateh">Birthdate</td>
						<td id="bh"></td>
						<td>Gender</td>
					</tr>
					<tr>
						<td><span id="estimatedAge" />
						</td>
						<td><input type="hidden" id="calendar" /> <input
							id="birthdate" name="patient.birthdate" /> <img
							id="calendarButton"
							src="../../moduleResources/registration/calendar.gif" /> <input
							id="birthdateEstimated" type="hidden"
							name="patient.birthdateEstimate" value="true" />
						</td>
						<td><select id="patientGender" name="patient.gender">
								<option value="Any"></option>
								<option value="M">Male</option>
								<option value="F">Female</option>
								<option value="O">Others</option>
								
						</select>
						</td>
					</tr>
				</table>
			</td>
			<td rowspan="3" class="border">
			<!-- ghanshyam 12-sept-2013 New Requirement #2684 Introducing a field at the time of registration to put Aadhar Card Number -->
			<b>&nbsp;&nbsp;Aadhar Card Number:</b> &nbsp;&nbsp;
			<input type="checkbox" checked="checked" id="yes" name="yes" onClick="yesClick();">Yes &nbsp;&nbsp;
			<input type="checkbox" id="no" name="no" onClick="noClick();">No
			<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input id="aadharCardNo" name="patient.attribute.20" placeholder="Aadhar Card No" onblur="checkAadharCardNumberr();"/>
			<input id="aadharCardReason" name="patient.attribute.21" placeholder="Reason"/> <br /> <br />
			<!-- ghanshyam 07-sept-2013 Support #2686 GUI Changes (spellings/ fonts/ alignments) -->
			<b>&nbsp;&nbsp;Patient Category:</b> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			RSBY <input id="rsby" type="checkbox" name="person.attribute.14" value="RSBY" onClick="disablePatientCategory();"/> &nbsp;&nbsp;
			<span id="rsbyField"><input id="rsbyNumber" name="person.attribute.11" />
			</span>
			<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			BPL&nbsp;&nbsp;<input id="bpl" type="checkbox" name="person.attribute.14" value="BPL" onClick="disablePatientCategory();" /> &nbsp;&nbsp;&nbsp;
			<span id="bplField"><input id="bplNumber" name="person.attribute.10" />
						</span>
			<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<select id="patientCategory" name="person.attribute.14" onChange="patientCategorySelection();">
								<option value="">Select Category</option>
								<option value="General">General</option>
								<option value="Staff">Staff</option>
								<option value="Antenatal">Antenatal Patient</option>
								<option value="Child Less Than 1yr">Child Less Than 1 Year</option>
								<option value="Other Free">Other Free</option>
								
			</select>
			<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input id="freeCategory" name="person.attribute.19" />
			<br />
			<b> <font color="red">Temporary Categories: </font></b>&nbsp;&nbsp;&nbsp;
			<input type="checkbox" name="temporary.attribute.22" value="MLC" />MLC  &nbsp;&nbsp;
			<input type="checkbox" name="temporary.attribute.22" value="Accident" />Accident
			<table cellspacing="10">
				<div id="validationMessage"></div>
			</table></td>
		</tr>

		<tr>
		</tr>

		<tr>
			<td valign="top" class="cell"><b>Address</b>&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td class="cell">
				<table>
					
						<!--  10/05/2012: Thai Chuong, adding a field for address. Feature #211   -->
						<td>Postal Address:</td>
						<td> <!-- <input id="patientPostalAddress" name="person.attribute.18" style="width: 300px;" />  -->
						<!-- 26-6-2012 Marta - to store address in the openmrs patient_address table-->
							<input id="patientPostalAddress" name="patient.address.postalAddress" style="width: 300px;" />
						</td>
					
					<tr>
						<td>District:</td>
						<td><select id="districts" name="patient.address.district"
							onChange="PAGE.changeDistrict();" style="width: 200px;">
						</select>
						</td>
					</tr>
					<tr>
						<td>Tehsil:</td>
						<td><select id="tehsils" name="patient.address.tehsil"
							style="width: 200px;">
						</select>
						</td>
					</tr>
				</table></td>
		</tr>
		<tr>
			<!-- ghanshyam 07-sept-2013 Support #2686 GUI Changes (spellings/ fonts/ alignments) -->
			<td class="cell"><b>Phone Number</b>
			</td>
			<td class="cell"><input id="patientPhoneNumber"
				name="person.attribute.16" style="width: 200px;" />
			</td>
		</tr>
		<tr>
			<td class="cell"><b>Relative Name <label style="color:red">*</label></b>
			</td>
			<td class="cell">
				<div id="patientRelativeNameSection"></div> <input
				id="patientRelativeName" name="person.attribute.8"
				style="width: 200px;" /></td>

			<!-- ghanshyam 07-sept-2013 Support #2686 GUI Changes (spellings/ fonts/ alignments) -->
			<td class="cell"><b>Referral Information </b><input
				type="checkbox" id="referred"
				onClick="PAGE.toogleReferralInfo(this);" name="patient.referred"
				value="referred" /> Referred<br />
				<div id="referralDiv" style="display: none;">
					<table>
						<tr>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Referred
								From</td>
							<td><select id="referralHospitals"
								name="patient.referred.from" style="width: 200px;">
							</select>
							</td>
						</tr>
						<tr>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Referral
								Type</td>
							<td><select id="referralReasons"
								name="patient.referred.reason" style="width: 200px;">
							</select>
							</td>
						</tr>
					</table>
				</div> <b>OPD Room to Visit: <label style="color:red">*</label></b> <select id="opdWard"
				name="patient.opdWard">
			</select>
			</td>


		</tr>
		<tr>
			<td colspan="3" style="padding: 0em 30em 0em 30em;"><input
				type="button" value="Save" onclick="PAGE.submit();" /> <input
				type="button" value="Reset"
				onclick="window.location.href=window.location.href" /></td>
		</tr>
	</table>
</form>

<!-- ghanshyam 07-sept-2013 Support #2686 GUI Changes (spellings/ fonts/ alignments) -->
<font size="3" color="red">Fields marked with * are mandatory!</font>