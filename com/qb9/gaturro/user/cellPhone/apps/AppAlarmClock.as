package com.qb9.gaturro.user.cellPhone.apps
{
   import com.qb9.gaturro.user.cellPhone.CellPhoneApp;
   
   public class AppAlarmClock extends CellPhoneApp
   {
       
      
      public function AppAlarmClock()
      {
         super();
         _scActionName = "alarmclock";
         _appName = "RELOJ ALARMA";
         _appDescription = "TE AYUDARÁ A RECORDAR LO QUE NECESITAS CON UNOS BUENOS BIPS.";
         _marketView = new AlarmaMV();
         _value = 500;
      }
   }
}
