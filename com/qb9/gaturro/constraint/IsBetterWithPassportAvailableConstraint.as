package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.manager.passport.BetterWithPassportManager;
   
   public class IsBetterWithPassportAvailableConstraint extends AbstractConstraint
   {
       
      
      private var manager:BetterWithPassportManager;
      
      private var silent:Boolean = true;
      
      private var feature:String;
      
      public function IsBetterWithPassportAvailableConstraint(param1:Boolean)
      {
         super(param1);
         this.setup();
      }
      
      private function onAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == BetterWithPassportManager)
         {
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onAdded);
            this.manager = Context.instance.getByType(BetterWithPassportManager) as BetterWithPassportManager;
         }
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc2_:Boolean = this.manager.isAvailable(this.feature);
         if(!this.silent && !_loc2_)
         {
            this.manager.openModal(this.feature);
         }
         return doInvert(_loc2_);
      }
      
      override public function setData(param1:*) : void
      {
         this.feature = param1.feature;
         this.silent = param1.silent;
      }
      
      private function setup() : void
      {
         if(Context.instance.hasByType(BetterWithPassportManager))
         {
            this.manager = Context.instance.getByType(BetterWithPassportManager) as BetterWithPassportManager;
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onAdded);
         }
      }
   }
}
