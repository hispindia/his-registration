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
import java.math.BigDecimal;
import java.util.Collection;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.DocumentException;
import org.jaxen.JaxenException;
import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.Order;
import org.openmrs.OrderType;
import org.openmrs.Patient;
import org.openmrs.PatientIdentifier;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonName;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.PatientDrugHistory;
import org.openmrs.module.hospitalcore.model.PatientFamilyHistory;
import org.openmrs.module.hospitalcore.model.PatientPersonalHistory;
import org.openmrs.module.hospitalcore.util.GlobalPropertyUtil;
import org.openmrs.module.hospitalcore.util.HospitalCoreConstants;
import org.openmrs.module.hospitalcore.util.HospitalCoreUtils;
import org.openmrs.module.hospitalcore.util.OrderUtil;
import org.openmrs.module.registration.RegistrationService;
import org.openmrs.module.registration.includable.validator.attribute.PatientAttributeValidatorService;
import org.openmrs.module.registration.model.RegistrationFee;
import org.openmrs.module.registration.util.RegistrationConstants;
import org.openmrs.module.registration.util.RegistrationUtils;
import org.openmrs.module.registration.web.controller.util.RegistrationWebUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller("RegistrationFindCreatePatientController")
@RequestMapping("/module/registration/findCreatePatient.form")
public class FindCreatePatientController {
	
	private static Log logger = LogFactory.getLog(FindCreatePatientController.class);
	
