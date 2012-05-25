<script type="text/javascript">
	jQuery(document).ready(function(){		
		jQuery("#patientId").val(MODEL.patientId);
		jQuery("#revisit").val(MODEL.revisit);
		jQuery("#identifier").html(MODEL.patientIdentifier);
		jQuery("#age").html(MODEL.patientAge);
		jQuery("#name").html(MODEL.patientName);
		jQuery("#category").html(MODEL.patientAttributes[14]);
		jQuery("#phoneNumber").html(MODEL.patientAttributes[16]);
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
			jQuery("#opdWard").val(MODEL.observations[3]);
			jQuery.each(MODEL.observations[11].split(","), function(index, value){
				jQuery("input[name=temporary.attribute.11][value='" + value + "']").attr("checked", "checked");
			});		
			jQuery("#printSlip").hide();
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
<input id="printSlip" type="button" value="Print" onClick="PAGE.submit(false);"/>
<input id="reprint" type="button" value="RePrint" onClick="PAGE.submit(true);"/>
<input id="buySlip" type="button" value="Buy a new slip" onClick="PAGE.buySlip();"/>
<span id="validationDate"></span>
<div id="patientInfoPrintArea">
<!-- <table border=0>
		<tr height=100>
		</tr>
		<tr>
		<td width=500>
		</td>
		<td>	 -->
		<center>
		<form id="patientInfoForm" method="POST">				
			<table border=0  width="600">
				<tr>
				
				</tr>
				<tr>
					<td colspan="1""><b>ID.No:</b></td>
					<td  colspan="5"">
						<span id="identifier"/>
					</td>
				</tr>
				<tr>
					<td colspan="1"><b>Name:</b></td>
					<td  colspan="5">
						<span id="name"/>
					</td>
				</tr>
				<tr>
					<td colspan="1"><b>Age:</b></td>
					<td colspan="5">
						<span id="age"/>
					</td>
				</tr>
				<tr>
					<td colspan="1"><b>Gender:</b></td>
					<td colspan="5">
						<span id="gender"/>
					</td>
				</tr>
				<tr>
					<td colspan="1" valign="top"><b>Phone number:</b></td>
					<td colspan="5">
						<span id="phoneNumber"/>			
					</td>
				</tr>
				<!-- 03/05/2012 Thai Chuong: Supported issue #182 -->
				<tr id="opdWardLabel">
					<td colspan="1"><b>OPD room to visit:</b></td>
					<td colspan="5">
						<select id="opdWard" name="patient.opdWard">
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="1"><b>Date/Time:</b></td>
					<td colspan="5">
						<span id="datetime"/>
					</td>
				</tr>
				<tr>
					<td colspan="1"><b>Category:</b></td>
					<td colspan="5">
						<span id="category"/>
					</td>
				</tr>
				<tr id="temporaryCategories">
				<!-- 01/05/12: Marta, Painting Temporary Category in red. Bug #182  -->
					<td colspan="1" valign="top"><b> <font color="red">Temporary Categories: </font></b></td>
					<td colspan="5">
						<!-- 28/04/12: Changed MODEL.observations[11] for MODEL.observations[8058] by Marta - Bug #160 -->
					    <input type="checkbox" name="temporary.attribute.11" value="MLC"/> MLC <br/>
						<input type="checkbox" name="temporary.attribute.11" value="Accident"/> Accident <br/>										
					</td>
				</tr>
				<tr>
					<td colspan="6">
						<div id="printableTemporaryCategories">
							
						</div>
					</td>						
				</tr>
		</table> 
		</form>
		</center>
		<!--	</td>
	</tr>
	</table>-->



	<!--<center>
		 17/5/2012 Marta: Remove Name and hospital Logo from patient info form Issue #214  -->
		<!-- <img src="${pageContext.request.contextPath}/moduleResources/registration/header.jpg"/> -->
		<!-- <form id="patientInfoForm" method="POST">	
			<table cellspacing="10">
				<tr>
					<td><b>ID.NO:</b></td>
					<td colspan="3" valign="left">
						<span id="identifier"/>
					</td>
					<td><b>Age:</b></td>
					<td colspan="3" valign="left">
						<span id="age"/>
					</td>
				</tr>
				<tr>
					<td><b>Name:</b></td>
					<td colspan="3" valign="left">
						<span id="name"/>
					</td>
					<td><b>Gender:</b></td>
					<td colspan="3">
						<span id="gender"/>
					</td>
				</tr>
				<tr>
					<td colspan="5"><b>OPD room to visit:</b></td>
					<td colspan="4">
						<select id="opdWard" name="patient.opdWard">
						</select>
					</td>
				</tr>
				<tr>
					<td><b>Category:</b></td>
					<td colspan="3">
						<span id="category"/>
					</td>
					<td colspan="2"><b>Date/Time:</b></td>
					<td colspan="3" valign="left">
						<span id="datetime"/>
					</td>
				</tr>
				<tr>
					<td colspan="3" valign="top"><b>Phone number:</b></td>
					<td>
						<span id="phoneNumber"/>			
					</td>
				</tr>
				<tr id="temporaryCategories">
					<td valign="top"><b>Temporary Categories:</b></td>
					<td colspan="5">
						<input type="checkbox" name="temporary.attribute.11" value="MLC"/> MLC <br/>
						<input type="checkbox" name="temporary.attribute.11" value="Accident"/> Accident <br/>										
					</td>
				</tr>
				<tr>
					<td colspan="6">
						<div id="printableTemporaryCategories">
						</div>
					</td>						
				</tr>
			</table>
		</form>  
	</center>-->
	<!-- 17/5/2012 Marta: Remove list of investigations from patient info form Issue #214  -->	
	<!-- <img src="${pageContext.request.contextPath}/moduleResources/registration/investigations.jpg"/>  -->
</div>
