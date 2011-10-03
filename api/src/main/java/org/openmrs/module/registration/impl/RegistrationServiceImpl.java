package org.openmrs.module.registration.impl;

import java.text.ParseException;
import java.util.List;

import org.openmrs.Patient;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonAttributeType;
import org.openmrs.api.impl.BaseOpenmrsService;
import org.openmrs.module.registration.RegistrationService;
import org.openmrs.module.registration.db.RegistrationDAO;
import org.openmrs.module.registration.model.RegistrationFee;

public class RegistrationServiceImpl extends BaseOpenmrsService implements
		RegistrationService {

	public RegistrationServiceImpl() {
	}

	protected RegistrationDAO dao;

	public void setDao(RegistrationDAO dao) {
		this.dao = dao;
	}

	/*
	 * REGISTRATION FEE
	 */
	public RegistrationFee saveRegistrationFee(RegistrationFee fee) {
		return dao.saveRegistrationFee(fee);
	}

	public RegistrationFee getRegistrationFee(Integer id) {
		return dao.getRegistrationFee(id);
	}

	public List<RegistrationFee> getRegistrationFees(Patient patient,
			Integer numberOfLastDate) throws ParseException {
		return dao.getRegistrationFees(patient, numberOfLastDate);
	}

	public void deleteRegistrationFee(RegistrationFee fee) {
		dao.deleteRegistrationFee(fee);
	}

	/*
	 * PERSON ATTRIBUTE
	 */
	public List<PersonAttribute> getPersonAttribute(PersonAttributeType type,
			String value) {
		return dao.getPersonAttribute(type, value);
	}
}
