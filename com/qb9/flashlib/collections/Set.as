package com.qb9.flashlib.collections
{
   import com.qb9.flashlib.utils.ArrayUtil;
   
   public class Set extends BaseCollection
   {
       
      
      public function Set(param1:uint = 4294967295)
      {
         super(param1);
      }
      
      public function add(param1:Object) : void
      {
         if(!hasItem(param1))
         {
            items.push(param1);
         }
      }
      
      public function remove(param1:Object) : Object
      {
         return removeItem(param1);
      }
      
      public function take() : Object
      {
         return ArrayUtil.popChoice(items);
      }
   }
}
