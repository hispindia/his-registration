package org.openmrs.module.registration.includable.validator.attribute;

import java.util.Map;


public interface PatientAttributeValidator {

	public abstract String validate(Map<String, Object> parameters);

}
