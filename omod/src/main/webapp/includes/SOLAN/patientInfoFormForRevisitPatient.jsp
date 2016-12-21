<script type="text/javascript">
	jQuery(document).ready(function(){		
		jQuery("#patientId").val(MODEL.patientId);
		jQuery("#revisit").val(MODEL.revisit);
		jQuery("#identifier").html(MODEL.patientIdentifier);
		jQuery("#age").html(MODEL.patientAge);
		jQuery("#name").html(MODEL.patientName);
		
		jQuery("#rsbyNumber").hide();
		jQuery("#bplNumber").hide();
		document.getElementById("freeCategory").style.visibility = "hidden";
		document.getElementById("patCat").style.visibility = "hidden";
		document.getElementById("patCatt").style.visibility = "hidden";
		
		jQuery("#bpl").click(function() {
		VALIDATORS.bplCheck();
		});
		jQuery("#rsby").click(function() {
		VALIDATORS.rsbyCheck();
		});
		
		PAGE.fillOptions("#freeCategory", {
					data : MODEL.OTHERFREE,
					delimiter : ",",
					optionDelimiter : "|"
				});
	    jQuery("#person.attribute.19").val(MODEL.selectedOtherFree);
		
		// 11/06/12: Kesavulu: added BPL/RSBY number on registration slip Bug #208
		if(MODEL.patientAttributes[14]){
			pattern = /[A-Z]+[,][A-Z]/;
			if(pattern.test(MODEL.patientAttributes[14])){

				jQuery("#BPL").html("BPL No.: " + MODEL.patientAttributes[10]);
				jQuery("#RSBY").html("RSBY No.: " + MODEL.patientAttributes[11]);


			}else{			
				if("BPL" == MODEL.patientAttributes[14])
					jQuery("#BPL").html(MODEL.patientAttributes[10]);

				if("RSBY" == MODEL.patientAttributes[14])
					jQuery("#RSBY").html(MODEL.patientAttributes[11]);
			}					
		}
		        attributes = MODEL.patientAttributes[14];
				jQuery.each(attributes.split(","), function(index, value) {
					jQuery("#patientInfoForm").fillForm(
							"person.attribute.14==" + value + "||");
				});
		         // RSBY Number
				if (!StringUtils.isBlank(MODEL.patientAttributes[11])
						&& jQuery("#rsby").attr('checked')) {
					jQuery("#patientInfoForm").fillForm(
							"person.attribute.11=="
									+ MODEL.patientAttributes[11] + "||");
					document.getElementById('patientCategory').disabled=true;
					jQuery("#rsbyNumber").show();
				} else {
					jQuery("#rsbyNumber").hide();
				}

				// BPL Number
				if (!StringUtils.isBlank(MODEL.patientAttributes[10])
						&& jQuery("#bpl").attr('checked')) {
					jQuery("#patientInfoForm").fillForm(
							"person.attribute.10=="
									+ MODEL.patientAttributes[10] + "||");
					document.getElementById('patientCategory').disabled=true;
					jQuery("#bplNumber").show();
				} else {
					jQuery("#bplNumber").hide();
				}
		
				if (MODEL.patientAttributes[14]=='General' || MODEL.patientAttributes[14]=='Staff' || MODEL.patientAttributes[14]=='Antenatal' ||
				MODEL.patientAttributes[14]=='Child Less Than 1yr'){
				document.getElementById('patientCategory').value=MODEL.patientAttributes[14];
				}
				else if(MODEL.patientAttributes[14]=='Other Free'){
				document.getElementById('patientCategory').value=MODEL.patientAttributes[14];
				document.getElementById('freeCategory').value=MODEL.patientAttributes[19];
				document.getElementById("freeCategory").style.visibility = "visible";
				}

		jQuery("#phoneNumber").html(MODEL.patientAttributes[16]);
		jQuery("#gender").html(MODEL.patientGender);
		jQuery("#datetime").html(MODEL.currentDateTime);
		//ghanshyam 12-sept-2013 New Requirement #2684 Introducing a field at the time of registration to put Aadhar Card Number
		jQuery("#aadharCardNo").html(MODEL.patientAttributes[20]);
		MODEL.OPDs = " ,Please select an OPD room to visit|" + MODEL.OPDs;
		PAGE.fillOptions("#opdWard", {
			data:MODEL.OPDs,
			delimiter: ",",
			optionDelimiter: "|"
		});
		
		// Set the selected OPD
		if(!StringUtils.isBlank(MODEL.selectedOPD)){			
			jQuery("#opdWard").val(MODEL.selectedOPD);
			jQuery("#opdWard").attr("disabled", "disabled");
		}
		
		jQuery("#buySlip").hide();
		
		// Set data for reprint page
		if(MODEL.reprint=="true"){
			var opdWardId=MODEL.opdWardId;
		jQuery("#opdWard").val(MODEL.observations[opdWardId]);
			// 26/05/12: Marta, avoid error from empty string. Bug #219
			
			//ghanshyam 15-may-2013 Bug #1614 Reprint Slip: Solan, DDU, Mandi
			jQuery("#opdWard").attr("disabled", "disabled");
			jQuery("input[name='temporary.attribute.22']").attr("disabled", "disabled");
		
			jQuery("#temporaryCategories").html(MODEL.patientAttributes[22]);
			jQuery("#printSlip").hide();
			jQuery("#save").hide();
			// Sagar Bele : Date: 23-1-2013 : Issue #791
			jQuery("#tempCat").hide();
		} else {
			jQuery("#reprint").hide();
			jQuery("#tempCat").hide();
		}
		
		/*
		if(MODEL.dueDate.length>0){
			jQuery("#buySlip").hide();
			
			value = "Validate until " + MODEL.dueDate;
			if(parseInt(MODEL.daysLeft)>1){
				value += " (" + MODEL.daysLeft + " days left).";				
			} else {
				value += " (1 day left).";
			}
			jQuery("#validationDate").html(value);
				
		} else {
			jQuery("#printSlip").hide();
		}	
		*/
		
	});
	
	/**
	 ** PAGE METHODS
	 **/
	PAGE = {
		/** Validate and submit */
		submit: function(reprint){
		
			if(PAGE.validate()){
				
				// Hide print button
				jQuery("#printSlip").hide();
				jQuery("#reprint").hide();
				
				// Convert OPDWard dropdown to printable format
				jQuery("#opdWard").hide();
				jQuery("#opdWard").after("<span>" + jQuery("#opdWard option:checked").html() +  "</span>");		
				
				if (jQuery("#rsby").is(':checked') && jQuery("#bpl").is(':checked')) {
				var rsbyNo=document.getElementById('rsbyNumber').value;
				var bplNo=document.getElementById('bplNumber').value;
				var rsby="RSBY"+" "+rsbyNo;
				var bpl="BPL"+" "+bplNo;
				jQuery("#printablePatientCategory").append("<span style='margin:5px;'>" + rsby + "</span>");
				jQuery("#printablePatientCategoryy").append("<span style='margin:5px;'>" + bpl + "</span>");
				jQuery("#patCat").show();
				jQuery("#patCatt").show();
				document.getElementById("patCat").style.visibility = "visible";
				document.getElementById("patCatt").style.visibility = "visible";
				}
				else if(jQuery("#rsby").is(':checked')){
				var rsbyNo=document.getElementById('rsbyNumber').value;
				var rsby="RSBY"+" "+rsbyNo;
				jQuery("#printablePatientCategory").append("<span style='margin:5px;'>" + rsby + "</span>");
				document.getElementById("patCat").style.visibility = "visible";
				}
				else if(jQuery("#bpl").is(':checked')){
				var bplNo=document.getElementById('bplNumber').value;
				var bpl="BPL"+" "+bplNo;
				jQuery("#printablePatientCategory").append("<span style='margin:5px;'>" + bpl + "</span>");
				document.getElementById("patCat").style.visibility = "visible";
				}
				else{
				var patientCategory=document.getElementById('patientCategory');
				var patientCategoryValue = patientCategory.options[patientCategory.selectedIndex].value;
				if(patientCategoryValue!="Other Free"){
				jQuery("#printablePatientCategory").append("<span style='margin:5px;'>" + patientCategoryValue + "</span>");
				}
				else{
				var freeCategory=jQuery("#freeCategory option:selected").text();
				jQuery("#printablePatientCategory").append("<span style='margin:5px;'>" + patientCategoryValue + "</span>");
				jQuery("#printablePatientCategoryy").append("<span style='margin:5px;'>" + freeCategory + "</span>");
				document.getElementById("patCatt").style.visibility = "visible";
				}
				document.getElementById("patCat").style.visibility = "visible";
				}
				
				jQuery("#patCat1").hide();
				jQuery("#patCat2").hide();
				jQuery("#patCat3").hide();
				jQuery("#patCat4").hide();

				// Convert temporary categories to printable format
				jQuery("#temporaryCategories input").each(function(index, value){				
					if(jQuery(value).is(":checked")){
						jQuery("#printableTemporaryCategories").append("<span style='margin:5px;'>" + jQuery(value).val() + "</span>");
						// Sagar Bele : Date 23-1-2013 Issue 792
						jQuery("#tempCat").show();
					}
				});
					
				jQuery("#temporaryCategories").hide();
				
				// submit form and print		
				if(!reprint){
					jQuery("#patientInfoForm").ajaxSubmit({
						success: function (responseText, statusText, xhr){
							if(responseText=="success"){						
								PAGE.print();
								window.location.href = getContextPath() + "/findPatient.htm";
							}					
						}
					});
				} else {
					PAGE.print();
					// 26/5/2012 Marta - Redirecting to registration screen after reprinting #220
					window.location.href = getContextPath() + "/findPatient.htm";
				}
				
			}
		},
		
		// Print the slip
		print: function(){
			jQuery("#patientInfoPrintArea").printArea({
				mode : "popup",
				popClose : true
			});
		},
		
		// harsh #244 Added a save button.
		save: function(){
			if (PAGE.validate()){
			<%-- ghanshyam 13-sept-2012 Bug #359 [REGISTRATION] Duplication of revisit patients when saving.Duplication of data being happen in "encounter" table 
                 and "opd_patient_queue" table --%>	
			var save=document.getElementById("save");
			if(save==save){
			document.getElementById("save").disabled = true;
			}
			jQuery("#patientInfoForm").ajaxSubmit({
				success: function (responseText, statusText, xhr){
					if(responseText=="success"){						
					
						window.location.href = getContextPath() + "/findPatient.htm";
					}					
				}
			});
			}
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
		
		/** Buy A New Slip */		
		buySlip: function(){
			jQuery.ajax({
				type : "GET",
				url : openmrsContextPath + "/module/registration/ajax/buySlip.htm",
				data : ({
					patientId: MODEL.patientId
				}),				
				success : function(data) {										
					window.location.href = window.location.href;
				},
				error : function(xhr, ajaxOptions, thrownError) {
					alert(thrownError);
				}
			});
		},
		
		/** Validate Form */
		validate: function(){
			if(StringUtils.isBlank(jQuery("#opdWard").val())){
				alert("Please select OPD ward");
				return false;
			};
			
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
				
				if (jQuery("#patCatOtherFree").attr('checked')) {
					if (jQuery("#freeCategory").val().length <= 0) {
						alert('Please enter Other Free Category Description');
						return false;
					}
				}
				return true;
			}
		
			return true;
		}
	};
	

