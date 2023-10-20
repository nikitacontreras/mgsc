package com.qb9.gaturro.util
{
   import com.qb9.flashlib.logs.IAppender;
   
   public final class LogCollector implements IAppender
   {
      
      private static const THRESHOLD:uint = 500;
      
      private static const FILTERS:Array = ["MoveAction","Tile was selected"];
       
      
      private var logs:Array;
      
      public function LogCollector()
      {
         this.logs = [];
         super();
      }
      
      public function joined(param1:String = "\n") : String
      {
         return this.logs.join(param1);
      }
      
      public function append(param1:Array, param2:int) : void
      {
         var _loc4_:String = null;
         var _loc3_:String = param1.join(" ");
         for each(_loc4_ in FILTERS)
         {
            if(_loc3_.indexOf(_loc4_) !== -1)
            {
               return;
            }
         }
         this.logs.push(_loc3_);
         if(this.logs.length > THRESHOLD)
         {
            this.logs.shift();
         }
      }
   }
}
