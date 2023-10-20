package com.qb9.mines.mobject
{
   public class Mobject
   {
       
      
      private var strings:Object;
      
      private var mobjectArrays:Object;
      
      private var mobjects:Object;
      
      private var booleanArrays:Object;
      
      private var booleans:Object;
      
      private var floats:Object;
      
      private var integerArrays:Object;
      
      private var stringArrays:Object;
      
      private var integers:Object;
      
      private var floatArrays:Object;
      
      public function Mobject()
      {
         this.integers = {};
         this.floats = {};
         this.strings = {};
         this.booleans = {};
         this.mobjects = {};
         this.integerArrays = {};
         this.floatArrays = {};
         this.stringArrays = {};
         this.booleanArrays = {};
         this.mobjectArrays = {};
         super();
      }
      
      public function getFloatArray(param1:String) : Array
      {
         return this.floatArrays[param1];
      }
      
      private function addList(param1:Array, param2:Object, param3:int) : void
      {
         var _loc4_:String = null;
         for(_loc4_ in param2)
         {
            param1.push(new MobjectData(_loc4_,param2[_loc4_],param3));
         }
      }
      
      public function getMobjectArray(param1:String) : Array
      {
         return this.mobjectArrays[param1];
      }
      
      public function getInteger(param1:String) : Number
      {
         return this.integers[param1];
      }
      
      public function hasInteger(param1:String) : Boolean
      {
         return param1 in this.integers;
      }
      
      public function setStringArray(param1:String, param2:Array) : void
      {
         this.stringArrays[param1] = param2;
      }
      
      public function setMobjectArray(param1:String, param2:Array) : void
      {
         this.mobjectArrays[param1] = param2;
      }
      
      public function hasBoolean(param1:String) : Boolean
      {
         return param1 in this.booleans;
      }
      
      public function getStringArray(param1:String) : Array
      {
         return this.stringArrays[param1];
      }
      
      public function setString(param1:String, param2:String) : void
      {
         this.strings[param1] = param2;
      }
      
      public function setIntegerArray(param1:String, param2:Array) : void
      {
         this.integerArrays[param1] = param2;
      }
      
      public function setFloat(param1:String, param2:Number) : void
      {
         this.floats[param1] = param2;
      }
      
      public function iterator() : Array
      {
         var _loc1_:Array = new Array();
         this.addList(_loc1_,this.integers,MobjectDataType.INTEGER);
         this.addList(_loc1_,this.booleans,MobjectDataType.BOOLEAN);
         this.addList(_loc1_,this.floats,MobjectDataType.FLOAT);
         this.addList(_loc1_,this.strings,MobjectDataType.STRING);
         this.addList(_loc1_,this.mobjects,MobjectDataType.MOBJECT);
         this.addList(_loc1_,this.integerArrays,MobjectDataType.INTEGER_ARRAY);
         this.addList(_loc1_,this.booleanArrays,MobjectDataType.BOOLEAN_ARRAY);
         this.addList(_loc1_,this.floatArrays,MobjectDataType.FLOAT_ARRAY);
         this.addList(_loc1_,this.stringArrays,MobjectDataType.STRING_ARRAY);
         this.addList(_loc1_,this.mobjectArrays,MobjectDataType.MOBJECT_ARRAY);
         return _loc1_;
      }
      
      public function getString(param1:String) : String
      {
         return this.strings[param1];
      }
      
      public function setBooleanArray(param1:String, param2:Array) : void
      {
         this.booleanArrays[param1] = param2;
      }
      
      public function setBoolean(param1:String, param2:Boolean) : void
      {
         this.booleans[param1] = param2;
      }
      
      public function getBooleanArray(param1:String) : Array
      {
         return this.booleanArrays[param1];
      }
      
      public function getFloat(param1:String) : Number
      {
         return this.floats[param1];
      }
      
      public function setMobject(param1:String, param2:Mobject) : void
      {
         this.mobjects[param1] = param2;
      }
      
      public function getBoolean(param1:String) : Boolean
      {
         return this.booleans[param1];
      }
      
      public function setFloatArray(param1:String, param2:Array) : void
      {
         this.floatArrays[param1] = param2;
      }
      
      public function getIntegerArray(param1:String) : Array
      {
         return this.integerArrays[param1];
      }
      
      public function addData(param1:MobjectData) : void
      {
         var _loc2_:int = param1.getDataType();
         switch(_loc2_)
         {
            case MobjectDataType.INTEGER:
               this.setInteger(param1.getKey(),int(param1.getValue()));
               break;
            case MobjectDataType.FLOAT:
               this.setFloat(param1.getKey(),Number(param1.getValue()));
               break;
            case MobjectDataType.STRING:
               this.setString(param1.getKey(),String(param1.getValue()));
               break;
            case MobjectDataType.BOOLEAN:
               this.setBoolean(param1.getKey(),Boolean(param1.getValue()));
               break;
            case MobjectDataType.MOBJECT:
               this.setMobject(param1.getKey(),param1.getValue() as Mobject);
               break;
            case MobjectDataType.INTEGER_ARRAY:
               this.setIntegerArray(param1.getKey(),param1.getValue() as Array);
               break;
            case MobjectDataType.FLOAT_ARRAY:
               this.setFloatArray(param1.getKey(),param1.getValue() as Array);
               break;
            case MobjectDataType.STRING_ARRAY:
               this.setStringArray(param1.getKey(),param1.getValue() as Array);
               break;
            case MobjectDataType.BOOLEAN_ARRAY:
               this.setBooleanArray(param1.getKey(),param1.getValue() as Array);
               break;
            case MobjectDataType.MOBJECT_ARRAY:
               this.setMobjectArray(param1.getKey(),param1.getValue() as Array);
         }
      }
      
      public function toString() : String
      {
         var _loc2_:MobjectData = null;
         var _loc1_:String = "";
         for each(_loc2_ in this.iterator())
         {
            _loc1_ += "[" + _loc2_.getKey() + "] " + _loc2_.getValue() + "\n";
         }
         return _loc1_;
      }
      
      public function setInteger(param1:String, param2:Number) : void
      {
         this.integers[param1] = param2;
      }
      
      public function getMobject(param1:String) : Mobject
      {
         return this.mobjects[param1];
      }
   }
}
