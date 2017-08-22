<script type="text/javascript">
	jQuery(document).ready(function(){		
		jQuery("#patientId").val(MODEL.patientId);
		jQuery("#revisit").val(MODEL.revisit);
		jQuery("#identifier").html(MODEL.patientIdentifier);
		jQuery("#age").html(MODEL.patientAge);
		jQuery("#name").html(MODEL.patientName);
		jQuery("#phoneNumber").html(MODEL.patientAttributes[16]);
		jQuery("#gender").html(MODEL.patientGender);
		jQuery("#datetime").html(MODEL.currentDateTime);
		//ghanshyam 12-sept-2013 New Requirement #2684 Introducing a field at the time of registration to put Aadhar Card Number
		if (!StringUtils.isBlank(MODEL.patientAttributes[20])){
		jQuery("#aadharCardNo").html(MODEL.patientAttributes[20]);
		}
		else{
		jQuery("#aadharCardRow").hide();
		}
		if(MODEL.paidCategoryMap[MODEL.patientAttributes[14]]!=undefined){
		jQuery("#category").html(MODEL.paidCategoryMap[MODEL.patientAttributes[14]]);
		}
		else{
		jQuery("#category").html(MODEL.programMap[MODEL.patientAttributes[14]]);
		}
		
		if(!StringUtils.isBlank(MODEL.selectedTemporaryCategory)){
		jQuery("#temporaryCategories").html(MODEL.selectedTemporaryCategory);
		}
		
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
			
			//ghanshyam 15-may-2013 Bug #1614 Reprint Slip: Solan, DDU, Mandi
			jQuery("#opdWard").attr("disabled", "disabled");
			
			var tempCategoryId=MODEL.tempCategoryId;
		    if(!StringUtils.isBlank(MODEL.tempCategoryId)){
		    jQuery("#temporaryCategories").html(MODEL.tempCategoryConceptName);
		    }
		    else{
			jQuery("#tempCat1").hide();
			jQuery("#tempCat2").hide();
			}
				
			jQuery("#printSlip").hide();
			jQuery("#save").hide();
		} else {
			jQuery("#reprint").hide();
			if(!StringUtils.isBlank(MODEL.selectedTemporaryCategory)){
		    jQuery("#temporaryCategories").html(MODEL.selectedTemporaryCategory);
		    }
		    else{
			jQuery("#tempCat1").hide();
			jQuery("#tempCat2").hide();
			}
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
			return true;
		}
	};
</script>
<input id="printSlip" type="button" value="Print"
	onClick="PAGE.submit(false);" />
<input id="reprint" type="button" value="Reprint"
	onClick="PAGE.submit(true);" />
<input id="buySlip" type="button" value="Buy a new slip"
	onClick="PAGE.buySlip();" />
<input id="save" type="button" value="Save" 
	onClick="PAGE.save();" />
<span id="validationDate"></span>
<div id="patientInfoPrintArea">
	<center>
		<form id="patientInfoForm" method="POST">
			<table border=0 width="710" style="font-size: 14px;">
				<img type="image" src="../../moduleResources/registration/Logo_Tibet.jpg"/>
				<h2>${hospitalName}</h2>
				<h2>Registration Receipt</h2>
				<tr>
					<td><b>Day of Visit:</b></td>
					<td>${dayOfVisit}</td>
				</tr>
				<tr>
					<td colspan="1"><b>Patient Name:</b></td>
					<td colspan="2"><span id="name" /></td>
				</tr>
				<tr>
					<td colspan="1""><b>Patient ID:</b></td>
					<td colspan="2""><span id="identifier" /></td>
				</tr>
				<tr>
					<td colspan="1"><b>Age:</b></td>
					<td colspan="2"><span id="age" /></td>
				</tr>
				<tr>
					<td colspan="1"><b>Gender:</b></td>
					<td colspan="2"><span id="gender" /></td>
				</tr>
				<tr>
					<td colspan="1"><b>Patient Category:</b></td>
					<td colspan="2"><span id="category" /></td>
				</tr>
				<tr>
					<td colspan="1" id="tempCat1"><b>Temp Categ:</b></td>
					<td colspan="2" id="tempCat2"><span id="temporaryCategories"></span></td>
				</tr>
				<tr id="opdWardLabel">
					<td colspan="1"><b>Room to Visit:</b></td>
					<td colspan="3"><select id="opdWard" name="patient.opdWard">
					</select></td>
				</tr>
				<tr>
					<td colspan="1"><b>Registration Fee:</b></td>
					<td colspan="2">${registrationFee}</td>
				</tr>
				<tr>
					<td colspan="1"><b>You were served by:</b></td>
					<td colspan="2">${userName}</td>
				</tr>
			</table>
		</form>
	</center>
</div>
