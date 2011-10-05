package org.openmrs.module.registration.includable.validator.attribute.solan;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Patient;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonAttributeType;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.util.GlobalPropertyUtil;
import org.openmrs.module.registration.RegistrationService;
import org.openmrs.module.registration.includable.validator.attribute.PatientAttributeValidator;
import org.openmrs.module.registration.util.RegistrationConstants;

public class PatientAttributeValidatorImpl implements
		PatientAttributeValidator {

	private Log logger = LogFactory.getLog(getClass());

	/**
	 * Check RSBY number & BPL number. Two global properties will be read are
	 * `registration.patientPerRSBY` and `registration.patientPerBPL`
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String validate(Map<String, Object> parameters) {	
		
		// Get values from parameters
		Map<String, String> attributes = (Map<String, String>) parameters.get("attributes");
		String RSBYNumber = attributes.get("person.attribute.11");
		String BPLNumber = attributes.get("person.attribute.10");		
		Patient patient = (Patient) parameters.get("patient");

		// Validate
		if (!StringUtils.isBlank(RSBYNumber)) {
			if (!checkRSBYNumber(patient, RSBYNumber)) {
				return "Invalid RSBY Number";
			}
		}

		if (!StringUtils.isBlank(BPLNumber)) {
			if (!checkBPLNumber(patient, BPLNumber)) {
				return "Invalid BPL Number";
			}
		}

		return null;
	}

	/**
	 * Check RSBY number
	 * @param patient TODO
	 * 
	 * @return
	 */
	private boolean checkRSBYNumber(Patient patient, String number) {
		PersonAttributeType type = Context.getPersonService()
				.getPersonAttributeType(11);		
		List<PersonAttribute> attributes = Context.getService(
				RegistrationService.class).getPersonAttribute(type, number);
		Integer maximumNo = GlobalPropertyUtil.getInteger(
				RegistrationConstants.PROPERTY_RSBY_NO_OF_PATIENT, 5);
		logger.info(String
				.format("The number of patients registered with this RSBY number %s is %s",
						number, attributes.size()));
		
		// Get old number
		String oldNumber = null;
		if(patient.getAttribute(type)!=null)
			oldNumber = patient.getAttribute(type).getValue();
		
		// Check
		if(number.equalsIgnoreCase(oldNumber)){
			if(attributes.size() <= maximumNo){
				return true;
			}
		} else {
			if (attributes.size() < maximumNo){
				return true;
			}	
		}
		return false;
	}

	/**
	 * Check BPL number
	 * @param patient TODO
	 * 
	 * @return
	 */
	private boolean checkBPLNumber(Patient patient, String number) {
		logger.info("CHECKING BPL");
		PersonAttributeType type = Context.getPersonService()
				.getPersonAttributeType(10);
		List<PersonAttribute> attributes = Context.getService(
				RegistrationService.class).getPersonAttribute(type, number);
		Integer maximumNo = GlobalPropertyUtil.getInteger(
				RegistrationConstants.PROPERTY_BPL_NO_OF_PATIENT, 10);
		logger.info(String
				.format("The number of patients registered with this BPL number %s is %s",
						number, attributes.size()));
		
		// Get old number
		String oldNumber = null;
		if(patient.getAttribute(type)!=null)
			oldNumber = patient.getAttribute(type).getValue();
		
		// Check
		if(number.equalsIgnoreCase(oldNumber)){
			if(attributes.size() <= maximumNo){
				return true;
			}
		} else {
			if (attributes.size() < maximumNo){
				return true;
			}	
		}
		return false;
	}
}
