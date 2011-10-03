package org.openmrs.module.registration.includable.validator.attribute;

import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Patient;
import org.openmrs.module.hospitalcore.util.GlobalPropertyUtil;
import org.openmrs.module.hospitalcore.util.HospitalCoreConstants;
import org.openmrs.module.registration.includable.validator.attribute.common.CommonPatientAttributeValidatorImpl;


public class PatientAttributeValidatorService implements PatientAttributeValidator {
	
	private Log logger = LogFactory.getLog(getClass());

	private PatientAttributeValidator validator;
	
	/**
	 * Get the validator relying on the hospital name. If can't find one, a
	 * warning will be thrown and the default validator will be used.
	 */
	public PatientAttributeValidatorService() {
		String hospitalName = GlobalPropertyUtil.getString(
				HospitalCoreConstants.PROPERTY_HOSPITAL_NAME, "");
		if (!StringUtils.isBlank(hospitalName)) {
			validator = new CommonPatientAttributeValidatorImpl();
			logger.warn("USE THE DEFAULT VALIDATOR.");	
		}
	}

	public String validate(Patient patient, Map<String, String> attributes) {
		if(validator!=null){
			return validator.validate(patient, attributes);
		} else {
			logger.warn("NO VALIDATOR FOUND!");	
		}
		return null;
	}
}
