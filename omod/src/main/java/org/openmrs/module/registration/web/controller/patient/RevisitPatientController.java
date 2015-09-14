package org.openmrs.module.registration.web.controller.patient;

import java.io.IOException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.DocumentException;
import org.jaxen.JaxenException;
import org.openmrs.Patient;
import org.openmrs.PatientIdentifier;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonName;
import org.openmrs.module.hospitalcore.util.HospitalCoreUtils;
import org.openmrs.module.registration.includable.validator.attribute.PatientAttributeValidatorService;
import org.openmrs.module.registration.util.RegistrationConstants;
import org.openmrs.module.registration.util.RegistrationUtils;
import org.openmrs.module.registration.web.controller.util.RegistrationWebUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller("RevisitPatientController")
@RequestMapping("/module/registration/revisitPatient.form")
public class RevisitPatientController {
	private static Log logger = LogFactory.getLog(RevisitPatientController.class);
	@RequestMapping(method = RequestMethod.GET)
	public String showForm(HttpServletRequest request, Model model) throws JaxenException, DocumentException, IOException {
		model.addAttribute("patientIdentifier", RegistrationUtils.getNewIdentifier());
		
		/*model.addAttribute("referralHospitals",
		    RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_PATIENT_REFERRED_FROM));
		model.addAttribute("referralReasons",
		   RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_REASON_FOR_REFERRAL));*/
		RegistrationWebUtils.getAddressData(model);
		
		return "/module/registration/patient/revisitPatient";
}
	
private Patient generatePatient(Map<String, String> parameters) throws Exception {
		
		Patient patient = new Patient();
		
		// get person name
		if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_NAME))) {
			PersonName personName = RegistrationUtils.getPersonName(null,
			    parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_NAME));
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
		if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_POSTALADDRESS))) {
			patient.addAddress(RegistrationUtils.getPersonAddress(null,
			    parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_POSTALADDRESS)));
			  // parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_DISTRICT),
			  // parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_TEHSIL)));
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
					patient.addAttribute(attribute);
				}
			}
		} else {
			throw new Exception(validateResult);
		}
		
		return patient;
	}

}
