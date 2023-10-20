package com.qb9.gaturro.commons.iterator.iterable
{
   public class IterableVector extends AbstractIterable
   {
       
      
      public function IterableVector(param1:Array)
      {
         super(param1,this);
      }
      
      override public function add(param1:*, param2:* = null) : void
      {
         if(param2 != null)
         {
            this.castedSource.push(param1);
         }
         else
         {
            this.castedSource[param2] = param1;
         }
         super.add(param1,param2);
      }
      
      private function get castedSource() : Array
      {
         return source as Array;
      }
   }
}
