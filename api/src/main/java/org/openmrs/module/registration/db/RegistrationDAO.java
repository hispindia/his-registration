package org.openmrs.module.registration.db;

import java.text.ParseException;
import java.util.List;

import org.openmrs.Patient;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonAttributeType;
import org.openmrs.module.registration.model.RegistrationFee;



public interface RegistrationDAO {

	// REGISTRATION FEE
	
	/**
	 * Save registration fee
	 * @param fee
	 * @return
	 */
	public RegistrationFee saveRegistrationFee(RegistrationFee fee);

	/**
	 * Get registration fee by id
	 * @param id
	 * @return
	 */
	public RegistrationFee getRegistrationFee(Integer id);
	
	/**
	 * Get list of registration fee
	 * @param patient 
	 * @param numberOfLastDate 
	 * 		<b>null</b> to search all time 
	 * @return
	 * @throws ParseException
	 */
	public List<RegistrationFee> getRegistrationFees(Patient patient,
			Integer numberOfLastDate) throws ParseException;

	/**
	 * Delete registration fee
	 * @param fee
	 */
	public void deleteRegistrationFee(RegistrationFee fee);
	
	// PERSON ATTRIBUTE
	
	/**
	 * Get Person Attributes
	 * @param type
	 * @param value
	 * @return
	 */
	public List<PersonAttribute> getPersonAttribute(PersonAttributeType type,
			String value);
}
