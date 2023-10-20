package com.qb9.mines.mobject
{
   public class MobjectDataType
   {
      
      public static const MOBJECT_ARRAY:int = 9;
      
      public static const INTEGER_ARRAY:int = 7;
      
      public static const BOOLEAN:int = 1;
      
      public static const STRING_ARRAY:int = 5;
      
      public static const MOBJECT:int = 4;
      
      public static const STRING:int = 0;
      
      public static const BOOLEAN_ARRAY:int = 6;
      
      public static const FLOAT:int = 3;
      
      public static const FLOAT_ARRAY:int = 8;
      
      public static const INTEGER:int = 2;
       
      
      public function MobjectDataType()
      {
         super();
      }
      
      public static function infer(param1:Object) : int
      {
         if(param1 is Array)
         {
            if(!param1.length)
            {
               throw new Error("MobjectDataType > Can\'t infer type from empty array");
            }
            return infer(param1[0]) + 5;
         }
         if(param1 is int)
         {
            return INTEGER;
         }
         if(param1 is Number)
         {
            return FLOAT;
         }
         if(param1 is String)
         {
            return STRING;
         }
         if(param1 is Boolean)
         {
            return BOOLEAN;
         }
         if(Boolean(param1) && typeof param1 === "object")
         {
            return MOBJECT;
         }
         throw new Error("MobjectDataType > Could not infer type from " + param1);
      }
   }
}
