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
<%@ include file="/WEB-INF/template/include.jsp" %>
<openmrs:globalProperty var="userLocation" key="hospital.location_user" defaultValue="false"/>

<script type="text/javascript">
	jQuery(document).ready(function(){		
		jQuery("#patientId").val(MODEL.patientId);
		jQuery("#revisit").val(MODEL.revisit);
		jQuery("#identifier").html(MODEL.patientIdentifier);
		jQuery("#age").html(MODEL.patientAge);
		jQuery("#name").html(MODEL.patientName);
		jQuery("#feeHideVal").hide();
		jQuery("#catHideVal").hide();
		
		jQuery("#mlc").hide();
		
		jQuery("#buySlip").hide();
		
		jQuery("#specialSchemeNameField").hide();
		
		jQuery("#triageField").hide();
		jQuery("#opdWardField").hide();
		
        jQuery("#nationalId").html(MODEL.patientAttributes[20]);
		jQuery("#phoneNumber").html(MODEL.patientAttributes[16]);
		jQuery("#maritalStatus").html(MODEL.patientAttributes[26]);
		jQuery("#gender").html(MODEL.patientGender);
		jQuery("#datetime").html(MODEL.currentDateTime);
		jQuery("#patientName").html(MODEL.patientName);
		
		MODEL.TRIAGE = " ,Please Select Triage to Visit|" + MODEL.TRIAGE;
		PAGE.fillOptions("#triage", {
			data:MODEL.TRIAGE,
			delimiter: ",",
			optionDelimiter: "|"
		});
		
		MODEL.OPDs = " ,Please Select OPD to Visit|" + MODEL.OPDs;
		PAGE.fillOptions("#opdWard", {
			data:MODEL.OPDs,
			delimiter: ",",
			optionDelimiter: "|"
		});
		
		MODEL.MEDICOLEGALCASE = " ,Please Select MEDICO LEGAL CASE|" + MODEL.MEDICOLEGALCASE;
		PAGE.fillOptions("#mlc", {
			data:MODEL.MEDICOLEGALCASE,
			delimiter: ",",
			optionDelimiter: "|"
		});
		
		// Set the selected triage
		if(!StringUtils.isBlank(MODEL.selectedTRIAGE)){	
		    jQuery("#triageField").show();		
			jQuery("#triage").val(MODEL.selectedTRIAGE);
			jQuery("#triage").attr("disabled", "disabled");
		}
		
		// Set the selected OPD
		if(!StringUtils.isBlank(MODEL.selectedOPD)){
		    jQuery("#opdWardField").show();
			jQuery("#opdWard").val(MODEL.selectedOPD);
			jQuery("#opdWard").attr("disabled", "disabled");
		}
		
		if(!StringUtils.isBlank(MODEL.selectedMLC)){	
		    jQuery("#mlc").show();		
			jQuery("#mlc").val(MODEL.selectedMLC);	
			jQuery("#mlc").attr("disabled", "disabled");
		}
		
		
		
		jQuery("#paying").click(function() {
		VALIDATORS.payingCheck();
		});
		jQuery("#nonPaying").click(function() {
		VALIDATORS.nonPayingCheck();
		});
		jQuery("#specialSchemes").click(function() {
		VALIDATORS.specialSchemeCheck();
		});
		
		jQuery("#mlcCaseYes").click(function() {
		VALIDATORS.mlcYesCheck();
		});		
		jQuery("#mlcCaseNo").click(function() {
		VALIDATORS.mlcNoCheck();
		});
		
		jQuery("#triageRoom").click(function() {
		VALIDATORS.triageRoomCheck();
		});	
		jQuery("#opdRoom").click(function() {
		VALIDATORS.opdRoomCheck();
		});

		
		//ghanshyam,11-dec-2013,#3327 Defining patient categories based on Kenyan requirements
		if(!StringUtils.isBlank(MODEL.selectedPaymentCategory)){
			
			jQuery("#payingField").hide();
			jQuery("#nonPayingField").hide();
			jQuery("#specialSchemeField").hide();
			
			jQuery("#catHideVal").val(MODEL.selectedPaymentCategory);
			jQuery("#catHideVal").hide();
	//		jQuery("#paymentCategory").hide();
	//		jQuery("#paymentCategory").after("<span>" + jQuery("#paymentCategory option:checked").html() +  "</span>"); 
			if(${registrationFee==''} || ${registrationFee==null}){
			if(MODEL.selectedPaymentCategory == "Paying"){
			        jQuery("#payingField").after("<span style='border:0px'>" + jQuery("#paying").val() + "</span>");
					jQuery("#regFeeValue").val(${initialRegFee});
					jQuery("#regFeeValue").attr("disabled", "disabled");
					jQuery("#feeHideVal").val(${initialRegFee});
						jQuery("#feeHideVal").hide();
					//	jQuery("#regFeeValue").hide();
					//	jQuery("#regFeeValue").after("<span>" + jQuery("#regFeeValue option:checked").html() +  "</span>");  
				}
			if(MODEL.selectedPaymentCategory == "Non-Paying"){
			            jQuery("#payingField").after("<span style='border:0px'>" + jQuery("#nonPaying").val() + "</span>");
						jQuery("#regFeeValue").val(0);
						jQuery("#regFeeValue").attr("disabled", "disabled");
						jQuery("#feeHideVal").val(0);
						jQuery("#feeHideVal").hide();
					//	jQuery("#regFeeValue").hide();
					//	jQuery("#regFeeValue").after("<span>" + jQuery("#regFeeValue option:checked").html() +  "</span>"); 
				}
			if(MODEL.selectedPaymentCategory == "Special Schemes"){
			            if(!StringUtils.isBlank(MODEL.specialSchemeName)){	
			            jQuery("#payingField").after("<span style='border:0px'>" + MODEL.specialSchemeName + "&nbsp;&nbsp;" + "</span>");
		                 }
			            jQuery("#payingField").after("<span style='border:0px'>" + jQuery("#specialSchemes").val() + "</span>");
						jQuery("#feeHideVal").val(jQuery("#regFeeValue").val());
				}
				}
			}
			
			if(!StringUtils.isBlank(MODEL.selectedTRIAGE) || !StringUtils.isBlank(MODEL.selectedOPD)){	
			jQuery("#mlcCaseYesField").hide();
			jQuery("#mlcCaseNoField").hide();
			
			jQuery("#triageRoomField").hide();
			jQuery("#opdRoomField").hide();
			}
			
		
		
		//Category Check
		jQuery("#paymentCategory").change(function() {
			VALIDATORS.categoryCheck();
		});

	/*	jQuery("#mlc").change(function() {
			VALIDATORS.tempCatCheck();
		});*/
		
		// Set data for reprint page
		if(MODEL.reprint=="true"){
		    jQuery("#payingField").after("<span style='border:0px'>" + '${selectedPaymentCategory}' + "</span>");
			var triageId=MODEL.triageId;
		    jQuery("#triage").val(MODEL.observations[triageId]);
		    jQuery("#triage").attr("disabled", "disabled");
		
			var mlcId=MODEL.mlcId;
			if(!StringUtils.isBlank(MODEL.observations[mlcId])){
			jQuery("#mlc").val(MODEL.observations[mlcId]);
			jQuery("#mlc").attr("disabled", "disabled");
			}
			
						jQuery("#regFeeValue").val(${registrationFee});
						jQuery("#regFeeValue").attr("disabled", "disabled");
						jQuery("#feeHideVal").val(${registrationFee});
				//		jQuery("#regFeeValue").hide();
				//		jQuery("#regFeeValue").after("<span>" + jQuery("#regFeeValue option:checked").html() +  "</span>"); 
			
		    
			jQuery("#printSlip").hide();
			jQuery("#save").hide();
			//ghanshyam  20-may-2013 #1648 capture Health ID and Registration Fee Type
		//	jQuery("#regFee").hide()
			jQuery("#tempCat").hide();
		} else {
			jQuery("#reprint").hide();
			//ghanshyam  20-may-2013 #1648 capture Health ID and Registration Fee Type
			jQuery("#regFee").hide()
			jQuery("#tempCat").hide();
		}
		
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
				//jQuery("#triage").hide();
				//jQuery("#triage").after("<span>" + jQuery("#triage option:checked").html() +  "</span>");  
				jQuery("#opdWardLabel").hide();
				
				jQuery("#paymentCategory").hide();
				jQuery("#paymentCategory").after("<span style='border:0px'>" + jQuery("#paymentCategory  option:checked").html() + "</span>"); 
				
				jQuery("#regFeeValue").hide();
				jQuery("#regFeeValue").after("<span style='border:0px'>" + jQuery("#regFeeValue  option:checked").html() + "</span>"); 
				

			if(jQuery("#paymentCategory").val()=="Special Schemes"){
				jQuery("#specialSchemeName").hide();
				jQuery("#specialSchemeName").after("<span style='border:0px'>" + jQuery("#specialSchemeName").val() + "</span>"); 
				}
				
				//ghanshyam  20-may-2013 #1648 capture Health ID and Registration Fee Type	
                 jQuery("#regFeeType input").each(function(index, value){				
					if(jQuery(value).is(":checked")){
						jQuery("#printableRegFee").append("<span style='margin:5px;'>" + jQuery(value).val() + "</span>");
						jQuery("#regFee").show();		
					}
				});
				jQuery("#regFeeType").hide();
				
				// Convert temporary categories to printable format
				jQuery("#temporaryCategories input").each(function(index, value){				
					if(jQuery(value).is(":checked")){
						jQuery("#printableTemporaryCategories").append("<span style='margin:10px;'>" + jQuery(value).val() + "</span>");
						jQuery("#tempCat").show();		
					}
				});
				
/*				Sagar Bele, 11-01-2013: Issue #663 Registration alignment				
				if(!StringUtils.isBlank(jQuery("#printableTemporaryCategories").html())){
					jQuery("#printableTemporaryCategories").prepend("<b>Temporary Categories:</b>");
				}
*/				
				jQuery("#temporaryCategories").hide();
//				jQuery("#tempCat").show();
				
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
		
		// harsh #244 Added a save button.
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
		if(StringUtils.isBlank(MODEL.selectedTRIAGE) && StringUtils.isBlank(MODEL.selectedOPD)){
			if (jQuery("#triageRoom").attr('checked') == false
					&& jQuery("#opdRoom").attr('checked') == false) {			
			    alert("You did not choose any of the room");
				return false;
			} else {
			    if (jQuery("#triageRoom").attr('checked')) {
					if (StringUtils.isBlank(jQuery("#triage").val())) {
						alert("Please select the triage room to visit");
						return false;
					}
				}
				else{
				    if (StringUtils.isBlank(jQuery("#opdWard").val())) {
						alert("Please select the OPD room to visit");
						return false;
					}
				}
			}
		 };
			
			if(jQuery("#paymentCategory").val()=="Special Schemes"){
				if(jQuery("#specialSchemeName").val().length <= 0){
					alert("Please fill Special Scheme Name");
					return false;
				}
			};
			
			if(jQuery("#paymentCategory").val()=="Payment Category"){
				alert("Please Select Payment Category");
				return false;
			};

			if(jQuery("#paymentCategory").val()=="Special Schemes"){
			//jQuery("#specialSchemeNameField").show();
			jQuery("#feeHideVal").val(jQuery("#regFeeValue").val());
			}
			
			return true;
		}
	};
	
	//ghanshyam  20-may-2013 #1648 capture Health ID and Registration Fee Type
	VALIDATORS = {
	
		/** CHECK WHEN PAYING CATEGORY IS SELECTED */
		payingCheck : function() {
			if (jQuery("#paying").is(':checked')) {
					jQuery("#nonPaying").removeAttr("checked");
				    
				    jQuery("#specialSchemes").removeAttr("checked");
					jQuery("#specialSchemeName").val("");
					jQuery("#specialSchemeNameField").hide();
					
					jQuery("#regFeeValue").val(${reVisitFee});
					//jQuery("#feeHideVal").val(${reVisitFee});
					//jQuery("#feeHideVal").hide();
			}
		},
		
		/** CHECK WHEN NONPAYING CATEGORY IS SELECTED */
		nonPayingCheck : function() {
			if (jQuery("#nonPaying").is(':checked')) {
					jQuery("#paying").removeAttr("checked");
				    
				    jQuery("#specialSchemes").removeAttr("checked");
					jQuery("#specialSchemeName").val("");
					jQuery("#specialSchemeNameField").hide();
					
					jQuery("#regFeeValue").val(0);
					//jQuery("#feeHideVal").val(${reVisitFee});
					//jQuery("#feeHideVal").hide();
			}
		},
		
		/** CHECK WHEN SPECIAL SCHEME CATEGORY IS SELECTED */
		specialSchemeCheck : function() {
			if (jQuery("#specialSchemes").is(':checked')) {
					jQuery("#paying").removeAttr("checked");
					
					jQuery("#nonPaying").removeAttr("checked");
					jQuery("#specialSchemeNameField").show();
					
					jQuery("#regFeeValue").val(0);
					//jQuery("#feeHideVal").val(${reVisitFee});
					//jQuery("#feeHideVal").hide();
			}
			else{
			 jQuery("#specialSchemeName").val("");
			jQuery("#specialSchemeNameField").hide();
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
		
		triageRoomCheck : function () {
			if (jQuery("#triageRoom").is(':checked')) {
			        jQuery("#opdRoom").removeAttr("checked");
					jQuery("#triageField").show();	
					jQuery("#opdWardField").hide();	
			}
			else{
			jQuery("#triageField").hide();	
			}
		},
		
		opdRoomCheck : function () {
			if (jQuery("#opdRoom").is(':checked')) {
			        jQuery("#triageRoom").removeAttr("checked");
			        jQuery("#triageField").hide();
					jQuery("#opdWardField").show();	
			}
			else{
			jQuery("#opdWardField").hide();	
			}
		},
		
		
		
		categoryCheck : function() {
			
			if (jQuery("#paymentCategory").val() == "Paying") {
				
				jQuery("#specialSchemeName").val("");
				jQuery("#specialSchemeNameField").hide();
				
				jQuery("#regFeeValue").val(${reVisitFee});
				jQuery("#feeHideVal").val(${reVisitFee});
				//jQuery("#regFeeValue").attr("disabled", "disabled");
				
			} else if(jQuery("#paymentCategory").val() == "Non-Paying"){
				jQuery("#specialSchemeName").val("");
				jQuery("#specialSchemeNameField").hide();

				jQuery("#regFeeValue").val(0);
				jQuery("#feeHideVal").val(0);
				//jQuery("#regFeeValue").attr("disabled", "disabled");

		
			} else if(jQuery("#paymentCategory").val() == "Special Schemes"){
				jQuery("#specialSchemeNameField").show();
				
				jQuery("#regFeeValue").removeAttr("disabled");
				jQuery("#feeHideVal").val(jQuery("#regFeeValue").val());
				
			}
		},
	};
</script>

<input id="printSlip" type="button" value="Print"
	onClick="PAGE.submit(false);" />
<input id="reprint" type="button" value="Reprint"
	onClick="PAGE.submit(true);" />
<input id="buySlip" type="button" value="Buy a new slip"
	onClick="PAGE.buySlip();" />
<input id="save" type="button" value="Save" onClick="PAGE.save();" />
<span id="validationDate"></span>
<div id="patientInfoPrintArea" style="width: 1280px; font-size: 0.8em">
<style>
	.donotprint {
		display: none;
	}
	.spacer {
		
		font-family: "Dot Matrix Normal", Arial, Helvetica, sans-serif;
		font-style: normal;
		font-size: 14px;
	}
	.printfont {
		font-family: "Dot Matrix Normal", Arial, Helvetica, sans-serif;
		font-style: normal;
		font-size: 14px;
	}

</style>
	<center>
	<center><img width="100" height="100" align="center" title="OpenMRS" alt="OpenMRS" src="${pageContext.request.contextPath}/moduleResources/registration/kenya_logo.bmp"><center>
		<form id="patientInfoForm" method="POST" class="spacer" style="margin-left: 20px;">
			<table class="spacer" style="margin-left: 20px;">
			<tr><h3><center><u><b>${userLocation} </b></u></center></h3></tr>
						<tr><h4><center><b>Registration Receipt</b></center></h4></tr>
				<tr>
					<td colspan="1"><b>Date/Time:</b></td>
					<td colspan="5"><span id="datetime"></span></td>
				</tr>
				<tr>
					<td colspan="1"><b>Name:</b></td>
					<td><span id="patientName"></span></td>
				</tr>
				<tr>
					<td colspan="1"><b>Patient ID:</b></td>
					<td colspan="5"><span id="identifier"></span></td>
				</tr>				
				<tr id="ageField">
					<td colspan="1"><b>Age:</b></td>
					<td colspan="5"><span id="age"></span></td>
				</tr>
				<tr id="genderField">
					<td colspan="1"><b>Gender:</b></td>
					<td colspan="5"><span id="gender"></span></td>
				</tr>
				
				<tr>
<!--					<td colspan="1"><b>Marital Status:</b></td>
					<td colspan="1"><span id="maritalStatus"></span></td> -->
					<td></td><td></td>
					
				</tr>
				
				<tr>
				<td><b>Payment Category:&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
				<td id="payingField"><input id="paying" type="checkbox" name="person.attribute.14" value="Paying" /> Paying</td>
		</tr>
		<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td id="nonPayingField"><input id="nonPaying" type="checkbox" name="person.attribute.14" value="Non-Paying" /> Non-Paying</td>
		</tr>
		<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td id="specialSchemeField"><input id="specialSchemes" type="checkbox" name="person.attribute.14" value="Special Schemes" /> Special Schemes &nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td id="specialSchemeNameField"><input id="specialSchemeName" name="person.attribute.42" placeholder="Please specify" style='width: 152px;'/></td>
		</tr>
		
				
				<%-- ghanshyam 27-02-2013 Feedback #966[Billing]Add Paid Bill/Add Free Bill for Bangladesh module(remove category from registration,OPD,IPD,Inventory)--%>
				<%--
				<tr>
					<td colspan="1"><b>Category:</b></td>
					<td colspan="1"  ><span id="category" /></td>
					<td><span id="FREE" /></td>
				</tr>
				--%>
				<!--
				<tr>
					<td colspan="1"><b>National ID:</b></td>
					<td colspan="1"><span id="nationalId"></span></td>
				</tr>
				-->
				<%-- ghanshyam  20-may-2013 #1648 capture Health ID and Registration Fee Type 
				
				<tr id="regFeeType">
					<td><b> <font color="red"> Registration Fee Type:</font> </b>
					</td>
					<td><input id="paidReg" type="checkbox"
						name="patient.registration.fee.attribute.${regFeeConId}" value="${regFee}" onClick="paidClick();" />
						Paid</td>
					<td><input id="freeReg" type="checkbox"
						name="patient.registration.fee.attribute.${regFeeConId}" value="0" onClick="freeClick();" /> Free</td>
					<td><span id="freeRegField">Reason <input
							id="freeRegReason"
							name="patient.registration.fee.free.reason.attribute.${regFeeReasonConId}" /> </span></td>
					<td><span style="color:red;" id="message" > </span></td>
				</tr> --%>
				
				<tr id="temporaryCategories">
				<td><b>Medico Legal Case:&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
				<td id="mlcCaseYesField"><input id="mlcCaseYes" type="checkbox" name="mlcCaseYes"/> Yes &nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><select id="mlc" name="patient.mlc" style='width: 152px;'>	</select></td>
		</tr>
		<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td id="mlcCaseNoField"><input id="mlcCaseNo" type="checkbox" name="mlcCaseNo"/> No &nbsp;&nbsp;&nbsp;&nbsp;</td>
		</tr>
		
		
		<tr>
				<td><b>Room to Visit:</b>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td id="triageRoomField"><input id="triageRoom" type="checkbox" name="triageRoom"/> Triage Room &nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td id="triageField"><select id="triage" name="patient.triage" style='width: 152px;'>	</select></td>
		</tr>
		<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td id="opdRoomField"><input id="opdRoom" type="checkbox" name="opdRoom"/> OPD Room&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td id="opdWardField"><select id="opdWard" name="patient.opdWard" style='width: 152px;'>	</select></td>
		</tr>
				
				
				<tr>
					<td colspan="1"><b>Registration Fee:</b></td>
					<td><select id="regFeeValue" name="regFeeValue">
										<option value=0>0</option>
										<option value=10>10</option>
										<option value=20>20</option>
										<option value=30>30</option>
										<option value=40>40</option>
										<option value=50>50</option>
										<option value=60>60</option>
										<option value=70>70</option>
										<option value=80>80</option>
										<option value=90>90</option>
										<option value=100>100</option>
						</select>
					</td>			
					<td id="feeHide">
							<span><input id="feeHideVal" name="feeHideVal" />
							</span>
					</td>
				</tr>
				<tr>
                <td><input type="hidden" id="selectedPaymentCategory" name="selectedPaymentCategory" value="${selectedPaymentCategory}"></td>
                </tr>
			</table>
		</form>
	</center>
</div>
