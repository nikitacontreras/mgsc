package com.qb9.flashlib.easing
{
   import com.qb9.flashlib.lang.assert;
   import com.qb9.flashlib.utils.ObjectUtil;
   
   public class Easing
   {
      
      private static var functions:Object = {};
      
      {
         _init();
      }
      
      public function Easing()
      {
         super();
      }
      
      public static function getAllFunctions() : Object
      {
         return ObjectUtil.copy(functions);
      }
      
      public static function registerEasingGroup(param1:String, param2:Class) : void
      {
         registerFunction(param1 + "easein",param2.easeIn);
         registerFunction(param1 + "easeout",param2.easeOut);
         registerFunction(param1 + "easeinout",param2.easeInOut);
      }
      
      private static function normalizedId(param1:String) : String
      {
         return param1.toLowerCase().replace(".","");
      }
      
      public static function registerFunction(param1:String, param2:Function) : void
      {
         param1 = normalizedId(param1);
         if(functions[param1])
         {
            throw new Error("Easing function with identifier: \'" + param1 + "\' already exists.");
         }
         functions[param1] = param2;
      }
      
      public static function getFunction(param1:String = "linear") : Function
      {
         if(param1 == "" || param1 == null)
         {
            param1 = "linear";
         }
         param1 = normalizedId(param1);
         assert(functions[param1] != undefined,"Undefined transition function: " + param1);
         return functions[param1];
      }
      
      private static function _init() : void
      {
         registerFunction("linear",Linear.ease);
         registerFunction("easein",Quad.easeIn);
         registerFunction("easeout",Quad.easeOut);
         registerFunction("easeinout",Quad.easeInOut);
         registerEasingGroup("Back",Back);
         registerEasingGroup("Bounce",Bounce);
         registerEasingGroup("Circ",Circ);
         registerEasingGroup("Cubic",Cubic);
         registerEasingGroup("Elastic",Elastic);
         registerEasingGroup("Expo",Expo);
         registerEasingGroup("Quad",Quad);
         registerEasingGroup("Quart",Quart);
         registerEasingGroup("Quint",Quint);
         registerEasingGroup("Sine",Sine);
      }
   }
}