/**
	 ** VALIDATORS
	 **/
	VALIDATORS = {
	
/** CHECK WHEN BPL CATEGORY IS SELECTED */
		bplCheck : function() {
			if (jQuery("#bpl").is(':checked')) {
				jQuery("#bplNumber").show();
				if (jQuery("#patCatGeneral").is(":checked"))
					jQuery("#patCatGeneral").removeAttr("checked");
				if (jQuery("#patCatStaff").is(":checked")) {
					jQuery("#patCatStaff").removeAttr("checked");
				}
				
				if (jQuery("#patCatAntenatal").is(":checked"))
					jQuery("#patCatAntenatal").removeAttr("checked");
				if (jQuery("#patCatChildLessThan1yr").is(":checked"))
					jQuery("#patCatChildLessThan1yr").removeAttr("checked");
				
				if (jQuery("#patCatOtherFree").is(":checked")) {
					jQuery("#patCatOtherFree").removeAttr("checked");
					jQuery("#freeCategory").val("");
					jQuery("#freeField").hide();
				}
			} else {
				jQuery("#bplNumber").val("");
				jQuery("#bplNumber").hide();
			}
		},

		/** CHECK WHEN RSBY CATEGORY IS SELECTED */
		rsbyCheck : function() {
			if (jQuery("#rsby").is(':checked')) {
				jQuery("#rsbyNumber").show();
				if (jQuery("#patCatGeneral").is(":checked"))
					jQuery("#patCatGeneral").removeAttr("checked");
				if (jQuery("#patCatStaff").is(":checked")) {
					jQuery("#patCatStaff").removeAttr("checked");
				}
			
				if (jQuery("#patCatAntenatal").is(":checked"))
					jQuery("#patCatAntenatal").removeAttr("checked");
				if (jQuery("#patCatChildLessThan1yr").is(":checked"))
					jQuery("#patCatChildLessThan1yr").removeAttr("checked");
				
				if (jQuery("#patCatOtherFree").is(":checked")) {
					jQuery("#patCatOtherFree").removeAttr("checked");
					jQuery("#freeCategory").val("");
					jQuery("#freeField").hide();
				}
			} else {
				jQuery("#rsbyNumber").val("");
				jQuery("#rsbyNumber").hide();
			}
		}
	};

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
</script>
<input id="printSlip" type="button" value="Print"
	onClick="PAGE.submit(false);" /> <!-- Sept 22,2012 -- Sagar Bele -- Issue 387 --Change case of word Reprint-->
