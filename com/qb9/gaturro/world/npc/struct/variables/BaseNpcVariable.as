package com.qb9.gaturro.world.npc.struct.variables
{
   import com.qb9.gaturro.world.npc.struct.NpcContext;
   
   internal class BaseNpcVariable
   {
       
      
      private var _name:String;
      
      private var shared:Boolean;
      
      private var _defaultValue:Object;
      
      public function BaseNpcVariable(param1:String, param2:Boolean, param3:Object)
      {
         super();
         this.shared = param2;
         this._defaultValue = param3;
         this._name = param1;
      }
      
      public function get defaultValue() : Object
      {
         return this._defaultValue;
      }
      
      public function dispose() : void
      {
      }
      
      protected function getKey(param1:NpcContext) : String
      {
         return (this.shared ? "" : param1.privateKey) + this.name;
      }
      
      public function get name() : String
      {
         return this._name;
      }
   }
}
