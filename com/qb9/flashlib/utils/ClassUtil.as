package com.qb9.flashlib.utils
{
   import flash.utils.describeType;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public final class ClassUtil
   {
       
      
      public function ClassUtil()
      {
         super();
      }
      
      public static function getFullName(param1:Object) : String
      {
         return getQualifiedClassName(param1);
      }
      
      public static function getName(param1:Object) : String
      {
         return getFullName(param1).split("::")[1];
      }
      
      public static function getClass(param1:Object) : Class
      {
         return getDefinitionByName(getFullName(param1)) as Class;
      }
      
      public static function isDynamic(param1:Object) : Boolean
      {
         return describeType(param1).@isDynamic.toString() === "true";
      }
      
      public static function isOfClass(param1:Object, param2:Class) : Boolean
      {
         return getClass(param1) === param2;
      }
   }
}
