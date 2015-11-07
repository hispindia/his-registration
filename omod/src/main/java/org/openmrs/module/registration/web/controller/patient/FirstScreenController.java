package org.openmrs.module.registration.web.controller.patient;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;


	@Controller("FirstScreenController")
	@RequestMapping("/findPatient.htm")
	public class FirstScreenController {
		
		
		@RequestMapping(method = RequestMethod.GET)
		public String firstView() {
			
				
			return "/module/registration/patient/firstScreen";
		}
		
		
		
		@RequestMapping(method = RequestMethod.POST)
		public String onSubmit() {
			
		
			return "redirect:/module/registration/firstScreen";
		}
	
		

}
