package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.commons.constraint.ConstraintManager;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   
   public class IsConstraintAccomplished extends AbstractConstraint
   {
       
      
      private var constraintName:String;
      
      private var constraintManager:ConstraintManager;
      
      public function IsConstraintAccomplished(param1:Boolean)
      {
         super(param1);
         this.setup();
      }
      
      private function onInstanceAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == ConstraintManager)
         {
            this.setupConstraintManager();
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onInstanceAdded);
         }
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc2_:Boolean = this.constraintManager.accomplishById(this.constraintName);
         return doInvert(_loc2_);
      }
      
      private function setupConstraintManager() : void
      {
         this.constraintManager = Context.instance.getByType(ConstraintManager) as ConstraintManager;
      }
      
      override public function setData(param1:*) : void
      {
         this.constraintName = param1.constraintName;
      }
      
      private function setup() : void
      {
         if(Context.instance.hasByType(ConstraintManager))
         {
            this.setupConstraintManager();
         }
         else if(!weak)
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onInstanceAdded);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Context.instance.removeEventListener(ContextEvent.ADDED,this.onInstanceAdded);
      }
   }
}
