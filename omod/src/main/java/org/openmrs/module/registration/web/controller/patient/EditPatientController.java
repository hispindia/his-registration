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
import java.text.ParseException;
import java.util.Date;
import java.util.LinkedHashMap;
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
import org.openmrs.Patient;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonAttributeType;
import org.openmrs.PersonName;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.model.PatientSearch;
import org.openmrs.module.hospitalcore.util.HospitalCoreUtils;
import org.openmrs.module.registration.includable.validator.attribute.PatientAttributeValidatorService;
import org.openmrs.module.registration.util.RegistrationConstants;
import org.openmrs.module.registration.util.RegistrationUtils;
import org.openmrs.module.registration.web.controller.util.PatientModel;
import org.openmrs.module.registration.web.controller.util.RegistrationWebUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller("RegistrationEditPatientController")
@RequestMapping("/module/registration/editPatient.form")
public class EditPatientController {
	
	private static Log logger = LogFactory.getLog(EditPatientController.class);
	
	@RequestMapping(method = RequestMethod.GET)
	public String showForm(@RequestParam("patientId") Integer patientId, Model model) throws JaxenException,
	    DocumentException, IOException, ParseException {
		HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
		model.addAttribute("occupations", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_OCCUPATION));
		model.addAttribute("bloodGroups", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_BLOOD_GROUP));
		model.addAttribute("nationalities", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_NATIONALITY));
		Patient patient = Context.getPatientService().getPatient(patientId);
		PatientModel patientModel = new PatientModel(patient);
		PatientSearch patSearch=hcs.getPatient(patientId);
		model.addAttribute("patient", patientModel);
		model.addAttribute("patSearch", patSearch);
		RegistrationWebUtils.getAddressData(model);
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
		return "/module/registration/patient/editPatient";
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public String savePatient(@RequestParam("patientId") Integer patientId, HttpServletRequest request, Model model)
	    throws ParseException {
		
		Patient patient = Context.getPatientService().getPatient(patientId);
		
		// list all parameter submitted
		Map<String, String> parameters = RegistrationWebUtils.optimizeParameters(request);
		logger.info("Submited parameters: " + parameters);
		
		try {
			// update patient
			Patient updatedPatient = generatePatient(patient, parameters);
			patient = Context.getPatientService().savePatient(updatedPatient);
			
			// update patient attribute
			updatedPatient = setAttributes(patient, parameters);
			patient = Context.getPatientService().savePatient(updatedPatient);
			String relativeName=parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_RELATIVE_NAME);
			String relativeId=parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_RELATIVE_ID);
			if (!StringUtils.isBlank(relativeId)) {
				RegistrationUtils.savePatientSearch(patient,relativeName,Integer.parseInt(relativeId));
			}
			else{
				RegistrationUtils.savePatientSearch(patient,relativeName,null);	
			}
			
			model.addAttribute("status", "success");
			logger.info(String.format("Updated patient [id=%s]", patient.getId()));
		}
		catch (Exception e) {
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
	 * @throws ParseException
	 */
	private Patient generatePatient(Patient patient, Map<String, String> parameters) throws ParseException {
		
		// get person name
		if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_FIRSTNAME))
				&& !StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_LASTNAME))) {
			PersonName personName = RegistrationUtils.getPersonName(null,
			    parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_FIRSTNAME),parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_LASTNAME));
			patient.addName(personName);
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
		
		PersonAttribute perAttr=new PersonAttribute();
		if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_PAID_CATEGORY))) {
			perAttr.setPerson(patient);	
			perAttr.setValue(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_PAID_CATEGORY));
			perAttr.setAttributeType(Context.getPersonService().getPersonAttributeType(14));
			perAttr.setCreator(Context.getUserContext().getAuthenticatedUser());
			perAttr.setDateCreated(new Date());
		}
		else if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_PROGRAM_CATEGORY))) {
			perAttr.setPerson(patient);	
			perAttr.setValue(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_PROGRAM_CATEGORY));
			perAttr.setAttributeType(Context.getPersonService().getPersonAttributeType(14));
			perAttr.setCreator(Context.getUserContext().getAuthenticatedUser());
			perAttr.setDateCreated(new Date());
		}
		
		patient.addAttribute(perAttr);
		
		return patient;
	}
	
	private Patient setAttributes(Patient patient, Map<String, String> attributes) throws Exception {
		PatientAttributeValidatorService validator = new PatientAttributeValidatorService();
		Map<String, Object> parameters = HospitalCoreUtils.buildParameters("patient", patient, "attributes", attributes);
		String validateResult = validator.validate(parameters);
		logger.info("Attirubte validation: " + validateResult);
		if (StringUtils.isBlank(validateResult)) {
			for (String name : attributes.keySet()) {
				if ((name.contains(".attribute.")) && (!StringUtils.isBlank(attributes.get(name)))) {
					String[] parts = name.split("\\.");
					String idText = parts[parts.length - 1];
					Integer id = Integer.parseInt(idText);
					PersonAttribute attribute = RegistrationUtils.getPersonAttribute(id, attributes.get(name));
					patient.addAttribute(attribute);
				}
			}
		} else {
			throw new Exception(validateResult);
		}
		
		return patient;
	}
}
