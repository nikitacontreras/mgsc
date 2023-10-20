package com.qb9.flashlib.config
{
   import com.qb9.flashlib.net.LoadFile;
   import com.qb9.flashlib.tasks.TaskEvent;
   import com.qb9.flashlib.utils.ObjectUtil;
   
   public dynamic class Settings
   {
       
      
      protected var decode:Function;
      
      public function Settings(param1:Function = null)
      {
         super();
         this.decode = param1;
      }
      
      public function feed(param1:Object) : void
      {
         if(param1 is String)
         {
            param1 = this.decode(param1);
         }
         ObjectUtil.copy(param1,this,true);
      }
      
      protected function fileLoaded(param1:TaskEvent) : void
      {
         var _loc2_:LoadFile = param1.target as LoadFile;
         _loc2_.removeEventListener(param1.type,this.fileLoaded);
         this.feed(_loc2_.data);
      }
      
      public function addFile(param1:LoadFile) : void
      {
         if(param1.loaded)
         {
            this.feed(param1.data);
         }
         else
         {
            param1.addEventListener(TaskEvent.COMPLETE,this.fileLoaded);
         }
      }
   }
}
