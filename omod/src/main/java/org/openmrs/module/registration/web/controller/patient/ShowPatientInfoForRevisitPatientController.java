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
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.Order;
import org.openmrs.OrderType;
import org.openmrs.Patient;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonAttributeType;
import org.openmrs.User;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.OpdPatientQueueLog;
import org.openmrs.module.hospitalcore.util.GlobalPropertyUtil;
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

@Controller("RegistrationShowPatientInfoForRevisitPatientController")
@RequestMapping("/module/registration/showPatientInfoForRevisitPatient.form")
public class ShowPatientInfoForRevisitPatientController {
	
	private static Log logger = LogFactory.getLog(ShowPatientInfoController.class);
	
	@RequestMapping(method = RequestMethod.GET)
	public String showPatientInfo(@RequestParam("patientId") Integer patientId,
	                              @RequestParam(value = "encounterId", required = false) Integer encounterId,
	                              @RequestParam(value = "reprint", required = false) Boolean reprint, Model model)
	                                                                                                              throws IOException,
	                                                                                                              ParseException {
		
		HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
		Patient patient = Context.getPatientService().getPatient(patientId);
		PatientModel patientModel = new PatientModel(patient);
		model.addAttribute("patient", patientModel);
		model.addAttribute("OPDs", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_OPD_WARD));
		model.addAttribute("TEMPORARYCATEGORY", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_TEMPORARY_CATEGORY));
		
		// Get current date
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
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
			Encounter encounter = Context.getEncounterService().getEncounter(encounterId);
			for (Obs obs : encounter.getObs()) {
				if (obs.getConcept().getName().getName().equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_TEMPORARY_CATEGORY)) {
					model.addAttribute("selectedTemporaryCategory", obs.getValueCoded().getName().getName());
				}
				else if (obs.getConcept().getName().getName().equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_OPD_WARD)) {
					model.addAttribute("selectedOPD", obs.getValueCoded().getConceptId());
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
						model.addAttribute("tempCategoryId", obs.getValueCoded().getConceptId());
						model.addAttribute("tempCategoryConceptName", obs.getValueCoded().getName().getName());
					} else if (obs.getConcept().getDisplayString()
					        .equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_OPD_WARD)) {
						model.addAttribute("opdWardId", obs.getConcept().getConceptId());
					}
					observations.put(obs.getConcept().getConceptId(), ObsUtils.getValueAsString(obs));
				}
				model.addAttribute("observations", observations);
			}
		}
		
		model.addAttribute("OTHERFREE", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_OTHER_FREE));
		List<PersonAttribute> pas = hcs.getPersonAttributes(patientId);
		for (PersonAttribute pa : pas) {
			PersonAttributeType attributeType = pa.getAttributeType();
			if (attributeType.getPersonAttributeTypeId() == 19) {
				model.addAttribute("selectedOtherFree", pa.getValue());
			}
		}
		
		model.addAttribute("paidCategories", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_PAID_CATEGORY));
		model.addAttribute("programs", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_PROGRAMS));
		Map<String, String> paidCategoryMap = new LinkedHashMap<String, String>();
		Concept paidCategory = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_PAID_CATEGORY);
		for (ConceptAnswer ca : paidCategory.getAnswers()) {
			paidCategoryMap.put(ca.getAnswerConcept().getConceptId().toString(), ca.getAnswerConcept().getName().getName());
		}
		Map<String, String> programMap = new LinkedHashMap<String, String>();
		Concept program = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_PROGRAMS);
		for (ConceptAnswer ca : program.getAnswers()) {
			programMap.put(ca.getAnswerConcept().getConceptId().toString(), ca.getAnswerConcept().getName().getName());
		}
		model.addAttribute("paidCategoryMap", paidCategoryMap);
		model.addAttribute("programMap", programMap);
		
		String registrationFee=GlobalPropertyUtil.getString("registration.registrationFee", "0");
		List<String> regFee=new LinkedList<String>();
		regFee.add("Select");
		regFee.add(registrationFee);
		regFee.add("Free");
		regFee.add("50% Discount");
		model.addAttribute("regFees",regFee);
		
		String hospitalName=GlobalPropertyUtil.getString("hospitalcore.hospitalParticularName", "Kollegal DVT Hospital");
		model.addAttribute("hospitalName", hospitalName);
		
		User user=Context.getAuthenticatedUser();
		model.addAttribute("userName", user.getGivenName());
		
		PatientQueueService patientQueueService = Context.getService(PatientQueueService.class);
		OpdPatientQueueLog opdPatientQueueLog = patientQueueService.getOpdPatientQueueLogByPatientId(patient);
		model.addAttribute("opdPatientQueueLog", opdPatientQueueLog);
		
		Map<Integer, String> attributess = new HashMap<Integer, String>();
		Map<String, PersonAttribute> attributes = patient.getAttributeMap();
		for (String key : attributes.keySet()) {
			attributess.put(attributes.get(key).getAttributeType().getId(), attributes.get(key).getValue());
		}
		model.addAttribute("attributes", attributess);
		return "/module/registration/patient/showPatientInfoForRevisitPatient";
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
			
			// create OPD obs
			Concept opdWardConcept = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_OPD_WARD);
			Concept selectedOPDConcept = Context.getConceptService().getConcept(
			    Integer.parseInt(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_OPD_WARD)));
			Obs opd = new Obs();
			opd.setConcept(opdWardConcept);
			opd.setValueCoded(selectedOPDConcept);
			encounter.addObs(opd);
			
			Concept cnrf = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_REGISTRATION_FEE);
			Concept cnp = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_REVISIT);
			Obs obsn = new Obs();
			obsn.setConcept(cnrf);
			obsn.setValueCoded(cnp);
			if(parameters.get(RegistrationConstants.FORM_FIELD_REGISTRATION_FEE).equals("50% Discount")){
				String regitFeeDefault=GlobalPropertyUtil.getString("registration.registrationFee", "0");
				Integer regitFeeInInteger=Integer.parseInt(regitFeeDefault);
				Double discountedRegFee=(double) (regitFeeInInteger/2);
				obsn.setValueNumeric(discountedRegFee);
			}
			else if(parameters.get(RegistrationConstants.FORM_FIELD_REGISTRATION_FEE).equals("Free")){
				Integer regitFeeInInteger=0;
				Double discountedRegFee=(double) (regitFeeInInteger);
				obsn.setValueNumeric(discountedRegFee);	
			}
			else{
				String regitFeeDefault=GlobalPropertyUtil.getString("registration.registrationFee", "0");
				Integer regitFeeInInteger=Integer.parseInt(regitFeeDefault);
				Double discountedRegFee=(double) (regitFeeInInteger);
				obsn.setValueNumeric(discountedRegFee);	
			}
			if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_PAID_CATEGORY))) {
				obsn.setValueText(parameters
						.get(RegistrationConstants.FORM_FIELD_PATIENT_PAID_CATEGORY));	
			}
			else{
				obsn.setValueText(parameters
						.get(RegistrationConstants.FORM_FIELD_PATIENT_PROGRAM_CATEGORY));		
			}
			encounter.addObs(obsn);	
			
			String bloodBankWardName = GlobalPropertyUtil.getString(RegistrationConstants.PROPERTY_BLOODBANK_OPDWARD_NAME,
			    "Blood Bank Room");
			
			 //ghanshyam 03-sept-2013 Bug #394 [Blood bank]queue
			 String socn=new String(selectedOPDConcept.getName().toString());
			 String substringofsocn=socn.substring(0,15);
			
			 if (!substringofsocn.equalsIgnoreCase(bloodBankWardName)) {
				RegistrationWebUtils.sendPatientToOPDQueue(patient, selectedOPDConcept, true);
			} else {
				OrderType orderType = null;
				String orderTypeName = Context.getAdministrationService().getGlobalProperty("bloodbank.orderTypeName");
				orderType = OrderUtil.getOrderTypeByName(orderTypeName);
				
				Order order = new Order();
				order.setConcept(selectedOPDConcept);
				order.setCreator(Context.getAuthenticatedUser());
				order.setDateCreated(new Date());
				order.setOrderer(Context.getAuthenticatedUser());
				order.setPatient(patient);
				order.setStartDate(new Date());
				order.setAccessionNumber("0");
				order.setOrderType(orderType);
				order.setEncounter(encounter);
				encounter.addOrder(order);
			}
		}
		
		PersonAttribute perAttr=new PersonAttribute();
		if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_PAID_CATEGORY))) {
			perAttr.setPerson(patient);	
			perAttr.setValue(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_PAID_CATEGORY));
			perAttr.setAttributeType(Context.getPersonService().getPersonAttributeType(14));
			perAttr.setCreator(Context.getUserContext().getAuthenticatedUser());
			perAttr.setDateCreated(new Date());
			perAttr.setVoided(false);
		}
		else if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_PROGRAM_CATEGORY))) {
			perAttr.setPerson(patient);	
			perAttr.setValue(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_PROGRAM_CATEGORY));
			perAttr.setAttributeType(Context.getPersonService().getPersonAttributeType(14));
			perAttr.setCreator(Context.getUserContext().getAuthenticatedUser());
			perAttr.setDateCreated(new Date());
			perAttr.setVoided(false);
		}
		
		patient.addAttribute(perAttr);
		
		
		for (String name : parameters.keySet()) {
			if ((name.contains(".attribute.")) && (!StringUtils.isBlank(parameters.get(name)))) {
				String[] parts = name.split("\\.");
				String idText = parts[parts.length - 1];
				Integer id = Integer.parseInt(idText);
				PersonAttribute attribute = RegistrationUtils.getPersonAttribute(id, parameters.get(name));
				if(attribute.getAttributeType().getId()==28 && parameters.get(RegistrationConstants.FORM_FIELD_REGISTRATION_FEE).equals("50% Discount")){
					String regitFeeDefault=GlobalPropertyUtil.getString("registration.registrationFee", "0");
					Integer regitFeeInInteger=Integer.parseInt(regitFeeDefault);
					Float discountedRegFee=(float) (regitFeeInInteger/2);
					attribute.setValue(discountedRegFee.toString(discountedRegFee));
				}
				else if(attribute.getAttributeType().getId()==28 && parameters.get(RegistrationConstants.FORM_FIELD_REGISTRATION_FEE).equals("Free")){
					attribute.setValue("0");
				}
				patient.addAttribute(attribute);
			}
		}
		
		patient = Context.getPatientService().savePatient(patient);
		
		Concept temporaryCategoryConcept = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_TEMPORARY_CATEGORY);
		String selectedTemporaryCategory=parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_TEMPORARY_CATEGORY);
		if(!selectedTemporaryCategory.equals(" ")){
		Concept selectedTemporaryCategoryCon = Context.getConceptService().getConcept(
		Integer.parseInt(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_TEMPORARY_CATEGORY)));
		Obs temporaryCategoryObs = new Obs();
		temporaryCategoryObs.setConcept(temporaryCategoryConcept);
		temporaryCategoryObs.setValueCoded(selectedTemporaryCategoryCon);
		encounter.addObs(temporaryCategoryObs);
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
