<style>
	.cell {
		border-top: 1px solid lightgrey;
		padding: 20px;
	}
</style>
<script type="text/javascript">

	jQuery(document).ready(function(){		

		// Fill data into address dropdowns
		PAGE.fillOptions("#districts", {
			data:MODEL.districts
		});		
		PAGE.fillOptions("#tehsils", {
			data:MODEL.tehsils[0].split(',')
		});	
		
		// Set value for patient information
		formValues  = "patient.name==" + MODEL.patientName + "||";
		formValues += "patient.birthdate==" + MODEL.patientBirthdate + "||";
		formValues += "patient.gender==" + MODEL.patientGender + "||";
		formValues += "patient.identifier==" + MODEL.patientIdentifier + "||";
		formValues += "patient.gender==" + MODEL.patientGender[0] + "||";
		formValues += "person.attribute.8==" + MODEL.patientAttributes[8] + "||";	
		formValues += "person.attribute.18==" + MODEL.patientAttributes[18] + "||";	
		formValues += "person.attribute.23==" + MODEL.patientAttributes[23] + "||";	
		if(!StringUtils.isBlank(MODEL.patientAttributes[16])){
			formValues += "person.attribute.16==" + MODEL.patientAttributes[16] + "||";	
		}
		
		jQuery("#patientRegistrationForm").fillForm(formValues);
		PAGE.checkBirthDate();
		VALIDATORS.genderCheck();
		jQuery("#patientRegistrationForm").fillForm("person.attribute.15==" + MODEL.patientAttributes[15] + "||");
		
		// Set value for address
		addressParts = MODEL.patientAddress.split(',');		
		jQuery("#districts").val(StringUtils.trim(addressParts[1]));
		PAGE.changeDistrict();
		jQuery("#tehsils").val(StringUtils.trim(addressParts[0]));
		
		/* Set Value For Attributes */
		// Patient Category
		attributes = MODEL.patientAttributes[14];
		jQuery.each(attributes.split(","), function(index, value){
			jQuery("#patientRegistrationForm").fillForm("person.attribute.14==" + value + "||");
		});
		
		// SSK Number
		if(!StringUtils.isBlank(MODEL.patientAttributes[22])){
			jQuery("#patientRegistrationForm").fillForm("person.attribute.22==" + MODEL.patientAttributes[22] + "||");
		} else {
			jQuery("#patCatSSKField").hide();
		}
		
		// binding
		jQuery('#calendar').datepicker({yearRange:'c-100:c+100', dateFormat: 'dd/mm/yy', changeMonth: true, changeYear: true});	
		jQuery('#birthdate').change(PAGE.checkBirthDate);		
		
		jQuery("#patCatSSK").click(function(){
			VALIDATORS.patCatSSKCheck();
		});		
		jQuery("#patCatGeneral").click(function(){
			VALIDATORS.generalCheck();
		});
		jQuery("#calendarButton").click(function(){
			jQuery("#calendar").datepicker("show");
		});		
		jQuery("#calendar").change(function(){
			jQuery("#birthdate").val(jQuery(this).val());
			PAGE.checkBirthDate();
		});		
		jQuery("#birthdate").click(function(){
			jQuery("#birthdate").select();
		});
		jQuery("#patientGender").change(function(){
			VALIDATORS.genderCheck();
		});
		
	});
	
	/**
	 ** FORM
	 **/
	PAGE = {
		/** SUBMIT */
		submit: function(){						
			
			// Capitalize fullname and relative name
			fullNameInCapital = StringUtils.capitalize(jQuery("#patientName", jQuery("#patientRegistrationForm")).val());
			jQuery("#patientName", jQuery("#patientRegistrationForm")).val(fullNameInCapital);
			relativeNameInCaptital = StringUtils.capitalize(jQuery("#patientRelativeName").val());
			jQuery("#patientRelativeName").val(relativeNameInCaptital);
						
			// Validate and submit
			if(this.validateRegisterForm()){
				jQuery("#patientRegistrationForm").mask("<img src='" + openmrsContextPath + "/moduleResources/hospitalcore/ajax-loader.gif" + "'/>&nbsp;");				
				jQuery("#patientRegistrationForm").ajaxSubmit({
					success: function(responseText, statusText, xhr){
						json = jQuery.parseJSON(responseText);						
						if(json.status=="success"){
							window.location.href = openmrsContextPath + "/findPatient.htm";
						} else {							
							alert(json.message);
						}
						jQuery("#patientRegistrationForm").unmask();
					}
				});
			}
		},
		
		/** VALIDATE BIRTHDATE */
		checkBirthDate: function() {
			jQuery.ajax({
				type : "GET",
				url : getContextPath() + "/module/registration/ajax/processPatientBirthDate.htm",
				data : ({
					birthdate: $("#birthdate").val()
				}),
				dataType: "json",
				success : function(json) {
					
					if(json.error==undefined){
						if(json.estimated == "true"){
							jQuery("#birthdateEstimated").val("true")
						} else {						
							jQuery("#birthdateEstimated").val("false");
						}
						
						jQuery("#estimatedAge").html(json.age);
						jQuery("#birthdate").val(json.birthdate);
					} else {
						alert(json.error);}
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
		fillOptions: function(divId, option) {			
			jQuery(divId).empty();
			if(option.delimiter == undefined){				
				if(option.index == undefined){
					jQuery.each(option.data, function(index, value){	
						if(value.length>0){
							jQuery(divId).append("<option value='" + value + "'>" + value + "</option>");
						}
					});				
				} else {
					jQuery.each(option.data, function(index, value){	
						if(value.length>0){
							jQuery(divId).append("<option value='" + option.index[index] + "'>" + value + "</option>");
						}
					});
				}
			} else {
				
				options = option.data.split(option.optionDelimiter);
				jQuery.each(options, function(index, value){
					
					values = value.split(option.delimiter);
					optionValue = values[0];
					optionLabel = values[1];
					if(optionLabel != undefined){
						if(optionLabel.length>0){
							jQuery(divId).append("<option value='" + optionValue + "'>" + optionLabel + "</option>");
						}
					}
					
				});
			}
		},
		
		/** CHANGE DISTRICT */
		changeDistrict: function() {		

			// get the list of tehsils
			tehsilList = "";
			selectedDistrict = jQuery("#districts option:checked").val();
			jQuery.each(MODEL.districts, function(index, value){
				if(value == selectedDistrict){
					tehsilList = MODEL.tehsils[index];					
				}
			});
			
			// fill tehsils into tehsil dropdown
			this.fillOptions("#tehsils", {
				data: tehsilList.split(",")
			});
		},
		
		/** VALIDATE FORM */
		validateRegisterForm: function(){			
		
			if(StringUtils.isBlank(jQuery("#patientName").val())){
				alert("Please enter patient name");
				return false;
			}			
			
			if(StringUtils.isBlank(jQuery("#patientRelativeName").val())){
				alert("Please enter relative name");
				return false;
			} else {
				if(jQuery("#patientRegistrationForm input[name=person.attribute.15]:checked").length==0){
					alert("Please select relative name type");
					return false;
				}
			}

			if(StringUtils.isBlank(jQuery("#birthdate").val())){
				alert("Please enter birthdate or age");
				return false;
			}
			
			if(jQuery("#patientGender").val()=="Any"){
				alert("Please select gender");
				return false;
			}
			
			if(!VALIDATORS.validatePatientCategory()){
				return false;
			}
			
			if(!StringUtils.isBlank(jQuery("#patientPhoneNumber").val())){
				if(!StringUtils.isDigit(jQuery("#patientPhoneNumber").val())){
					alert("Please enter phone number in correct format");
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
	
		/** VALIDATE PATIENT CATEGORY */
	    validatePatientCategory: function () {
	        if (jQuery("#patCatGeneral").attr('checked') == false 
			 && jQuery("#patCatSSK").attr('checked') == false) {
	            alert('You didn\'t choose any of the patient category!');
	            return false;
	        } else {
	            if (jQuery("#patCatSSK").attr('checked')) {
	                if (jQuery("#patCatSSKNumber").val().length <= 0) {
	                    alert('Please enter SSK number');
	                    return false;
	                }
	            }
	            return true;
	        }
	    },
	
		/** CHECK WHEN SSK CATEGORY IS SELECTED */
		patCatSSKCheck: function () {			
	        if (jQuery("#patCatSSK").is(':checked')) {
	            jQuery("#patCatSSKField").show();
	        } else {
	            jQuery("#patCatSSKNumber").val("");
	            jQuery("#patCatSSKField").hide();
	        }
	    },
		
		/** CHECK WHEN GENERAL CATEGORY IS SELECTED */
	    generalCheck: function (obj) {
	        if (jQuery("#patCatGeneral").is(':checked')) {
					jQuery("#patCatSSKNumber").val("");
					jQuery("#patCatSSKField").hide();
	        }
	    },
		
		/*
		 * Check patient gender
		 */
		 genderCheck: function() {
			
			jQuery("#patientRelativeNameSection").empty();			
			if(jQuery("#patientGender").val()=="M"){
				jQuery("#patientRelativeNameSection").html('<input type="radio" name="person.attribute.15" value="Son of" checked="checked"/> Son of');
			} else {
				jQuery("#patientRelativeNameSection").html('<input type="radio" name="person.attribute.15" value="Daughter of"/> Daughter of <input type="radio" name="person.attribute.15" value="Wife of"/> Wife of');
			}
			
		}
	};
</script>

<h2>Patient Registration</h2>
<div id="patientSearchResult"></div>
<form id="patientRegistrationForm" method="POST">
	<table cellspacing="0">
		<tr>
			<td valign="top" class="cell"><b>Name *</b></td>
			<td class="cell">
				<input id="patientName" name="patient.name" style="width:300px;"/>				
			</td>
		</tr>		
		<tr>
			<td class="cell"><b>Demographics *</b></td>
			<td class="cell">
				dd/mm/yyyy<br/>
				<table>
					<tr>
						<td>Age</td>
						<td>Birthdate</td>
						<td>Gender</td>
					</tr>
					<tr>
						<td>
							<span id="estimatedAge"/>
						</td>
						<td>
							<input type="hidden" id="calendar"/>
							<input id="birthdate" name="patient.birthdate"/>
							<img id="calendarButton" src="../../moduleResources/registration/calendar.gif"/>
							<input id="birthdateEstimated" type="hidden" name="patient.birthdateEstimate" value="true"/>
						</td>
						<td>
							<select id="patientGender" name="patient.gender">
								<option value="Any"></option>
								<option value="M">Male</option>
								<option value="F">Female</option>
							</select>
						</td>
					</tr>
				</table>
			</td>
		</tr>		
		<tr>
			<td class="cell"><b>ID Number *</b></td>
			<td class="cell"><input name="patient.identifier" style="border: none;"/></td>
		</tr>
		<tr>
			<td class="cell"><b>NID/PID</b></td>
			<td class="cell"><input name="person.attribute.23" style="border: none;"/></td>
		</tr>
		<tr>
			<td class="cell"><b>Address</b></td>
			<td class="cell">
				<table>
					<tr>
						<td>District:</td>
						<td>
							<select id="districts" name="patient.address.district" onChange="PAGE.changeDistrict();" style="width:200px;">
							</select>
						</td>
					</tr>
					<tr>
						<td>Upazila:</td>
						<td>
							<select id="tehsils" name="patient.address.tehsil" style="width:200px;">
							</select>
						</td>
					</tr>					
					<tr>
						<td>Street:</td>
						<td><input id="street"
							name="person.attribute.18" style="width: 500px;" /></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td class="cell"><b>Phone number</b></td>
			<td class="cell">
				<input id="patientPhoneNumber" name="person.attribute.16" style="width:200px;"/>
			</td>
		</tr>
		<tr>
			<td class="cell"><b>Head of Family *</b></td>
			<td class="cell">
				<div id="patientRelativeNameSection">
					
				</div>
				<input id="patientRelativeName" name="person.attribute.8" style="width:200px;"/>
			</td>
		</tr>		
		<tr>
			<td valign="top" class="cell"><b>Patient information</b></td>
			<td class="cell">
				<b>Patient category</b><br/>
				<table cellspacing="10">
					<tr>
						<td>
							<input id="patCatGeneral" type="radio" name="person.attribute.14" value="General"/> General 
						</td>
						<td></td>
					</tr>
					<tr>
						<td>
							<input id="patCatSSK" type="radio" name="person.attribute.14" value="SSK"/> SSK 
						</td>
						<td>
							<span id="patCatSSKField">SSK Number <input id="patCatSSKNumber" name="person.attribute.22"/></span>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>

<input type="button" value="Save" onclick="PAGE.submit();"/>
<input type="button" value="Reset" onclick="window.location.href=window.location.href"/>