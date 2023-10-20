package com.qb9.gaturro.commons.iterator.iterable
{
   import flash.errors.IllegalOperationError;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class IterableFactory
   {
      
      private static const VECTOR:String = "Vector";
      
      private static var typeList:Dictionary;
       
      
      public function IterableFactory()
      {
         super();
         throw new IllegalOperationError("This Class shouldn\'t be instanciated");
      }
      
      private static function getIterableTyppeList() : Dictionary
      {
         if(!typeList)
         {
            typeList = new Dictionary();
            typeList["flash.utils::Dictionary"] = IterableDictionary;
            typeList["Vector"] = IterableVector;
            typeList["Array"] = IterableArray;
            typeList["Object"] = IterableObject;
         }
         return typeList;
      }
      
      public static function build(param1:Object) : IIterable
      {
         var _loc2_:Dictionary = getIterableTyppeList();
         var _loc3_:String = getQualifiedClassName(param1);
         _loc3_ = _loc3_.indexOf("Vector") >= 0 ? VECTOR : _loc3_;
         var _loc4_:Class;
         return new (_loc4_ = _loc2_[_loc3_])(param1) as IIterable;
      }
   }
}
