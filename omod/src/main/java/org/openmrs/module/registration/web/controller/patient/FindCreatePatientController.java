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
import java.util.Date;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.DocumentException;
import org.jaxen.JaxenException;
import org.openmrs.Concept;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.PatientIdentifier;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonName;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.util.GlobalPropertyUtil;
import org.openmrs.module.hospitalcore.util.HospitalCoreConstants;
import org.openmrs.module.hospitalcore.util.HospitalCoreUtils;
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
@RequestMapping("/findPatient.htm")
public class FindCreatePatientController {

	private static Log logger = LogFactory
			.getLog(FindCreatePatientController.class);

	@RequestMapping(method = RequestMethod.GET)
	public String showForm(HttpServletRequest request, Model model)
			throws JaxenException, DocumentException, IOException {
		model.addAttribute("patientIdentifier",
				RegistrationUtils.getNewIdentifier());
		model.addAttribute(
				"referralHospitals",
				RegistrationWebUtils
						.getSubConcepts(RegistrationConstants.CONCEPT_NAME_PATIENT_REFERRED_FROM));
		model.addAttribute(
				"referralReasons",
				RegistrationWebUtils
						.getSubConcepts(RegistrationConstants.CONCEPT_NAME_REASON_FOR_REFERRAL));
		RegistrationWebUtils.getAddressData(model);
		// model.addAttribute("OPDs",
		// RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_OPD_WARD));
		// ghanshyam,16-dec-2013,3438 Remove the interdependency
		model.addAttribute(
				"TEMPORARYCAT",
				RegistrationWebUtils
						.getSubConcepts(RegistrationConstants.CONCEPT_NAME_TEMPORARY_CATEGORY));
		String triageEnabled = Context.getAdministrationService()
				.getGlobalProperty("registration.triageEnabled");
		if (triageEnabled.equalsIgnoreCase("true")) {
			model.addAttribute("TRIAGE", RegistrationWebUtils
					.getSubConcepts(RegistrationConstants.CONCEPT_NAME_TRIAGE));
			return "/module/registration/patient/findCreatePatientForTriage";
		} else {
			model.addAttribute(
					"TRIAGE",
					RegistrationWebUtils
							.getSubConcepts(RegistrationConstants.CONCEPT_NAME_OPD_WARD));
			return "/module/registration/patient/findCreatePatientForOPD";
		}

	}

