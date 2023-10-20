package com.qb9.mines.mobject
{
   public class MobjectData
   {
       
      
      private var value:Object;
      
      private var type:int;
      
      private var key:String;
      
      public function MobjectData(param1:String, param2:Object, param3:int)
      {
         super();
         this.key = param1;
         this.value = param2;
         this.type = param3;
      }
      
      public function toString() : String
      {
         return "<" + this.key + ":" + this.type + "=" + this.value + ">";
      }
      
      public function getKey() : String
      {
         return this.key;
      }
      
      public function getValue() : Object
      {
         return this.value;
      }
      
      public function getDataType() : int
      {
         return this.type;
      }
   }
}
