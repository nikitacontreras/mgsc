package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   
   public class EveryDateConstraint extends AbstractConstraint
   {
       
      
      private var date:int;
      
      private var currentDate:Date;
      
      public function EveryDateConstraint(param1:Boolean)
      {
         super(param1);
         this.setup();
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc2_:* = this.currentDate.date == this.date;
         return doInvert(_loc2_);
      }
      
      override public function setData(param1:*) : void
      {
         if(param1.date > 0 && param1.date < 32)
         {
            this.date = param1.date;
            return;
         }
         throw new Error("Is invalid data [ " + param1.date + " ]");
      }
      
      private function setup() : void
      {
         this.currentDate = new Date();
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
