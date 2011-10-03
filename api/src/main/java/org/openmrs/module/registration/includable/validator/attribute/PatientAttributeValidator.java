package org.openmrs.module.registration.includable.validator.attribute;

import java.util.Map;

import org.openmrs.Patient;

public interface PatientAttributeValidator {

	public abstract String validate(Patient patient, Map<String, String> attributes);

}
