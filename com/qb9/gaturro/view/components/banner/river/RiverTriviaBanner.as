package com.qb9.gaturro.view.components.banner.river
{
   import com.adobe.serialization.json.JSON;
   import com.qb9.flashlib.net.LoadFile;
   import com.qb9.flashlib.net.LoadFileFormat;
   import com.qb9.flashlib.net.LoadFileParsers;
   import com.qb9.flashlib.tasks.TaskEvent;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.gaturro.view.components.banner.boca.BocaTriviaBanner;
   
   public class RiverTriviaBanner extends BocaTriviaBanner
   {
      
      public static const RIVER:String = "riverTrivia";
      
      public static const RIVER_TELEMETRY:String = "RIVER:TRIVIA";
       
      
      public function RiverTriviaBanner(param1:String = "", param2:String = "")
      {
         super("RiverTriviaBanner","RiverTriviaBanner");
      }
      
      override protected function ready() : void
      {
         taskRunner = new TaskRunner(this);
         taskRunner.start();
         triviaId = RIVER;
         telemetryId = RIVER_TELEMETRY;
         LoadFileParsers.registerParser(LoadFileFormat.JSON,com.adobe.serialization.json.JSON.decode);
         var _loc1_:String = URLUtil.getUrl("cfgs/banners/riverTrivia.json");
         var _loc2_:LoadFile = new LoadFile(_loc1_,"json");
         settings.addFile(_loc2_);
         _loc2_.addEventListener(TaskEvent.COMPLETE,onSettingsLoaded);
         taskRunner.add(_loc2_);
      }
   }
}
