package com.qb9.gaturro.commons.iterator.iterable
{
   import com.qb9.gaturro.globals.logger;
   
   public class IterableObject extends AbstractIterable
   {
       
      
      public function IterableObject(param1:Object)
      {
         super(param1,this);
      }
      
      override public function add(param1:*, param2:* = null) : void
      {
         if(param2 == null)
         {
            logger.debug("The key shouldn\'t be null");
            throw new Error("The key shouldn\'t be null");
         }
         this.castedSource[param2] = param1;
         super.add(param1);
      }
      
      override protected function setupList(param1:Object) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in param1)
         {
            list.push(param1[_loc2_]);
         }
      }
      
      private function get castedSource() : Object
      {
         return source as Object;
      }
   }
}
