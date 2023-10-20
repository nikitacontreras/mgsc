package com.qb9.gaturro.view.components.banner.serenito.seretubers
{
   import com.adobe.serialization.json.JSON;
   import com.qb9.flashlib.config.Settings;
   import com.qb9.flashlib.net.LoadFile;
   import com.qb9.flashlib.net.LoadFileFormat;
   import com.qb9.flashlib.net.LoadFileParsers;
   import com.qb9.flashlib.tasks.TaskEvent;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.server;
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.gaturro.service.events.EventData;
   import com.qb9.gaturro.service.events.EventsAttributeEnum;
   import com.qb9.gaturro.service.events.roomviews.EventsRoomsEnum;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.setTimeout;
   
   public class SeretubersCreatorBanner extends InstantiableGuiModal
   {
      
      public static const CHALLENGE_SELECTED:String = "challengeSelected";
       
      
      private var config:Settings;
      
      private var pages:Array;
      
      private var task:TaskRunner;
      
      private var taskRunner:TaskRunner;
      
      private var clip:MovieClip;
      
      private var currentPage:int = 0;
      
      public function SeretubersCreatorBanner(param1:String = "SeretubersCreatorBanner", param2:String = "SeretubersCreatorBannerAsset")
      {
         this.pages = ["type","instructions","creating","ready","error"];
         super(param1,param2);
         this.taskRunner = new TaskRunner(this);
         this.taskRunner.start();
      }
      
      private function setupTypePage(param1:Object) : void
      {
         var _loc2_:TextField = this.clip["title"] as TextField;
         var _loc3_:TextField = this.clip["title2"] as TextField;
         var _loc4_:MovieClip = this.clip["selection"] as MovieClip;
         _loc2_.text = param1.title;
         _loc3_.text = param1.subtitle;
         this.configureButtons(_loc4_,param1.buttons);
         var _loc5_:TextField;
         (_loc5_ = this.clip["selection"]["info"] as TextField).text = "";
         this.clip.play();
      }
      
      private function onSettingsLoaded(param1:Event) : void
      {
         this.setPage(0,this.config.type);
      }
      
      private function gotoInvite() : void
      {
         this.clip.addEventListener("animation_end",function(param1:Event):void
         {
            param1.currentTarget.removeEventListener(param1.type,arguments.callee);
            api.gotoEvent();
         });
         this.clip.gotoAndPlay("invite");
         setTimeout(function():void
         {
            (clip["inviteBtn"] as MovieClip).addEventListener(MouseEvent.CLICK,function(param1:Event):void
            {
               param1.currentTarget.removeEventListener(param1.type,arguments.callee);
               clip.play();
            });
         },100);
      }
      
      private function setPage(param1:int, param2:Object) : void
      {
         switch(param1)
         {
            case 0:
               this.setupTypePage(param2);
         }
      }
      
      override protected function onAssetReady() : void
      {
         this.clip = view["canvasContainer"] as MovieClip;
         this.clip.stop();
      }
      
      private function addBtnListeners(param1:MovieClip) : void
      {
         param1.mouseEnabled = true;
         param1.mouseChildren = false;
         param1.buttonMode = true;
         param1.useHandCursor = true;
         param1.label.mouseEnabled = false;
         param1.addEventListener(MouseEvent.CLICK,this.onBtnClick);
         param1.addEventListener(MouseEvent.MOUSE_OVER,this.onBtnOver);
         param1.addEventListener(MouseEvent.MOUSE_OUT,this.onBtnOver);
      }
      
      private function onBtnClick(param1:MouseEvent) : void
      {
         var challenge:String = null;
         var e:MouseEvent = param1;
         (e.currentTarget as MovieClip).gotoAndStop("on");
         challenge = (e.currentTarget as MovieClip).name;
         this.removeBtnsListeners(this.clip["selection"] as MovieClip);
         this.clip.addEventListener("animation_end",function(param1:Event):void
         {
            param1.currentTarget.removeEventListener(param1.type,arguments.callee);
            gotoCreating(challenge);
         });
         this.clip.play();
      }
      
      private function removeBtnsListeners(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            this.removeBtnListeners(param1["btn_" + _loc2_]);
            _loc2_++;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      override protected function ready() : void
      {
         LoadFileParsers.registerParser(LoadFileFormat.JSON,com.adobe.serialization.json.JSON.decode);
         var _loc1_:String = URLUtil.getUrl("cfgs/banners/SeretubersCreatorBanner.json");
         var _loc2_:LoadFile = new LoadFile(_loc1_,"json");
         this.config = new Settings();
         this.config.addFile(_loc2_);
         _loc2_.addEventListener(TaskEvent.COMPLETE,this.onSettingsLoaded);
         this.taskRunner.add(_loc2_);
      }
      
      private function removeBtnListeners(param1:MovieClip) : void
      {
         param1.removeEventListener(MouseEvent.CLICK,this.onBtnClick);
         param1.removeEventListener(MouseEvent.MOUSE_OVER,this.onBtnOver);
         param1.removeEventListener(MouseEvent.MOUSE_OUT,this.onBtnOver);
      }
      
      private function onBtnOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_loc2_.currentLabel == "idle")
         {
            _loc2_.gotoAndStop("over");
         }
         else
         {
            _loc2_.gotoAndStop("idle");
         }
         var _loc3_:TextField = this.clip["selection"]["info"] as TextField;
         _loc3_.text = _loc2_.currentLabel == "idle" ? "" : String(_loc2_.data.info);
      }
      
      private function configureButtons(param1:MovieClip, param2:Object) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < 4)
         {
            param1["btn_" + _loc3_].data = param2[_loc3_];
            param1["btn_" + _loc3_].lock.visible = param2[_loc3_].blocked;
            param1["btn_" + _loc3_].icon.gotoAndStop(_loc3_ + 1);
            param1["btn_" + _loc3_].label.text = param2[_loc3_].title;
            if(!param2[_loc3_].blocked)
            {
               this.addBtnListeners(param1["btn_" + _loc3_]);
            }
            _loc3_++;
         }
      }
      
      private function gotoCreating(param1:String) : void
      {
         var room:int = 0;
         var challenge:String = param1;
         logger.debug(this,"creating",challenge);
         switch(challenge)
         {
            case "btn_0":
               room = int(EventsRoomsEnum.SERETUBERS_1[0]);
               api.trackEvent("PAUTAS:SERETUBERS:CREACION_DESAFIO","1");
               break;
            case "btn_1":
               room = int(EventsRoomsEnum.SERETUBERS_2[0]);
               api.trackEvent("PAUTAS:SERETUBERS:CREACION_DESAFIO","2");
               break;
            case "btn_2":
               room = int(EventsRoomsEnum.SERETUBERS_3[0]);
               api.trackEvent("PAUTAS:SERETUBERS:CREACION_DESAFIO","3");
               break;
            case "btn_3":
               room = int(EventsRoomsEnum.SERETUBERS_4[0]);
               api.trackEvent("PAUTAS:SERETUBERS:CREACION_DESAFIO","4");
         }
         this.clip.addEventListener("animation_end",function(param1:Event):void
         {
            param1.currentTarget.removeEventListener(param1.type,arguments.callee);
            var _loc3_:EventData = new EventData();
            _loc3_.duration = 10 * 60000;
            _loc3_.host = api.user.username;
            _loc3_.type = EventsAttributeEnum.SERETUBERS;
            _loc3_.start = server.time;
            _loc3_.roomID = room;
            _loc3_.features = "11111";
            _loc3_.isPublic = true;
            api.addParty(_loc3_.asObject());
            gotoInvite();
         });
         this.clip.gotoAndPlay("creating");
         setTimeout(function():void
         {
            clip.play();
         },1000);
      }
   }
}