	@RequestMapping(method = RequestMethod.GET)
	public String showForm(HttpServletRequest request, Model model) throws JaxenException, DocumentException, IOException {
		model.addAttribute("patientIdentifier", RegistrationUtils.getNewIdentifier());
		model.addAttribute("occupations", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_OCCUPATION));
		model.addAttribute("bloodGroups", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_BLOOD_GROUP));
		model.addAttribute("nationalities", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_NATIONALITY));
		model.addAttribute("OPDs", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_OPD_WARD));
		model.addAttribute("TEMPORARYCAT", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_TEMPORARY_CATEGORY));
		model.addAttribute("referralHospitals",
		    RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_PATIENT_REFERRED_FROM));
		model.addAttribute("referralReasons",
		    RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_REASON_FOR_REFERRAL));
		model.addAttribute("paidCategories", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_PAID_CATEGORY));
		Concept conceptPaidCategory=Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_PAID_CATEGORY);
		Map<String,String> subPaidCategoryMap=new LinkedHashMap<String,String>();
		Collection<ConceptAnswer> conAns=conceptPaidCategory.getAnswers();
		for(ConceptAnswer con:conAns){
			if(con.getAnswerConcept().getAnswers().size()!=0)
			subPaidCategoryMap.put(con.getAnswerConcept().getConceptId().toString(), RegistrationWebUtils.getSubConcepts(con.getAnswerConcept().getName().getName()));
		    }
		model.addAttribute("subPaidCategoryMap",subPaidCategoryMap);
		model.addAttribute("programs", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_PROGRAMS));
		Concept conceptPrograms=Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_PROGRAMS);
		Map<String,String> subProgramsCategoryMap=new LinkedHashMap<String,String>();
		Collection<ConceptAnswer> conAnsForPrograms=conceptPrograms.getAnswers();
		for(ConceptAnswer con:conAnsForPrograms){
			if(con.getAnswerConcept().getAnswers().size()!=0)
				subProgramsCategoryMap.put(con.getAnswerConcept().getConceptId().toString(), RegistrationWebUtils.getSubConcepts(con.getAnswerConcept().getName().getName()));
		    }
		model.addAttribute("subProgramsCategoryMap",subProgramsCategoryMap);
		String registrationFee=GlobalPropertyUtil.getString("registration.registrationFee", "0");
		List<String> regFee=new LinkedList<String>();
		regFee.add("Select");
		regFee.add(registrationFee);
		regFee.add("Free");
		regFee.add("50% Discount");
		regFee.add("Credit");
		model.addAttribute("regFees",regFee);
		RegistrationWebUtils.getAddressData(model);
		return "/module/registration/patient/findCreatePatient";
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public String savePatient(HttpServletRequest request, Model model) throws IOException {
		
		// list all parameter submitted
		Map<String, String> parameters = RegistrationWebUtils.optimizeParameters(request);
		logger.info("Submited parameters: " + parameters);
		
		Patient patient;
		try {
			// create patient
			patient = generatePatient(parameters);
			patient = Context.getPatientService().savePatient(patient);
			String relativeName=parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_RELATIVE_NAME);
			String relativeId=parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_RELATIVE_ID);
			if (!StringUtils.isBlank(relativeId)) {
				RegistrationUtils.savePatientSearch(patient,relativeName,Integer.parseInt(relativeId));
			}
			else{
				RegistrationUtils.savePatientSearch(patient,relativeName,null);	
			}
			logger.info(String.format("Saved new patient [id=%s]", patient.getId()));
			
			/**
			 * Supported automatic buy a new slip for PUNJAB
			 */
			// Because: If receiption staff forget to click "Buy a new slip", the report will be wrong
			// June 7th 2012 - Thai Chuong
			String hospitalName = GlobalPropertyUtil.getString(HospitalCoreConstants.PROPERTY_HOSPITAL_NAME, "");
			if (!StringUtils.isBlank(hospitalName)) {
				if (hospitalName.equalsIgnoreCase("PUNJAB")) {
					RegistrationFee fee = new RegistrationFee();
					fee.setPatient(patient);
					fee.setCreatedOn(new Date());
					fee.setCreatedBy(Context.getAuthenticatedUser());
					fee.setFee(new BigDecimal(GlobalPropertyUtil.getInteger(RegistrationConstants.PROPERTY_REGISTRATION_FEE,
					    0)));
					Context.getService(RegistrationService.class).saveRegistrationFee(fee);
				}
			}
			
			// create encounter for the visit
			Encounter encounter = createEncounter(patient, parameters);
			encounter = Context.getEncounterService().saveEncounter(encounter);
			logger.info(String.format("Saved encounter for the visit of patient [id=%s, patient=%s]", encounter.getId(),
			    patient.getId()));
			model.addAttribute("status", "success");
			model.addAttribute("patientId", patient.getPatientId());
			model.addAttribute("encounterId", encounter.getId());
		}
		catch (Exception e) {
			
			e.printStackTrace();
			model.addAttribute("status", "error");
			model.addAttribute("message", e.getMessage());
		}
		return "/module/registration/patient/savePatient";
	}
	
	/**
	 * Generate Patient From Parameters
	 * 
	 * @param parameters
	 * @return
	 * @throws Exception
	 */
	private Patient generatePatient(Map<String, String> parameters) throws Exception {
		
		Patient patient = new Patient();
		
		// get person name
		if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_FIRSTNAME))
				&& !StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_LASTNAME))) {
			PersonName personName = RegistrationUtils.getPersonName(null,
			    parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_FIRSTNAME),parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_LASTNAME));
			patient.addName(personName);
		}
		
		// get identifier
		if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_IDENTIFIER))) {
			PatientIdentifier identifier = RegistrationUtils.getPatientIdentifier(parameters
			        .get(RegistrationConstants.FORM_FIELD_PATIENT_IDENTIFIER));
			patient.addIdentifier(identifier);
		}
		
		// get birthdate
		if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_BIRTHDATE))) {
			patient.setBirthdate(RegistrationUtils.parseDate(parameters
			        .get(RegistrationConstants.FORM_FIELD_PATIENT_BIRTHDATE)));
			if (parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_BIRTHDATE_ESTIMATED).contains("true")) {
				patient.setBirthdateEstimated(true);
			}
		}
		
		// get gender
		if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_GENDER))) {
			patient.setGender(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_GENDER));
		}
		
		// get address
		if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_TOWN))) {
			patient.addAddress(RegistrationUtils.getPersonAddress(null,
			    parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_POSTALADDRESS),
			    parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_TOWN),
			    parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_SETTLEMENT)));
		}
		
		// get custom person attribute
		PatientAttributeValidatorService validator = new PatientAttributeValidatorService();
		Map<String, Object> validationParameters = HospitalCoreUtils.buildParameters("patient", patient, "attributes",
		    parameters);
		String validateResult = validator.validate(validationParameters);
		logger.info("Attirubte validation: " + validateResult);
		if (StringUtils.isBlank(validateResult)) {
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
					else if(attribute.getAttributeType().getId()==30 && parameters.get(RegistrationConstants.FORM_FIELD_CREDIT).equals("Credit")){
						String regitFeeDefault=GlobalPropertyUtil.getString("registration.registrationFee", "0");
						Integer regitFeeInInteger=Integer.parseInt(regitFeeDefault);
						attribute.setValue(regitFeeInInteger.toString(regitFeeInInteger));
					}
					patient.addAttribute(attribute);
				}
			}
		} else {
			throw new Exception(validateResult);
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
		
		PersonAttribute perAttri=new PersonAttribute();
		if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_SUB_CATEGORY_PAID))) {
			perAttri.setPerson(patient);	
			perAttri.setValue(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_SUB_CATEGORY_PAID));
			perAttri.setAttributeType(Context.getPersonService().getPersonAttributeType(31));
			perAttri.setCreator(Context.getUserContext().getAuthenticatedUser());
			perAttri.setDateCreated(new Date());
			perAttri.setVoided(false);
			patient.addAttribute(perAttri);
		}
		else if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT__SUB_CATEGORY_PROGRAM))) {
			perAttri.setPerson(patient);	
			perAttri.setValue(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT__SUB_CATEGORY_PROGRAM));
			perAttri.setAttributeType(Context.getPersonService().getPersonAttributeType(31));
			perAttri.setCreator(Context.getUserContext().getAuthenticatedUser());
			perAttri.setDateCreated(new Date());
			perAttri.setVoided(false);
			patient.addAttribute(perAttri);
		}
		
		return patient;
	}
	
	/**
	 * Create Encouunter For The Visit Of Patient
	 * 
	 * @param patient
	 * @param parameters
	 * @return
	 */
	private Encounter createEncounter(Patient patient, Map<String, String> parameters) {
		
		Encounter encounter = RegistrationWebUtils.createEncounter(patient, false);
		
		/*
		 * ADD OPD ROOM
		 */
		Concept opdWardConcept = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_OPD_WARD);
		Concept selectedOPDConcept = Context.getConceptService().getConcept(
		    Integer.parseInt(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_OPD_WARD)));
		Obs opdObs = new Obs();
		opdObs.setConcept(opdWardConcept);
		opdObs.setValueCoded(selectedOPDConcept);
		encounter.addObs(opdObs);
		
		Concept cnrf = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_REGISTRATION_FEE);
		Concept cnc = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_CREDIT);
		Concept cnp = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NEW_PATIENT);
		Obs obsn = new Obs();
		obsn.setConcept(cnrf);
		obsn.setValueCoded(cnp);
		
		Obs obs = new Obs();
		obs.setConcept(cnc);
		obs.setValueCoded(cnp);
		
		if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_PAID_CATEGORY))) {
			obsn.setValueText(parameters
					.get(RegistrationConstants.FORM_FIELD_PATIENT_PAID_CATEGORY));	
			obs.setValueText(parameters
					.get(RegistrationConstants.FORM_FIELD_PATIENT_PAID_CATEGORY));	
		}
		else{
			obsn.setValueText(parameters
					.get(RegistrationConstants.FORM_FIELD_PATIENT_PROGRAM_CATEGORY));
			obs.setValueText(parameters
					.get(RegistrationConstants.FORM_FIELD_PATIENT_PROGRAM_CATEGORY));
		}
		
		if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_SUB_CATEGORY_PAID))) {
			obsn.setComment(parameters
					.get(RegistrationConstants.FORM_FIELD_PATIENT_SUB_CATEGORY_PAID));	
			obs.setComment(parameters
					.get(RegistrationConstants.FORM_FIELD_PATIENT_SUB_CATEGORY_PAID));	
		}
		else if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT__SUB_CATEGORY_PROGRAM))) {
			obsn.setComment(parameters
					.get(RegistrationConstants.FORM_FIELD_PATIENT__SUB_CATEGORY_PROGRAM));
			obs.setComment(parameters
					.get(RegistrationConstants.FORM_FIELD_PATIENT__SUB_CATEGORY_PROGRAM));	
		}
		
		if(!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_REGISTRATION_FEE))&&parameters.get(RegistrationConstants.FORM_FIELD_REGISTRATION_FEE).equals("50% Discount")){
			String regitFeeDefault=GlobalPropertyUtil.getString("registration.registrationFee", "0");
			Integer regitFeeInInteger=Integer.parseInt(regitFeeDefault);
			Double discountedRegFee=(double) (regitFeeInInteger/2);
			obsn.setValueNumeric(discountedRegFee);
			encounter.addObs(obsn);	
		}
		else if(!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_REGISTRATION_FEE))&&parameters.get(RegistrationConstants.FORM_FIELD_REGISTRATION_FEE).equals("Free")){
			Integer regitFeeInInteger=0;
			Double discountedRegFee=(double) (regitFeeInInteger);
			obsn.setValueNumeric(discountedRegFee);	
			encounter.addObs(obsn);	
		}
		else if(!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_REGISTRATION_FEE))){
			String regitFeeDefault=GlobalPropertyUtil.getString("registration.registrationFee", "0");
			Integer regitFeeInInteger=Integer.parseInt(regitFeeDefault);
			Double discountedRegFee=(double) (regitFeeInInteger);
			obsn.setValueNumeric(discountedRegFee);	
			encounter.addObs(obsn);	
		}
		
		if(!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_CREDIT))&&parameters.get(RegistrationConstants.FORM_FIELD_CREDIT).equals("Credit")){
			String regitFeeDefault=GlobalPropertyUtil.getString("registration.registrationFee", "0");
			Integer regitFeeInInteger=Integer.parseInt(regitFeeDefault);
			Double discountedRegFee=(double) (regitFeeInInteger);
			obs.setValueNumeric(discountedRegFee);	
			encounter.addObs(obs);	
		}
		
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
		
		 String bloodBankWardName = GlobalPropertyUtil.getString(RegistrationConstants.PROPERTY_BLOODBANK_OPDWARD_NAME,
		    "Blood Bank Room");

		 String socn=new String(selectedOPDConcept.getName().toString());
		 String substringofsocn=socn.substring(0,15);
		
		 if (!substringofsocn.equalsIgnoreCase(bloodBankWardName)) {
			RegistrationWebUtils.sendPatientToOPDQueue(patient, selectedOPDConcept, false);
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
		 //Patient history
			PatientQueueService queueService = (PatientQueueService) Context.getService(PatientQueueService.class);

			PatientDrugHistory patientdrug= new PatientDrugHistory();
			patientdrug.setCreatedOn(new Date());
			patientdrug.setPatientId(patient.getPatientId());
			queueService.savePatientDrugHistory(patientdrug);
			PatientFamilyHistory patientfamily= new PatientFamilyHistory();
		    patientfamily.setCreatedOn(new Date());
			patientfamily.setPatientId(patient.getPatientId());
			queueService.savePatientFamilyHistory(patientfamily);
			PatientPersonalHistory patientperson= new PatientPersonalHistory();
			patientperson.setCreatedOn(new Date());
			patientperson.setPatientId(patient.getPatientId());
			queueService.savePatientPersonalHistory(patientperson);
		
		/*
		 * REFERRAL INFORMATION
		 */
		Obs referralObs = new Obs();
		Concept referralConcept = Context.getConceptService().getConcept(
		    RegistrationConstants.CONCEPT_NAME_PATIENT_REFERRED_TO_HOSPITAL);
		referralObs.setConcept(referralConcept);
		encounter.addObs(referralObs);
		if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_REFERRED))) {
			referralObs.setValueCoded(Context.getConceptService().getConcept("YES"));
			
			// referred from
			Obs referredFromObs = new Obs();
			Concept referredFromConcept = Context.getConceptService().getConcept(
			    RegistrationConstants.CONCEPT_NAME_PATIENT_REFERRED_FROM);
			referredFromObs.setConcept(referredFromConcept);
			referredFromObs.setValueCoded(Context.getConceptService().getConcept(
			    Integer.parseInt(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_REFERRED_FROM))));
			encounter.addObs(referredFromObs);
			
			// referred reason
			Obs referredReasonObs = new Obs();
			Concept referredReasonConcept = Context.getConceptService().getConcept(
			    RegistrationConstants.CONCEPT_NAME_REASON_FOR_REFERRAL);
			referredReasonObs.setConcept(referredReasonConcept);
			referredReasonObs.setValueCoded(Context.getConceptService().getConcept(
			    Integer.parseInt(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_REFERRED_REASON))));
			encounter.addObs(referredReasonObs);
		} else {
			referralObs.setValueCoded(Context.getConceptService().getConcept("NO"));
		}
		return encounter;
	}
	
}
