package com.qb9.gaturro.manager.provider.strategy
{
   import com.qb9.gaturro.commons.constraint.ConstraintManager;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.manager.provider.IProvider;
   import com.qb9.gaturro.model.config.provider.model.ProviderModel;
   import flash.errors.IllegalOperationError;
   
   public class AbstractProviderStrategy implements IProvider
   {
       
      
      private var constraintManager:ConstraintManager;
      
      protected var model:ProviderModel;
      
      public function AbstractProviderStrategy(param1:ProviderModel)
      {
         super();
         this.model = param1;
      }
      
      public function getNext() : *
      {
         throw new IllegalOperationError("This is an abstract method and couldn\'t be instatiated. Should be implemented by the subclass");
      }
      
      protected function activeConstraint(param1:Object, param2:String) : void
      {
         this.constraintManager.activateDefinition(param1,param2);
      }
      
      protected function evalConstraint(param1:String) : Boolean
      {
         return this.constraintManager.accomplishById(param1);
      }
      
      protected function setup() : void
      {
         this.constraintManager = Context.instance.getByType(ConstraintManager) as ConstraintManager;
      }
      
      public function hasNext() : Boolean
      {
         throw new IllegalOperationError("This is an abstract method and couldn\'t be instatiated. Should be implemented by the subclass");
      }
   }
}
