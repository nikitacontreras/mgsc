package com.qb9.gaturro.world.reports
{
   import com.qb9.flashlib.events.QEventDispatcher;
   
   public final class InfoReportQueue extends QEventDispatcher
   {
       
      
      private var list:Array;
      
      public function InfoReportQueue()
      {
         this.list = [];
         super();
      }
      
      public function dequeue() : InfoReportItem
      {
         return this.list.shift() as InfoReportItem;
      }
      
      public function queue(param1:String, param2:String, param3:Object = null) : void
      {
         this.queueItem(new InfoReportItem(param1,param2,param3));
      }
      
      public function queueItem(param1:InfoReportItem) : void
      {
         this.list.push(param1);
         dispatchEvent(new InfoReportQueueEvent(InfoReportQueueEvent.HAS_ITEMS));
      }
      
      public function get hasItems() : Boolean
      {
         return this.list.length !== 0;
      }
   }
}
