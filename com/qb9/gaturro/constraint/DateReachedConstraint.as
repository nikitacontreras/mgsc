package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.globals.api;
   
   public class DateReachedConstraint extends AbstractConstraint
   {
       
      
      private var targetDate:Date;
      
      private var date:Date;
      
      public function DateReachedConstraint(param1:Boolean)
      {
         super(param1);
         this.setup();
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc2_:* = this.targetDate.getTime() <= this.date.getTime();
         return doInvert(_loc2_);
      }
      
      override public function setData(param1:*) : void
      {
         var _loc2_:String = String(param1.date);
         this.targetDate = new Date(Date.parse(_loc2_));
      }
      
      private function setup() : void
      {
         this.date = new Date(api.serverTime);
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