	@RequestMapping(method = RequestMethod.POST)
	public String savePatient(HttpServletRequest request, Model model)
			throws IOException {

		// list all parameter submitted
		Map<String, String> parameters = RegistrationWebUtils
				.optimizeParameters(request);
		logger.info("Submited parameters: " + parameters);

		Patient patient;
		try {
			// create patient
			patient = generatePatient(parameters);
			patient = Context.getPatientService().savePatient(patient);
			RegistrationUtils.savePatientSearch(patient);
			logger.info(String.format("Saved new patient [id=%s]",
					patient.getId()));

			/**
			 * Supported automatic buy a new slip for PUNJAB
			 */
			// Because: If receiption staff forget to click "Buy a new slip",
			// the report will be wrong
			// June 7th 2012 - Thai Chuong
			String hospitalName = GlobalPropertyUtil.getString(
					HospitalCoreConstants.PROPERTY_HOSPITAL_NAME, "");
			if (!StringUtils.isBlank(hospitalName)) {
				if (hospitalName.equalsIgnoreCase("PUNJAB")) {
					RegistrationFee fee = new RegistrationFee();
					fee.setPatient(patient);
					fee.setCreatedOn(new Date());
					fee.setCreatedBy(Context.getAuthenticatedUser());
					fee.setFee(new BigDecimal(
							GlobalPropertyUtil
									.getInteger(
											RegistrationConstants.PROPERTY_INITIAL_REGISTRATION_FEE,
											0)));
					Context.getService(RegistrationService.class)
							.saveRegistrationFee(fee);
				}
			}

			// create encounter for the visit
			Encounter encounter = createEncounter(patient, parameters);
			encounter = Context.getEncounterService().saveEncounter(encounter);
			logger.info(String
					.format("Saved encounter for the visit of patient [id=%s, patient=%s]",
							encounter.getId(), patient.getId()));
			model.addAttribute("status", "success");
			model.addAttribute("patientId", patient.getPatientId());
			model.addAttribute("encounterId", encounter.getId());
		} catch (Exception e) {

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
	private Patient generatePatient(Map<String, String> parameters)
			throws Exception {

		Patient patient = new Patient();

		// get person name
		if (!StringUtils.isBlank(parameters
				.get(RegistrationConstants.FORM_FIELD_PATIENT_SURNAME))
				&& !StringUtils
						.isBlank(parameters
								.get(RegistrationConstants.FORM_FIELD_PATIENT_FIRSTNAME))) {
			PersonName personName = RegistrationUtils
					.getPersonName(
							null,
							parameters
									.get(RegistrationConstants.FORM_FIELD_PATIENT_SURNAME),
							parameters
									.get(RegistrationConstants.FORM_FIELD_PATIENT_FIRSTNAME),
							parameters
									.get(RegistrationConstants.FORM_FIELD_PATIENT_GIVENNAME),
							parameters
									.get(RegistrationConstants.FORM_FIELD_PATIENT_OTHERNAME));
			patient.addName(personName);
		}

		// get identifier
		if (!StringUtils.isBlank(parameters
				.get(RegistrationConstants.FORM_FIELD_PATIENT_IDENTIFIER))) {
			PatientIdentifier identifier = RegistrationUtils
					.getPatientIdentifier(parameters
							.get(RegistrationConstants.FORM_FIELD_PATIENT_IDENTIFIER));
			patient.addIdentifier(identifier);
		}

		// get birthdate
		if (!StringUtils.isBlank(parameters
				.get(RegistrationConstants.FORM_FIELD_PATIENT_BIRTHDATE))) {
			patient.setBirthdate(RegistrationUtils.parseDate(parameters
					.get(RegistrationConstants.FORM_FIELD_PATIENT_BIRTHDATE)));
			if (parameters
					.get(RegistrationConstants.FORM_FIELD_PATIENT_BIRTHDATE_ESTIMATED)
					.contains("true")) {
				patient.setBirthdateEstimated(true);
			}
		}

		// get gender
		if (!StringUtils.isBlank(parameters
				.get(RegistrationConstants.FORM_FIELD_PATIENT_GENDER))) {
			patient.setGender(parameters
					.get(RegistrationConstants.FORM_FIELD_PATIENT_GENDER));
		}

		// get address
		if (!StringUtils
				.isBlank(parameters
						.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_DISTRICT))) {
			patient.addAddress(RegistrationUtils.getPersonAddress(
					null,
					parameters
							.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_POSTALADDRESS),
					parameters
							.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_DISTRICT),
					/*
					 * Ghanshyam - Sagar : date- 15 Dec, 2012. Redmine issue's
					 * for Bangladesh : #510 and #511 and #512 changes tehsil to
					 * upazila
					 */
					parameters
							.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_UPAZILA)));
		}

		// get custom person attribute
		PatientAttributeValidatorService validator = new PatientAttributeValidatorService();
		Map<String, Object> validationParameters = HospitalCoreUtils
				.buildParameters("patient", patient, "attributes", parameters);
		String validateResult = validator.validate(validationParameters);
		logger.info("Attirubte validation: " + validateResult);
		if (StringUtils.isBlank(validateResult)) {
			for (String name : parameters.keySet()) {
				if ((name.contains(".attribute."))
						&& (!StringUtils.isBlank(parameters.get(name)))) {
					String[] parts = name.split("\\.");
					String idText = parts[parts.length - 1];
					Integer id = Integer.parseInt(idText);
					PersonAttribute attribute = RegistrationUtils
							.getPersonAttribute(id, parameters.get(name));
					patient.addAttribute(attribute);
				}
			}
		} else {
			throw new Exception(validateResult);
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
	private Encounter createEncounter(Patient patient,
			Map<String, String> parameters) {

		Encounter encounter = RegistrationWebUtils.createEncounter(patient,
				false);

		/*
		 * ADD OPD ROOM
		 */
		// ghanshyam,16-dec-2013,3438 Remove the interdependency
		String triageEnabled = Context.getAdministrationService()
				.getGlobalProperty("registration.triageEnabled");
		if (triageEnabled.equalsIgnoreCase("true")) {
			Concept triageConcept = Context.getConceptService().getConcept(
					RegistrationConstants.CONCEPT_NAME_TRIAGE);

			Concept selectedTRIAGEConcept = Context
					.getConceptService()
					.getConcept(
							parameters
									.get(RegistrationConstants.FORM_FIELD_PATIENT_TRIAGE));
			Obs triageObs = new Obs();
			triageObs.setConcept(triageConcept);
			triageObs.setValueCoded(selectedTRIAGEConcept);
			encounter.addObs(triageObs);

			RegistrationWebUtils.sendPatientToTriageQueue(patient,
					selectedTRIAGEConcept, false);
		} else {
			Concept opdConcept = Context.getConceptService().getConcept(
					RegistrationConstants.CONCEPT_NAME_OPD_WARD);

			Concept selectedOPDConcept = Context
					.getConceptService()
					.getConcept(
							parameters
									.get(RegistrationConstants.FORM_FIELD_PATIENT_OPD_WARD));
			Obs opdObs = new Obs();
			opdObs.setConcept(opdConcept);
			opdObs.setValueCoded(selectedOPDConcept);
			encounter.addObs(opdObs);

			RegistrationWebUtils.sendPatientToOPDQueue(patient,
					selectedOPDConcept, false);
		}

		Concept tempCatConcept = Context.getConceptService().getConcept(
				RegistrationConstants.CONCEPT_NAME_TEMPORARY_CATEGORY);

		Obs tempCatObs = new Obs();
		if (!StringUtils
				.isBlank(parameters
						.get(RegistrationConstants.FORM_FIELD_PATIENT_TEMPORARY_ATTRIBUTE))) {
			Concept selectedTempCatConcept = Context
					.getConceptService()
					.getConcept(
							parameters
									.get(RegistrationConstants.FORM_FIELD_PATIENT_TEMPORARY_ATTRIBUTE));
			tempCatObs.setConcept(tempCatConcept);
			tempCatObs.setValueCoded(selectedTempCatConcept);
			encounter.addObs(tempCatObs);
		} else {
			tempCatObs.setConcept(tempCatConcept);
			tempCatObs.setValueCoded(Context.getConceptService().getConcept(
					"NO"));
			encounter.addObs(tempCatObs);
		}
		/*
		 * REFERRAL INFORMATION
		 */
		Obs referralObs = new Obs();
		Concept referralConcept = Context
				.getConceptService()
				.getConcept(
						RegistrationConstants.CONCEPT_NAME_PATIENT_REFERRED_TO_HOSPITAL);
		referralObs.setConcept(referralConcept);
		encounter.addObs(referralObs);
		if (!StringUtils.isBlank(parameters
				.get(RegistrationConstants.FORM_FIELD_PATIENT_REFERRED))) {
			referralObs.setValueCoded(Context.getConceptService().getConcept(
					"YES"));

			// referred from
			Obs referredFromObs = new Obs();
			Concept referredFromConcept = Context
					.getConceptService()
					.getConcept(
							RegistrationConstants.CONCEPT_NAME_PATIENT_REFERRED_FROM);
			referredFromObs.setConcept(referredFromConcept);
			referredFromObs
					.setValueCoded(Context
							.getConceptService()
							.getConcept(
									Integer.parseInt(parameters
											.get(RegistrationConstants.FORM_FIELD_PATIENT_REFERRED_FROM))));
			encounter.addObs(referredFromObs);

			// referred reason
			Obs referredReasonObs = new Obs();
			Concept referredReasonConcept = Context
					.getConceptService()
					.getConcept(
							RegistrationConstants.CONCEPT_NAME_REASON_FOR_REFERRAL);
			referredReasonObs.setConcept(referredReasonConcept);
			referredReasonObs
					.setValueCoded(Context
							.getConceptService()
							.getConcept(
									Integer.parseInt(parameters
											.get(RegistrationConstants.FORM_FIELD_PATIENT_REFERRED_REASON))));
			referredReasonObs.setValueText(RegistrationConstants.FORM_FIELD_PATIENT_REFERRED_DESCRIPTION);
			encounter.addObs(referredReasonObs);
		} else {
			referralObs.setValueCoded(Context.getConceptService().getConcept(
					"NO"));
		}
		return encounter;
	}

}
