package com.qb9.gaturro.commons.preloading.task.config
{
   import com.qb9.flashlib.config.Settings;
   import com.qb9.flashlib.net.LoadFile;
   import com.qb9.flashlib.tasks.Func;
   import com.qb9.flashlib.tasks.Parallel;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.gaturro.commons.preloading.task.base.LoadingTask;
   import com.qb9.gaturro.globals.*;
   import com.qb9.gaturro.net.requests.URLUtil;
   
   public class LoadConfigTask extends LoadingTask
   {
       
      
      private var path:String;
      
      private var taskSsettings:Settings;
      
      public function LoadConfigTask()
      {
         super();
      }
      
      private function makeFinalURL(param1:String) : String
      {
         var _loc2_:String = URLUtil.getUrl(param1);
         return URLUtil.versionedPath(_loc2_);
      }
      
      private function loadConfig() : void
      {
         this.taskSsettings = new Settings();
         var _loc1_:String = this.makeFinalURL(this.path);
         var _loc2_:LoadFile = new LoadFile(_loc1_);
         this.taskSsettings.addFile(_loc2_);
         var _loc3_:Parallel = new Parallel();
         _loc3_.add(_loc2_);
         new Sequence(_loc3_,new Func(this.onLoadEnd)).start();
      }
      
      override public function set data(param1:Object) : void
      {
         this.path = param1.path;
      }
      
      private function onLoadEnd() : void
      {
         _sharedRespository.settings = this.taskSsettings;
         taskComplete();
      }
      
      override public function start() : void
      {
         super.start();
         this.loadConfig();
      }
   }
}
