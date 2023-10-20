package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   
   public class EveryMonthConstraint extends AbstractConstraint
   {
       
      
      private var month:int;
      
      private var currentDate:Date;
      
      public function EveryMonthConstraint(param1:Boolean)
      {
         super(param1);
         this.setup();
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc2_:* = this.currentDate.month == this.month;
         return doInvert(_loc2_);
      }
      
      override public function setData(param1:*) : void
      {
         if(param1.month >= 0 && param1.month < 12)
         {
            this.month = param1.month;
            return;
         }
         throw new Error("Is invalid data [ " + param1.month + " ]");
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
