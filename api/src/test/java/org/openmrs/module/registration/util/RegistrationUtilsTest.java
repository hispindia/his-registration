package org.openmrs.module.registration.util;

import java.text.ParseException;
import java.util.Calendar;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

public class RegistrationUtilsTest
{
    public String date;
    
    @Before
    public void before() throws ParseException{
        Calendar cal = Calendar.getInstance();
        // cal.set( 2013, Calendar.JANUARY, 28 );
        date = cal.get(cal.DATE) + "/" + (cal.get( cal.MONTH ) + 1) + "/" + cal.get( cal.YEAR );
    }
    
    @Test
    public void estimateAgeTest() throws ParseException{
        Assert.assertEquals( "~0 D ", RegistrationUtils.estimateAge( date ) );
}
    
   

}
