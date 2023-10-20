package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   
   public class TimeReachedConstraint extends AbstractConstraint
   {
       
      
      private var interval:Number;
      
      private var timeID:String;
      
      public function TimeReachedConstraint(param1:Boolean)
      {
         super(param1);
         this.setup();
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc2_:Boolean = false;
         return doInvert(_loc2_);
      }
      
      override public function dispose() : void
      {
         Context.instance.removeEventListener(ContextEvent.ADDED,this.onServiceAdded);
         super.dispose();
      }
      
      private function onServiceAdded(param1:ContextEvent) : void
      {
      }
      
      override public function setData(param1:*) : void
      {
         this.timeID = param1.timeID;
         this.interval = param1.interval * 1000;
      }
      
      private function setup() : void
      {
      }
   }
}
