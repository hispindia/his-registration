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

package org.openmrs.module.registration.web.controller.util;

import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import org.openmrs.Patient;
import org.openmrs.PersonAttribute;
import org.openmrs.module.hospitalcore.util.PatientUtils;
import org.openmrs.module.registration.util.RegistrationUtils;

public class PatientModel {
	
	private String patientId;
	
	private String identifier;
	
	private String fullname;
	
	private String firstName;
	
	private String lastName;
	
	private String age;
	
	private String gender;
	
	private String category;
	
	private String address;
	
	private String postalAddress;
	
	private String town;
	
	private String settlement;
	
	private String birthdate;
	
	private Map<Integer, String> attributes = new HashMap<Integer, String>();
	
	public PatientModel(Patient patient) throws ParseException {
		setPatientId(patient.getPatientId().toString());
		setIdentifier(patient.getPatientIdentifier().getIdentifier());
		setFullname(PatientUtils.getFullName(patient));
		setLastName(patient.getFamilyName());
		setFirstName(patient.getGivenName());
		
		setAge(String.format("%s, %s", PatientUtils.estimateAge(patient.getBirthdate()),
		    PatientUtils.getAgeCategory(patient)));
		
		if (patient.getGender().equalsIgnoreCase("M")) {
			setGender("Male");
		} else if(patient.getGender().equalsIgnoreCase("F")){
			setGender("Female");
		} else if(patient.getGender().equalsIgnoreCase("O")){
			setGender("Others");
		}
	
		setPostalAddress(patient.getPersonAddress().getAddress1());
		setTown(patient.getPersonAddress().getCountyDistrict());
		setSettlement(patient.getPersonAddress().getCityVillage());
		
		setBirthdate(RegistrationUtils.formatDate(patient.getBirthdate()));
		
		Map<String, PersonAttribute> attributes = patient.getAttributeMap();
		for (String key : attributes.keySet()) {
			getAttributes().put(attributes.get(key).getAttributeType().getId(), attributes.get(key).getValue());
		}
	}
	
	public String getFullname() {
		return fullname;
	}
	
	public void setFullname(String fullname) {
		this.fullname = fullname;
	}
	
	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getAge() {
		return age;
	}
	
	public void setAge(String age) {
		this.age = age;
	}
	
	public String getGender() {
		return gender;
	}
	
	public void setGender(String gender) {
		this.gender = gender;
	}
	
	public String getCategory() {
		return category;
	}
	
	public void setCategory(String category) {
		this.category = category;
	}
	
	public String getAddress() {
		return address;
	}
	
	public void setAddress(String address) {
		this.address = address;
	}
	
	public String getPostalAddress() {
		return postalAddress;
	}

	public void setPostalAddress(String postalAddress) {
		this.postalAddress = postalAddress;
	}

	public String getTown() {
		return town;
	}

	public void setTown(String town) {
		this.town = town;
	}

	public String getSettlement() {
		return settlement;
	}

	public void setSettlement(String settlement) {
		this.settlement = settlement;
	}

	public Map<Integer, String> getAttributes() {
		return attributes;
	}
	
	public void setAttributes(Map<Integer, String> attributes) {
		this.attributes = attributes;
	}
	
	public String getIdentifier() {
		return identifier;
	}
	
	public void setIdentifier(String identifier) {
		this.identifier = identifier;
	}
	
	public String getPatientId() {
		return patientId;
	}
	
	public void setPatientId(String patientId) {
		this.patientId = patientId;
	}
	
	public String getBirthdate() {
		return birthdate;
	}
	
	public void setBirthdate(String birthdate) {
		this.birthdate = birthdate;
	}
}
