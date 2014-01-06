/**
 *  Copyright 2008 Society for Health Information Systems Programmes, India (HISP India)
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
 *
 **/

package org.openmrs.module.registration.web.controller.patient;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Concept;
import org.openmrs.ConceptName;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.Order;
import org.openmrs.OrderType;
import org.openmrs.Patient;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonAttributeType;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.DmsCommonService;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.model.DmsOpdUnit;
import org.openmrs.module.hospitalcore.util.GlobalPropertyUtil;
import org.openmrs.module.hospitalcore.util.HospitalCoreConstants;
import org.openmrs.module.hospitalcore.util.ObsUtils;
import org.openmrs.module.hospitalcore.util.OrderUtil;
import org.openmrs.module.registration.RegistrationService;
import org.openmrs.module.registration.model.RegistrationFee;
import org.openmrs.module.registration.util.RegistrationConstants;
import org.openmrs.module.registration.util.RegistrationUtils;
import org.openmrs.module.registration.web.controller.util.PatientModel;
import org.openmrs.module.registration.web.controller.util.RegistrationWebUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller("RegistrationShowPatientInfoController")
@RequestMapping("/module/registration/showPatientInfo.form")
public class ShowPatientInfoController {
	
	private static Log logger = LogFactory.getLog(ShowPatientInfoController.class);
	
