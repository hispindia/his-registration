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
		jQuery("#category").html(MODEL.patientAttributes[14]);
		if("RSBY" == MODEL.patientAttributes[14]){
		jQuery("#RSBY").html(MODEL.patientAttributes[11]);
		}
		if("BPL" == MODEL.patientAttributes[14]){
		jQuery("#BPL").html(MODEL.patientAttributes[10]);
		}
		if("RSBY,BPL" == MODEL.patientAttributes[14]){
		jQuery("#RSBY").html(MODEL.patientAttributes[11]);
		//jQuery("#BPL").html(MODEL.patientAttributes[10]);
		}
		if(MODEL.patientAttributes[14]=='Other Free'){
		jQuery("#freeCategory").html(MODEL.selectedOtherFree);
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
	onClick="PAGE.submit(false);" /> <!-- Sept 22,2012 -- Sagar Bele -- Issue 387 --Change case of word Reprint-->
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
				<tr>

				</tr>
				<tr>
					<td colspan="1""><b>ID.No:</b></td>
					<td colspan="2""><span id="identifier" /></td>
					<td colspan="3"><b>Age:</b></td>
					<td colspan="4"><span id="age" /></td>
				</tr>
				<tr>
					<td colspan="1"><b>Patient Name:</b></td>
					<td colspan="2"><span id="name" /></td>
					<td colspan="3"><b>Gender:</b></td>
					<td colspan="4"><span id="gender" /></td>
				</tr>
				<tr>
					<td colspan="1"><b>Date/Time:</b></td>
					<td colspan="2"><span id="datetime" /></td>
					<td colspan="3" id="tempCat1"><b>Temp Categ:</b></td>
					<td colspan="4" id="tempCat2"><span id="temporaryCategories"></span></td>
				</tr>
				<tr id="opdWardLabel">
					<td colspan="1"><b>OPD room:</b></td>
					<td colspan="3"><select id="opdWard" name="patient.opdWard">
					</select></td>
				</tr>
				
				<tr>
					<td colspan="1"><b>Category:</b></td>
					<td colspan="2"><span id="category" /></td>
					<td><span id="RSBY" /></td>
					<td><span id="BPL" /></td>
					<td colspan="3"><span id="freeCategory" /></td>
				</tr>
				
				<tr id="aadharCardRow">
					<td colspan="1"><b>Aadhar No:</b></td>
					<td colspan="2"><span id="aadharCardNo"></span></td>
				</tr>
			
			</table>
		</form>
	</center>


	<tr>
				<center>
					
					<img type="image"  src="../../moduleResources/registration/image2.JPG" style="position: fixed;left:0;bottom: 0;text-align: center;"> 
				</center>
				
			</tr>
			
</div>
