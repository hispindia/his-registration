 <%--
 *  Copyright 2012 Society for Health Information Systems Programm's, India (HISP India)
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
 *  Author : Sagar Bele
 *  Date: 15-12-2012
--%>

<script type="text/javascript">
	jQuery(document).ready(function(){		
		jQuery("#patientId").val(MODEL.patientId);
		jQuery("#revisit").val(MODEL.revisit);
		jQuery("#identifier").html(MODEL.patientIdentifier);
		jQuery("#age").html(MODEL.patientAge);
		jQuery("#name").html(MODEL.patientName);
		
		if(MODEL.patientAttributes[14]){
			pattern = /[A-Z]+[,][A-Z]/;
			if(pattern.test(MODEL.patientAttributes[14])){

				jQuery("#Free").html("Free Reason.: " + MODEL.patientAttributes[11]);


			}else{			
				if("Free" == MODEL.patientAttributes[14])
					jQuery("#Free").html(MODEL.patientAttributes[19]);
			
jQuery("#category").html(MODEL.patientAttributes[14]);
			}
								
		}


		jQuery("#phoneNumber").html(MODEL.patientAttributes[16]);
		jQuery("#patientNationalId").html(MODEL.patientAttributes[20]);
		jQuery("#patientWeight").html(MODEL.patientAttributes[21]);
		jQuery("#patientBloodPressure").html(MODEL.patientAttributes[22]);
		jQuery("#patientHistory").html(MODEL.patientAttributes[23]);
		jQuery("#gender").html(MODEL.patientGender);
		jQuery("#datetime").html(MODEL.currentDateTime);
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
		
			var tempCategoryId=MODEL.tempCategoryId;
			if(!StringUtils.isBlank(MODEL.observations[tempCategoryId])){
			
				jQuery.each(MODEL.observations[tempCategoryId].split(","), function(index, value){
					jQuery("input[name=temporary.attribute.11][value='" + value + "']").attr("checked", "checked");
				});	}
			jQuery("#printSlip").hide();
			jQuery("#save").hide();
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

				// Convert temporary categories to printable format
				jQuery("#temporaryCategories input").each(function(index, value){				
					if(jQuery(value).is(":checked")){
						jQuery("#printableTemporaryCategories").append("<span style='margin:5px;'>" + jQuery(value).val() + "</span>");
					}
				});
				
				if(!StringUtils.isBlank(jQuery("#printableTemporaryCategories").html())){
					jQuery("#printableTemporaryCategories").prepend("<b>Temporary Categories:</b>");
				}
				
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
		
		save: function(){
			if (PAGE.validate()){
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
				<tr>
					<td colspan="1"><b>Date/Time:</b></td>
					<td colspan="5"><span id="datetime" /></td>
				</tr>
				<tr>
					<td colspan="1"><b>Category:</b></td>
					<td colspan="2"><span id="category" /></td>
					<td><span id="Free" /></td>
				</tr>
				<tr>
					<td colspan="1" valign="top"><b>National ID:</b></td>
					<td colspan="5"><span id="patientNationalId" /></td>
				</tr>
				<tr id="opdWardLabel">
					<td colspan="1"><b>OPD room to visit:</b></td>
					<td colspan="5"><select id="opdWard" name="patient.opdWard">
					</select></td>
				</tr>
				<tr>
					<td colspan="1" valign="top"><b>Weight:</b></td>
					<td colspan="5"><span id="patientWeight" /></td>
				</tr>
				<tr>
					<td colspan="1" valign="top"><b>Blood Pressure:</b></td>
					<td colspan="5"><span id="patientBloodPressure" /></td>
				</tr>
				<tr>
					<td colspan="1" valign="top"><b>History:</b></td>
					<td colspan="5"><span id="patientHistory" /></td>
				</tr>
				<tr id="temporaryCategories">
					<td colspan="1" valign="top"><b> <font color="red">Temporary
								Categories: </font></b></td>
					<td colspan="5">
						<input type="checkbox" name="temporary.attribute.11" value="MLC" />
						MLC <br /> <input type="checkbox" name="temporary.attribute.11"
						value="Accident" /> Accident <br />
					</td>
				</tr>
				<tr>
					<td colspan="6">
						<div id="printableTemporaryCategories"></div>
					</td>
				</tr>
			</table>
		</form>
	</center>
</div>
