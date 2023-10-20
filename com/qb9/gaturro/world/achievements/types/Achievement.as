package com.qb9.gaturro.world.achievements.types
{
   import com.qb9.flashlib.events.QEvent;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import flash.events.EventDispatcher;
   
   public class Achievement extends EventDispatcher
   {
      
      public static const ACHIEVEMENT_SUCCESS:String = "OK";
      
      public static const ACHIEVE_SAVE_EVENT:String = "ACHIEVE_SAVE_EVENT";
       
      
      protected var achieved:Boolean = false;
      
      protected var desc:String;
      
      protected var typeStr:String;
      
      protected var monitor:Boolean = false;
      
      protected var room:GaturroRoom;
      
      protected var key:String;
      
      protected var recent:Boolean = false;
      
      protected var dataObj:Object;
      
      protected var pointsPerAchiev:int = 0;
      
      protected var tit:String;
      
      protected var icon:String;
      
      public function Achievement(param1:Object)
      {
         super();
         this.typeStr = param1.type;
         this.key = param1.key;
         this.tit = param1.title;
         this.desc = param1.desc;
         this.icon = param1.logo;
         this.pointsPerAchiev = param1.points;
         if(param1.data)
         {
            this.dataObj = param1.data;
         }
      }
      
      public function dispose() : void
      {
         this.room = null;
      }
      
      public function changeRoom(param1:GaturroRoom) : void
      {
         this.room = param1;
      }
      
      public function isAchieved() : Boolean
      {
         return this.achieved;
      }
      
      protected function activate() : void
      {
      }
      
      public function save(param1:String, param2:Boolean = true) : void
      {
         this.dispatchEvent(new QEvent(ACHIEVE_SAVE_EVENT,{
            "key":this.key,
            "value":param1,
            "mustCelebrate":param2
         }));
      }
      
      public function init(param1:String, param2:Boolean) : void
      {
         this.monitor = param2;
      }
      
      public function confirmAchiev() : void
      {
         this.achieved = true;
         this.recent = true;
         this.deactivate();
      }
      
      public function get title() : String
      {
         return region.getText(this.tit);
      }
      
      protected function achieve(param1:Boolean = true) : void
      {
         this.save(Achievement.ACHIEVEMENT_SUCCESS,param1);
      }
      
      public function get keyId() : String
      {
         return this.key;
      }
      
      public function get points() : int
      {
         return this.pointsPerAchiev;
      }
      
      public function isRecent() : Boolean
      {
         return this.recent;
      }
      
      public function get logo() : String
      {
         return this.icon;
      }
      
      public function get data() : Object
      {
         return this.dataObj;
      }
      
      public function get type() : String
      {
         return this.typeStr;
      }
      
      protected function deactivate() : void
      {
      }
      
      public function get description() : String
      {
         return region.getText(this.desc);
      }
   }
}
