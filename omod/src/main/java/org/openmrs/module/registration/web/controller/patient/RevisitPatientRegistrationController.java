/**
 *  Copyright 2014 Society for Health Information Systems Programmes, India (HISP India)
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

package org.openmrs.module.registration.web.controller.patient;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.DocumentException;
import org.jaxen.JaxenException;
import org.openmrs.api.context.Context;
import org.openmrs.module.registration.util.RegistrationConstants;
import org.openmrs.module.registration.util.RegistrationUtils;
import org.openmrs.module.registration.web.controller.util.RegistrationWebUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller("RevisitPatientRegistrationController")
@RequestMapping("/revisitPatientRegistration.htm")
public class RevisitPatientRegistrationController {

	private static Log logger = LogFactory
			.getLog(RevisitPatientRegistrationController.class);

	@RequestMapping(method = RequestMethod.GET)
	public String showForm(HttpServletRequest request, Model model)
			throws JaxenException, DocumentException, IOException {
		model.addAttribute("patientIdentifier",
				RegistrationUtils.getNewIdentifier());
		model.addAttribute(
				"referralHospitals",
				RegistrationWebUtils
						.getSubConcepts(RegistrationConstants.CONCEPT_NAME_PATIENT_REFERRED_FROM));
		model.addAttribute(
				"referralReasons",
				RegistrationWebUtils
						.getSubConcepts(RegistrationConstants.CONCEPT_NAME_REASON_FOR_REFERRAL));
		RegistrationWebUtils.getAddressData(model);
		// model.addAttribute("OPDs",
		// RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_OPD_WARD));
		// ghanshyam,16-dec-2013,3438 Remove the interdependency
		model.addAttribute(
				"TEMPORARYCAT",
				RegistrationWebUtils
						.getSubConcepts(RegistrationConstants.CONCEPT_NAME_TEMPORARY_CATEGORY));
		String triageEnabled = Context.getAdministrationService()
				.getGlobalProperty("registration.triageEnabled");
		if (triageEnabled.equalsIgnoreCase("true")) {
			model.addAttribute("TRIAGE", RegistrationWebUtils
					.getSubConcepts(RegistrationConstants.CONCEPT_NAME_TRIAGE));
			return "/module/registration/patient/revisitPatientRegistrationForTriage";
		} else {
			model.addAttribute(
					"OPDs",
					RegistrationWebUtils
							.getSubConcepts(RegistrationConstants.CONCEPT_NAME_OPD_WARD));
			return "/module/registration/patient/revisitPatientRegistrationForOPD";
		}

	}
}
