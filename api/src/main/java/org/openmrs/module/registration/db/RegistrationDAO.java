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

package org.openmrs.module.registration.db;

import java.text.ParseException;
import java.util.List;

import org.openmrs.Encounter;
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
	
	/**
	 * Get last encounter
	 * @param patient
	 * @return
	 */
	public Encounter getLastEncounter(Patient patient);
	
    public int getGreenBookNumber(String greenBookNo);
	
	public int getGreenBookNumber(Integer patientId,String greenBookNo);
	
	public int getAadharCardNumber(String aadharCardNo);
	
	public int getAadharCardNumber(Integer patientId,String aadharCardNo);
	
    public int getDhoID(String dhoid);
    
	public int getDhoID(Integer patientId,String dhoid);
}
