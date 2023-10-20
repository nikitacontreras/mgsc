package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.globals.api;
   
   public class EveryDayConstraint extends AbstractConstraint
   {
       
      
      private var currentDate:Date;
      
      private var day:int;
      
      public function EveryDayConstraint(param1:Boolean)
      {
         super(param1);
         this.setup();
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc2_:* = this.currentDate.day == this.day;
         return doInvert(_loc2_);
      }
      
      override public function setData(param1:*) : void
      {
         if(param1.day >= 0 && param1.day < 7)
         {
            this.day = param1.day;
            return;
         }
         throw new Error("Is invalid data [ " + param1.day + " ]");
      }
      
      private function setup() : void
      {
         this.currentDate = new Date(api.serverTime);
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
