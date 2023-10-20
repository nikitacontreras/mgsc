package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   
   public class EveryEndHourConstraint extends AbstractConstraint
   {
       
      
      private var hour:int;
      
      private var currentDate:Date;
      
      public function EveryEndHourConstraint(param1:Boolean)
      {
         super(param1);
         this.setup();
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc2_:* = this.currentDate.hours <= this.hour;
         return doInvert(_loc2_);
      }
      
      override public function setData(param1:*) : void
      {
         if(param1.hour > 0 && param1.hour < 24)
         {
            this.hour = param1.hour;
            return;
         }
         throw new Error("Is invalid data [ " + param1.hour + " ]");
      }
      
      private function setup() : void
      {
         this.currentDate = new Date();
      }
   }
}
