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

package org.openmrs.module.registration.impl;

import java.text.ParseException;
import java.util.List;

import org.openmrs.Encounter;
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

	public Encounter getLastEncounter(Patient patient) {
		return dao.getLastEncounter(patient);
	}
	
	//ghanshya,3-july-2013 #1962 Create validation for length of Health ID and National ID
	public int getNationalId(String nationalId){
		return dao.getNationalId(nationalId);
	}
	
	public int getNationalId(Integer patientId,String nationalId){
		return dao.getNationalId(patientId,nationalId);
	}
	
	public int getHealthId(String healthId){
		return dao.getHealthId(healthId);
	}
	
	public int getHealthId(Integer patientId,String healthId){
		return dao.getHealthId(patientId,healthId);
	}
	
}