	@RequestMapping(method = RequestMethod.GET)
	public String showPatientInfo(@RequestParam("patientId") Integer patientId,
	                              @RequestParam(value = "encounterId", required = false) Integer encounterId,
	                              @RequestParam(value = "reprint", required = false) Boolean reprint, Model model)
	                                                                                                              throws IOException,
	                                                                                                              ParseException {
		
		Patient patient = Context.getPatientService().getPatient(patientId);
		HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
		PatientModel patientModel = new PatientModel(patient);
		model.addAttribute("patient", patientModel);
		//ghanshyam,16-dec-2013,3438 Remove the interdependency
		model.addAttribute("TRIAGE", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_TRIAGE));
		model.addAttribute("TEMPORARYCAT", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_TEMPORARY_CATEGORY));
		// Get current date
		SimpleDateFormat sdf = new SimpleDateFormat("EEE dd/MM/yyyy kk:mm");
		model.addAttribute("currentDateTime", sdf.format(new Date()));
		
		// Get patient registration fee
		if (GlobalPropertyUtil.getInteger(RegistrationConstants.PROPERTY_NUMBER_OF_DATE_VALIDATION, 0) > 0) {
			List<RegistrationFee> fees = Context.getService(RegistrationService.class).getRegistrationFees(patient,
			    GlobalPropertyUtil.getInteger(RegistrationConstants.PROPERTY_NUMBER_OF_DATE_VALIDATION, 0));
			if (!CollectionUtils.isEmpty(fees)) {
				RegistrationFee fee = fees.get(0);
				Calendar dueDate = Calendar.getInstance();
				dueDate.setTime(fee.getCreatedOn());
				dueDate.add(Calendar.DATE, 30);
				model.addAttribute("dueDate", RegistrationUtils.formatDate(dueDate.getTime()));
				model.addAttribute("daysLeft", dateDiff(dueDate.getTime(), new Date()));
			}
		}
		
		// Get selected OPD room if this is the first time of visit
		if (encounterId != null) {
			//ghanshyam,11-dec-2013,#3327 Defining patient categories based on Kenyan requirements
			List<PersonAttribute> pas = hcs.getPersonAttributes(patientId);
			 for (PersonAttribute pa : pas) {
				 PersonAttributeType attributeType = pa.getAttributeType(); 
				 if(attributeType.getPersonAttributeTypeId()==14){
					 model.addAttribute("selectedCategory",pa.getValue()); 
				 }
				 //ghanshyam,18-dec-2013,# 3457 Exemption number for selected category should show on registration receipt
				 if(attributeType.getPersonAttributeTypeId()==31){
					 model.addAttribute("categoryValue1",pa.getValue()); 
				 }
				 if(attributeType.getPersonAttributeTypeId()==32){
					 model.addAttribute("categoryValue2",pa.getValue()); 
				 }
				 if(attributeType.getPersonAttributeTypeId()==33){
					 model.addAttribute("categoryValue3",pa.getValue()); 
				 }
				 if(attributeType.getPersonAttributeTypeId()==34){
					 model.addAttribute("categoryValue4",pa.getValue()); 
				 }
				 if(attributeType.getPersonAttributeTypeId()==35){
					 model.addAttribute("categoryValue5",pa.getValue()); 
				 }
				 if(attributeType.getPersonAttributeTypeId()==36){
					 model.addAttribute("categoryValue6",pa.getValue()); 
				 }
			 }
			 
			Encounter encounter = Context.getEncounterService().getEncounter(encounterId);
			for (Obs obs : encounter.getObs()) {
				//ghanshyam,16-dec-2013,3438 Remove the interdependency
				if (obs.getConcept().getName().getName().equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_TRIAGE)) {
					model.addAttribute("selectedTRIAGE", obs.getValueCoded().getConceptId());
				}
				if (obs.getConcept().getName().getName().equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_TEMPORARY_CATEGORY)) {
					model.addAttribute("tempCategory", obs.getValueCoded().getConceptId());
				}

			}
		}
		
		// If reprint, get the latest registration encounter
		if ((reprint != null) && reprint) {
			
			/**
			 * June 7th 2012 - Supported #250 - Registration 2.2.14 (Mohali): Date on Reprint
			 */
			model.addAttribute("currentDateTime", sdf.format(hcs.getLastVisitTime(patientId)));
			
			Encounter encounter = Context.getService(RegistrationService.class).getLastEncounter(patient);
			if (encounter != null) {
				Map<Integer, String> observations = new HashMap<Integer, String>();
				
				for (Obs obs : encounter.getAllObs()) {
					if (obs.getConcept().getDisplayString()
					        .equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_TEMPORARY_CATEGORY)) {
						model.addAttribute("tempCategoryId", obs.getConcept().getConceptId());
					} else if (obs.getConcept().getDisplayString()
					        .equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_OPD_WARD)) {
						model.addAttribute("triageId", obs.getConcept().getConceptId());
					}
					observations.put(obs.getConcept().getConceptId(), ObsUtils.getValueAsString(obs));
				}
				model.addAttribute("observations", observations);
			}
		}
		
		//ghanshyam  20-may-2013 #1648 capture Health ID and Registration Fee Type
		Concept conforregfee = Context.getConceptService().getConcept("REGISTRATION FEE");
		Integer conforregfeeid=conforregfee.getConceptId();
		model.addAttribute("regFeeConId",conforregfeeid);
		Concept conforregfreereason = Context.getConceptService().getConcept("REGISTRATION FEE FREE REASON");
		Integer conforregfreereasonid=conforregfreereason.getConceptId();
		model.addAttribute("regFeeReasonConId",conforregfreereasonid);
		model.addAttribute("regFee", GlobalPropertyUtil.getString(RegistrationConstants.PROPERTY_REGISTRATION_FEE, ""));
		return "/module/registration/patient/showPatientInfo";
	}
	
	/**
	 * Get date diff betwwen 2 dates
	 * 
	 * @param d1
	 * @param d2
	 * @return
	 */
	private long dateDiff(Date d1, Date d2) {
		long diff = Math.abs(d1.getTime() - d2.getTime());
		return (diff / (1000 * 60 * 60 * 24));
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public void savePatientInfo(@RequestParam("patientId") Integer patientId,
	                            @RequestParam(value = "encounterId", required = false) Integer encounterId,
	                            HttpServletRequest request, HttpServletResponse response) throws ParseException, IOException {
		
		Map<String, String> parameters = RegistrationWebUtils.optimizeParameters(request);
		
		// get patient
		Patient patient = Context.getPatientService().getPatient(patientId);
		
		/*
		 * SAVE ENCOUNTER
		 */
		Encounter encounter = null;
		if (encounterId != null) {
			encounter = Context.getEncounterService().getEncounter(encounterId);
		} else {
			encounter = RegistrationWebUtils.createEncounter(patient, true);
			
			// create TRIAGE obs
			//ghanshyam,16-dec-2013,3438 Remove the interdependency
			Concept triageConcept = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_TRIAGE);
			Concept selectedTRIAGEConcept = Context.getConceptService().getConcept(
			    Integer.parseInt(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_TRIAGE)));
			Obs opd = new Obs();
			opd.setConcept(triageConcept);
			opd.setValueCoded(selectedTRIAGEConcept);
			encounter.addObs(opd);
			
			// send patient to opd room
			RegistrationWebUtils.sendPatientToOPDQueue(patient, selectedTRIAGEConcept, true);
			
			
			Concept tempCatConcept = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_TEMPORARY_CATEGORY);
			Concept selectedTempCatConcept = Context.getConceptService().getConcept(
			    Integer.parseInt(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_TEMPORARY_ATTRIBUTE)));
			Obs temp = new Obs();
			temp.setConcept(tempCatConcept);
			temp.setValueCoded(selectedTempCatConcept);
			encounter.addObs(temp);
						
			
		}
		
		// create temporary attributes
		for (String name : parameters.keySet()) {
			if ((name.contains(".attribute.")) && (!StringUtils.isBlank(parameters.get(name)))) {
				String[] parts = name.split("\\.");
				String idText = parts[parts.length - 1];
				Integer id = Integer.parseInt(idText);
			
				//ghanshyam  20-may-2013 #1648 capture Health ID and Registration Fee Type
				Concept concept = Context.getConceptService().getConcept(id);
				String conname=concept.getName().toString();
				
				if(conname.equals("REGISTRATION FEE")){
					Obs registrationFeeAttribute = new Obs();
					registrationFeeAttribute.setConcept(concept);
					registrationFeeAttribute .setValueAsString(parameters.get(name));
					encounter.addObs(registrationFeeAttribute);
				}
				
				if(conname.equals("REGISTRATION FEE FREE REASON")){
					Obs registrationFeeFreeReasonAttribute = new Obs();
					registrationFeeFreeReasonAttribute.setConcept(concept);
					registrationFeeFreeReasonAttribute.setValueAsString(parameters.get(name));
					encounter.addObs(registrationFeeFreeReasonAttribute);
				}
				
			/*	if(conname.equals("TEMPORARY CATEGORY")){
					Obs temporaryAttribute = new Obs();
					temporaryAttribute.setConcept(concept);
					temporaryAttribute.setValueAsString(parameters.get(name));
					encounter.addObs(temporaryAttribute);
				}*/
				
			}
		}
		
		// save encounter
		Context.getEncounterService().saveEncounter(encounter);
		logger.info(String.format("Save encounter for the visit of patient [encounterId=%s, patientId=%s]",
		    encounter.getId(), patient.getId()));
		
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out = response.getWriter();
		out.print("success");
	}
	
}
