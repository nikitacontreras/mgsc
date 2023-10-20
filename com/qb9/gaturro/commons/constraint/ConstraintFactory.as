package com.qb9.gaturro.commons.constraint
{
   import com.qb9.gaturro.commons.constraint.containers.AbstractConstraintContainer;
   import com.qb9.gaturro.commons.constraint.containers.ConstraintContainer;
   import com.qb9.gaturro.commons.factory.IFactory;
   import com.qb9.gaturro.commons.model.config.IConfig;
   import com.qb9.gaturro.commons.model.config.IConfigHolder;
   import flash.utils.getDefinitionByName;
   
   public class ConstraintFactory implements IConfigHolder, IFactory
   {
       
      
      private var _config:com.qb9.gaturro.commons.constraint.ConstraintConfig;
      
      public function ConstraintFactory()
      {
         super();
      }
      
      private function buildRecursively(param1:AbstractConstraintContainer, param2:Array, param3:Boolean) : void
      {
         var _loc4_:AbstractConstraint = null;
         var _loc5_:Object = null;
         for each(_loc5_ in param2)
         {
            if((_loc4_ = this.instantiateConstraint(_loc5_.type,param3)) is AbstractConstraintContainer)
            {
               this.buildRecursively(_loc4_ as AbstractConstraintContainer,_loc5_.list,param3);
            }
            else if(_loc5_.hasOwnProperty("data"))
            {
               _loc4_.setData(_loc5_.data);
            }
            _loc4_.invert = _loc5_.invert;
            param1.addConstraint(_loc4_);
         }
      }
      
      public function buildDefinition(param1:Object, param2:String, param3:Boolean) : AbstractConstraint
      {
         var _loc4_:ConstraintContainer = new ConstraintContainer(param2,param3);
         var _loc5_:AbstractConstraint = this.instantiateConstraint(param1.type,param3);
         _loc4_.addConstraint(_loc5_);
         _loc5_.invert = param1.invert;
         if(param1.hasOwnProperty("data"))
         {
            _loc5_.setData(param1.data);
         }
         if(param1.hasOwnProperty("list"))
         {
            this.buildRecursively(_loc5_ as AbstractConstraintContainer,param1.list,param3);
         }
         return _loc4_;
      }
      
      public function set config(param1:IConfig) : void
      {
         this._config = param1 as com.qb9.gaturro.commons.constraint.ConstraintConfig;
      }
      
      private function instantiateConstraint(param1:String, param2:Boolean) : AbstractConstraint
      {
         var _loc3_:String = this._config.getClassDefinition(param1);
         var _loc4_:Class;
         if(!(_loc4_ = getDefinitionByName(_loc3_) as Class))
         {
            trace("Does not exist a subclass of AbstractConstraint for a type [" + param1 + "] and the definition = [" + _loc3_ + "].");
            return null;
         }
         return new _loc4_(param2);
      }
      
      public function build(param1:String, param2:Boolean) : AbstractConstraint
      {
         var _loc3_:Object = this._config.getDefinition(param1);
         return this.buildDefinition(_loc3_,param1,param2);
      }
   }
}
