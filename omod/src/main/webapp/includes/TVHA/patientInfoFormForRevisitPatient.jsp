<script type="text/javascript">
	jQuery(document).ready(function(){		
		jQuery("#patientId").val(MODEL.patientId);
		jQuery("#revisit").val(MODEL.revisit);
		jQuery("#identifier").html(MODEL.patientIdentifier);
		jQuery("#identifierr").html(MODEL.patientIdentifier);
		jQuery("#age").html(MODEL.patientAge);
		jQuery("#agee").html(MODEL.patientAge);
		jQuery("#name").html(MODEL.patientName);
		jQuery("#namee").html(MODEL.patientName);
		jQuery("#patientInfoPrintAreaa").hide();
		jQuery("#mlc").hide();
		jQuery("#paidCategoryField").hide();
        jQuery("#programField").hide();
		
		jQuery("#paidCategoryChecked").click(function() {
		VALIDATORS.payingCheck();
		});
		jQuery("#programChecked").click(function() {
		VALIDATORS.programCheck();
		});
		jQuery("#temporaryCategoryCheckBox").click(function() {
		VALIDATORS.temporaryCategory();
		});
		
		jQuery("#phoneNumber").html(MODEL.patientAttributes[16]);
		jQuery("#gender").html(MODEL.patientGender);
		jQuery("#genderr").html(MODEL.patientGender);
		jQuery("#datetime").html(MODEL.currentDateTime);
		jQuery("#datetimee").html(MODEL.currentDateTime);
		//ghanshyam 12-sept-2013 New Requirement #2684 Introducing a field at the time of registration to put Aadhar Card Number
		if (!StringUtils.isBlank(MODEL.patientAttributes[20])){
		jQuery("#aadharCardNo").html(MODEL.patientAttributes[20]);
		jQuery("#aadharCardNoo").html(MODEL.patientAttributes[20]);
		}
		else{
		jQuery("#aadharCardRow").hide();
		}
		MODEL.OPDs = " ,Please select an OPD room to visit|" + MODEL.OPDs;
		PAGE.fillOptions("#opdWard", {
			data:MODEL.OPDs,
			delimiter: ",",
			optionDelimiter: "|"
		});
		
		MODEL.TEMPORARYCATEGORY = " ,select temporary category|"
						+ MODEL.TEMPORARYCATEGORY;
				PAGE.fillOptions("#mlc", {
					data : MODEL.TEMPORARYCATEGORY,
					delimiter : ",",
					optionDelimiter : "|"
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
		
		jQuery("#buySlip").hide();
		
		// Set data for reprint page
		if(MODEL.reprint=="true"){
			jQuery("#printSlip").hide();
			jQuery("#save").hide();
			var tempCategoryId=MODEL.tempCategoryId;
		    if(!StringUtils.isBlank(MODEL.tempCategoryId)){
		    jQuery("#temporaryCategories").html(MODEL.tempCategoryConceptName);
		    }
			else{
			jQuery("#tempCat1").hide();
			jQuery("#tempCat2").hide();
			}
		} else {
			jQuery("#reprint").hide();
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
				jQuery("#opdWardd").after("<span>" + jQuery("#opdWard option:checked").html() +  "</span>");
			
				jQuery("#regFee").after("<span>" + jQuery("#regFee option:checked").html() +  "</span>");
				jQuery("#registrationFee").after("<span>" + jQuery("#regFee option:checked").html() +  "</span>");	
				
				// Convert temporary category dropdown to printable format
				if(jQuery("#temporaryCategoryCheckBox").is(':checked')){
				var temporaryCategory=jQuery("#mlc option:checked").html();	
				jQuery("#printableTemporaryCategories").append("<span style='margin:5px;'>" + temporaryCategory + "</span>");
				}
				jQuery("#temporaryCategories").hide();
				
				if(jQuery("#paidCategoryChecked").is(':checked')){
				var paidCategory=jQuery("#paidCategory option:checked").html();	
				jQuery("#printablePatientCategory").append("<span style='margin:5px;'>" + paidCategory + "</span>");
				}
				else if(jQuery("#programChecked").is(':checked')){
				var program=jQuery("#program option:checked").html();	
				jQuery("#printablePatientCategory").append("<span style='margin:5px;'>" + program + "</span>");
				}
				jQuery("#patCat1").hide();
				jQuery("#patCat2").hide();
				
				jQuery("#regFeeRow").hide();
				
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
			jQuery("#patientInfoPrintAreaa").printArea({
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
			
			if (jQuery("#temporaryCategoryCheckBox").is(':checked')) {
		    if (StringUtils.isBlank(jQuery("#mlc").val())) {
		    alert("please select Temporary Category");
		    return false;
		    }
			}
			
			if(StringUtils.isBlank(jQuery("#opdWard").val())){
				alert("Please select OPD ward");
				return false;
			};
		
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
					//jQuery("#nonPayingCategory").val("");
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
		
		temporaryCategory : function() {
		if (jQuery("#temporaryCategoryCheckBox").is(':checked')) {
				jQuery("#mlc").show();
		}
		else{
		jQuery("#mlc").hide();
		 }
		}
	};
</script>
<input id="printSlip" type="button" value="Print"
	onClick="PAGE.submit(false);" />
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
				<img type="image" src="../../moduleResources/registration/Logo_Tibet.jpg"/>
				<h2>${hospitalName}</h2>
				<h2>Registration Receipt</h2>
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
				<td colspan="1" rowspan="1"><b>Patient Category:</b></td>     
				<td colspan="5">
				<table>
				<tr>
				<td>
				<input id="paidCategoryChecked" type="checkbox" name="paidCategoryChecked"/> Paid Category&nbsp;&nbsp;
				</td>
				<td id="paidCategoryField"><select id="paidCategory" name="patient.paidCategory" style="width: 130px;">
						</select></td>		
				</tr>
				</table>
				</td>
				</tr>
				
				<tr id="patCat2">
				<td colspan="1" rowspan="1"></td>     
				<td colspan="5">
				<table>
				<tr>
				<td>
				<input id="programChecked" type="checkbox" name="programChecked"/> Programs&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				</td>
				<td id="programField"><select id="program" name="patient.program" style="width: 130px;">
						</select></td>		
				</tr>
				</table>
				</td>
				</tr>
				
				<tr id="regFeeRow">
				<td><b>Registration Fee <label style="color:red">*</label></b>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><select id="regFee" name="person.attribute.28" style='width: 130px;'>
					</select></td>
		    </tr>
				
				<tr id="temporaryCategories">
					<td colspan="1"><b>Temporary Categories:</b></td>
					<td colspan="5">
						<table>
							<tr>
								<td>
									<input type="checkbox" id="temporaryCategoryCheckBox" name="temporaryCategoryCheckBox" value="MLC" /> MLC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	
								</td>
								<td><select id="mlc" name="patient.mlc" style="width: 130px;"></select></td>			
							</tr>
						</table>
					</td>	
				</tr>
			</table>
		</form>
	</center>
</div>

<div id="patientInfoPrintAreaa">
<center>
<table border=0 width="710" style="font-size: 14px;">
                <img type="image" src="../../moduleResources/registration/Logo_Tibet.jpg"/>
                <h2>${hospitalName}</h2>
				<h2>Registration Receipt</h2>
				<tr>
					<td colspan="1"><b>Day of Visit:</b></td>
					<td colspan="2"><span id="datetimee" /></td>
				</tr>
				<tr>
					<td colspan="1"><b>Patient Name:</b></td>
					<td colspan="2"><span id="namee" /></td>
				</tr>
				<tr>
					<td colspan="1""><b>Patient ID:</b></td>
					<td colspan="2""><span id="identifierr" /></td>
				</tr>
				<tr>
					<td colspan="1"><b>Age:</b></td>
					<td colspan="2"><span id="agee" /></td>
				</tr>
				<tr>
					<td colspan="1"><b>Gender:</b></td>
					<td colspan="2"><span id="genderr" /></td>
				</tr>
				<tr>
					<td colspan="1"><b>Patient Category:</b></td>
					<td colspan="2"><span id="printablePatientCategory" /></td>
				</tr>
				<tr>
					<td colspan="1" id="tempCat1"><b>Temp Categ:</b></td>
					<td colspan="2" id="tempCat2"><span id="printableTemporaryCategories"></span></td>
				</tr>
				<tr>
					<td colspan="1"><b>Room to Visit:</b></td>
					<td colspan="3"><span id="opdWardd"></span>
					</td>
				</tr>
				<tr>
					<td colspan="1"><b>Registration Fee:</b></td>
					<td colspan="2"><span id="registrationFee"></span></td>
				</tr>
				<tr>
					<td colspan="1"><b>You were served by:</b></td>
					<td colspan="2">${userName}</td>
				</tr>
</table>
</center>
</div>
