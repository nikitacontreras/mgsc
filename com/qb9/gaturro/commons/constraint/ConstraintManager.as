package com.qb9.gaturro.commons.constraint
{
   import com.qb9.gaturro.commons.factory.IFactory;
   import com.qb9.gaturro.commons.factory.IFactoryHolder;
   import com.qb9.gaturro.globals.logger;
   import flash.utils.Dictionary;
   
   public class ConstraintManager implements IFactoryHolder
   {
       
      
      private var activeConstraint:Dictionary;
      
      private var _disposed:Boolean;
      
      private var _factory:com.qb9.gaturro.commons.constraint.ConstraintFactory;
      
      private var _manifest:com.qb9.gaturro.commons.constraint.AbstractConstraintManifest;
      
      public function ConstraintManager()
      {
         super();
         this.setup();
      }
      
      public function accomplishFromDefinition(param1:Object, param2:String, param3:* = null) : Boolean
      {
         var _loc4_:AbstractConstraint;
         var _loc5_:Boolean = (_loc4_ = this.buildConstraint(param1,param2,true)).accomplish(param3);
         _loc4_.dispose();
         return _loc5_;
      }
      
      private function doActivation(param1:String) : void
      {
         var _loc2_:AbstractConstraint = this._factory.build(param1,false);
         this.activeConstraint[param1] = _loc2_;
      }
      
      public function activateAndAccomplish(param1:Object, param2:String, param3:* = null) : Boolean
      {
         this.activateDefinition(param1,param2);
         return this.accomplishById(param2,param3);
      }
      
      public function hasConstraintWithID(param1:String) : Boolean
      {
         return this.activeConstraint[param1];
      }
      
      public function set factory(param1:IFactory) : void
      {
         this._factory = param1 as com.qb9.gaturro.commons.constraint.ConstraintFactory;
      }
      
      public function set manifest(param1:com.qb9.gaturro.commons.constraint.AbstractConstraintManifest) : void
      {
         this._manifest = param1;
      }
      
      public function dispose() : void
      {
         this.disposeActiveConstraints();
         this._disposed = true;
      }
      
      public function unobserve(param1:String) : void
      {
         var _loc2_:AbstractConstraint = this.activeConstraint[param1];
         if(!_loc2_)
         {
            logger.debug("Doesn\'t exist an active constraint with ID = [" + param1 + "]");
            throw new Error("Doesn\'t exist an active constraint with ID = [" + param1 + "]");
         }
         _loc2_.unobserve();
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function activateDefinition(param1:Object, param2:String) : void
      {
         var _loc3_:AbstractConstraint = null;
         if(!this.activeConstraint[param2])
         {
            _loc3_ = this.buildConstraint(param1,param2,false);
            this.activeConstraint[param2] = _loc3_;
         }
      }
      
      private function buildConstraint(param1:Object, param2:String, param3:Boolean) : AbstractConstraint
      {
         return this._factory.buildDefinition(param1,param2,param3);
      }
      
      private function disposeActiveConstraints() : void
      {
         var _loc1_:AbstractConstraint = null;
         for each(_loc1_ in this.activeConstraint)
         {
            _loc1_.dispose();
         }
         this.activeConstraint = null;
      }
      
      public function activate(param1:String) : void
      {
         if(!this._manifest)
         {
            logger.debug("This class is not initialized. Should invoke \'init\' method and pass \'AbstractConstraintManifest\' subclass.");
            throw new Error("This class is not initialized. Should invoke \'init\' method and pass \'AbstractConstraintManifest\' subclass.");
         }
         if(!this.activeConstraint[param1])
         {
            this.doActivation(param1);
         }
      }
      
      public function deactivate(param1:String) : void
      {
         var _loc2_:AbstractConstraint = this.activeConstraint[param1];
         _loc2_.dispose();
      }
      
      public function accomplishById(param1:String, param2:* = null) : Boolean
      {
         var _loc3_:AbstractConstraint = null;
         if(!this.activeConstraint[param1])
         {
            this.doActivation(param1);
         }
         _loc3_ = this.activeConstraint[param1];
         return _loc3_.accomplish(param2);
      }
      
      private function setup() : void
      {
         this.activeConstraint = new Dictionary();
      }
      
      public function observe(param1:String, param2:Function) : void
      {
         var _loc3_:AbstractConstraint = this.activeConstraint[param1];
         if(!_loc3_)
         {
            logger.debug("Doesn\'t exist an active constraint with ID = [" + param1 + "]");
            throw new Error("Doesn\'t exist an active constraint with ID = [" + param1 + "]");
         }
         _loc3_.observe(param2);
      }
   }
}
