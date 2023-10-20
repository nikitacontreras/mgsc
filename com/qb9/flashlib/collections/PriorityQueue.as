package com.qb9.flashlib.collections
{
   public class PriorityQueue extends BaseCollection
   {
       
      
      public function PriorityQueue(param1:uint = 4294967295)
      {
         super(param1);
      }
      
      public function enqueue(param1:Object, param2:Number) : void
      {
         var _loc3_:uint = 0;
         while(_loc3_ < items.length)
         {
            if(param2 >= items[_loc3_].priority)
            {
               break;
            }
            _loc3_++;
         }
         items.splice(_loc3_,0,new Item(param1,param2));
      }
      
      public function dequeue() : Object
      {
         return empty ? null : items.shift().data;
      }
   }
}

class Item
{
    
   
   private var data:Object;
   
   private var priority:Number;
   
   public function Item(param1:Object, param2:Number)
   {
      super();
      this.data = param1;
      this.priority = param2;
   }
}
