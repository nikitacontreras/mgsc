package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.user.GaturroUser;
   
   public class HasPassportProductConstraint extends AbstractConstraint
   {
       
      
      private var user:GaturroUser;
      
      private var product:int;
      
      public function HasPassportProductConstraint(param1:Boolean)
      {
         super(param1);
         this.setup();
      }
      
      private function onAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == GaturroUser)
         {
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onAdded);
            this.user = Context.instance.getByType(GaturroUser) as GaturroUser;
         }
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc2_:* = false;
         if(this.user && this.user.passportProduct && this.user.passportProduct.hasPassport())
         {
            _loc2_ = this.user.passportProduct.passportId == this.product;
            return doInvert(_loc2_);
         }
         return false;
      }
      
      override public function setData(param1:*) : void
      {
         this.product = param1.product;
      }
      
      private function setup() : void
      {
         if(Context.instance.hasByType(GaturroUser))
         {
            this.user = Context.instance.getByType(GaturroUser) as GaturroUser;
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onAdded);
         }
      }
   }
}
