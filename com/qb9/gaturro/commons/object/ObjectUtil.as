package com.qb9.gaturro.commons.object
{
   import com.qb9.gaturro.globals.logger;
   import flash.utils.ByteArray;
   
   public class ObjectUtil
   {
       
      
      public function ObjectUtil()
      {
         super();
         logger.debug("This is a static class and souldn\'t be instantiated");
         throw new Error("This is a static class and souldn\'t be instantiated");
      }
      
      public static function clone(param1:Object) : *
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeObject(param1);
         _loc2_.position = 0;
         return _loc2_.readObject();
      }
   }
}
