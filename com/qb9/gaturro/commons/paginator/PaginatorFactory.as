package com.qb9.gaturro.commons.paginator
{
   import com.qb9.gaturro.commons.iterator.iterable.IIterable;
   import flash.utils.Dictionary;
   
   public class PaginatorFactory
   {
      
      public static const SMART_TYPE:String = "smart";
      
      public static const LOOP_TYPE:String = "loop";
      
      public static const SIMPLE_TYPE:String = "simple";
       
      
      protected var paginatorClassMap:Dictionary;
      
      public function PaginatorFactory()
      {
         super();
         this.setup();
      }
      
      protected function setup() : void
      {
         this.paginatorClassMap = new Dictionary();
         this.paginatorClassMap[LOOP_TYPE] = LoopPaginator;
         this.paginatorClassMap[SMART_TYPE] = SmartPaginator;
         this.paginatorClassMap[SIMPLE_TYPE] = SimplePaginator;
      }
      
      public function build(param1:String, param2:IIterable, param3:int) : IPaginator
      {
         var _loc4_:Class;
         return new (_loc4_ = this.paginatorClassMap[param1])(param2,param3);
      }
   }
}
