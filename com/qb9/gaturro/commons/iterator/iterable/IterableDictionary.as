package com.qb9.gaturro.commons.iterator.iterable
{
   import com.qb9.gaturro.globals.logger;
   import flash.utils.Dictionary;
   
   public class IterableDictionary extends AbstractIterable
   {
       
      
      public function IterableDictionary(param1:Dictionary)
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
      
      private function get castedSource() : Dictionary
      {
         return source as Dictionary;
      }
   }
}