<input id="reprint" type="button" value="Reprint"
	onClick="PAGE.submit(true);" />
<!--
<input id="buySlip" type="button" value="Buy a new slip"
	onClick="PAGE.buySlip();" />
<input id="save" type="button" value="Save" 
	onClick="PAGE.save();" />
-->
<span id="validationDate"></span>
<div id="patientInfoPrintArea">
	<center>
		<form id="patientInfoForm" method="POST">
			<table border=0 width="600">
				<tr>

				</tr>
				<tr>
					<td colspan="1""><b>ID.No:</b></td>
					<td colspan="5""><span id="identifier" /></td>
				</tr>
				<tr>
					<td colspan="1"><b>Name:</b></td>
					<td colspan="5"><span id="name" /></td>
				</tr>
				<tr>
					<td colspan="1"><b>Age:</b></td>
					<td colspan="5"><span id="age" /></td>
				</tr>
				<tr>
					<td colspan="1"><b>Gender:</b></td>
					<td colspan="5"><span id="gender" /></td>
				</tr>
				<tr>
					<td colspan="1" valign="top"><b>Phone number:</b></td>
					<td colspan="5"><span id="phoneNumber" /></td>
				</tr>
				<!-- 03/05/2012 Thai Chuong: Supported issue #182 -->
				<tr id="opdWardLabel">
					<td colspan="1"><b>OPD room to visit:</b></td>
					<td colspan="5"><select id="opdWard" name="patient.opdWard">
					</select></td>
				</tr>
				<tr>
					<td colspan="1"><b>Date/Time:</b></td>
					<td colspan="5"><span id="datetime" /></td>
				</tr>
				<tr>
					<td colspan="1"><b>Aadhar Card Number:</b></td>
					<td colspan="2"><span id="aadharCardNo"></span></td>
				</tr>
				<tr id="patCat1">
					<td colspan="1"><b>Patient Category:</b></td>
					<td colspan="2">RSBY&nbsp;&nbsp;<input id="rsby" type="checkbox" name="person.attribute.14" value="RSBY" onClick="disablePatientCategory();"/></td>
					<td colspan="3"><input id="rsbyNumber" name="person.attribute.11" /></td>
				</tr>
				<tr id="patCat2">
					<td colspan="1"></td>
					<td colspan="2">BPL&nbsp;&nbsp;&nbsp;<input id="bpl" type="checkbox" name="person.attribute.14" value="BPL" onClick="disablePatientCategory();" /></td>
					<td colspan="3"><input id="bplNumber" name="person.attribute.10" /></td>
				</tr>
				<tr id="patCat3">
					<td colspan="1"></td>
					<td colspan="2"><select id="patientCategory" name="person.attribute.14" onChange="patientCategorySelection();">
								<option value="">Select Category</option>
								<option value="General">General</option>
								<option value="Staff">Staff</option>
								<option value="Antenatal">Antenatal Patient</option>
								<option value="Child Less Than 1yr">Child Less Than 1 Year</option>
								<option value="Other Free">Other Free</option>
								</select>
					</td>
					<td colspan="3"></td>
				</tr>
				<tr id="patCat4">
					<td colspan="1"></td>
					<td colspan="2"><select id="freeCategory" name="person.attribute.19" style="width: 185px;"></select></td>
					<td colspan="3"></td>
				</tr>
				<tr id="temporaryCategories">
					<!-- 01/05/12: Marta, Painting Temporary Category in red. Bug #182  -->
					<td colspan="1" valign="top"><b> <font color="red">Temporary
								Categories: </font></b></td>
					<td colspan="5">
						<!-- 28/04/12: Changed MODEL.observations[11] for MODEL.observations[8058] by Marta - Bug #160 -->
						<input type="checkbox" name="temporary.attribute.22" value="MLC" />MLC <br /> <input type="checkbox" name="temporary.attribute.22"
						value="Accident" />Accident <br />
					</td>
				</tr>
			    <tr id="patCat">
					<td colspan="1" valign="top"><b>Patient Category:</b></td>
					<td colspan="5">
						<div id="printablePatientCategory"></div>
					</td>
				</tr>
				<tr id="patCatt">
					<td colspan="1" valign="top"></td>
					<td colspan="5">
						<div id="printablePatientCategoryy"></div>
					</td>
				</tr>
				<tr id="tempCat">
					<td colspan="1" valign="top"><b>Temporary Categories:</b></td>
					<td colspan="5">
						<div id="printableTemporaryCategories"></div>
					</td>
				</tr>
			</table>
		</form>
	</center>
</div>
