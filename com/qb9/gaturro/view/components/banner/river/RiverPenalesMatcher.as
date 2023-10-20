package com.qb9.gaturro.view.components.banner.river
{
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.flashlib.tasks.Timeout;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import com.qb9.gaturro.view.world.interaction.InteractionTypes;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class RiverPenalesMatcher extends InstantiableGuiModal implements IHasRoomAPI
   {
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var lastPage:int = 0;
      
      private var prev:MovieClip;
      
      private var tasks:TaskRunner;
      
      private const MAX_SLOTS:int = 18;
      
      private var currentPage:int = 0;
      
      private var asset:MovieClip;
      
      private var next:MovieClip;
      
      private var notAvailable:TextField;
      
      private var avatarsInRoom:Array;
      
      public function RiverPenalesMatcher()
      {
         super("RiverPenalesMatcher","RiverPenalesMatcher");
      }
      
      private function gaturroInRoom(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._roomAPI.avatars.length)
         {
            if(this._roomAPI.avatars[_loc2_].username == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function click(param1:MouseEvent) : void
      {
         param1.currentTarget.gotoAndPlay("click");
         if(param1.currentTarget.name == "next")
         {
            ++this.currentPage;
            if(this.currentPage >= this.lastPage)
            {
               this.currentPage = this.lastPage;
            }
            logger.debug(this,"next:",this.currentPage);
         }
         if(param1.currentTarget.name == "prev")
         {
            --this.currentPage;
            if(this.currentPage < 0)
            {
               this.currentPage = 0;
            }
            logger.debug(this,"prev:",this.currentPage);
         }
         this.populatePage(this.currentPage);
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
      
      private function over(param1:MouseEvent) : void
      {
         param1.currentTarget.gotoAndStop("over");
      }
      
      private function out(param1:MouseEvent) : void
      {
         param1.currentTarget.gotoAndStop("up");
      }
      
      private function populatePage(param1:int) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:String = null;
         this.notAvailable.visible = false;
         this.asset["noUsers"].visible = this.avatarsInRoom.length > 0 ? false : true;
         var _loc2_:int = 0;
         while(_loc2_ < this.MAX_SLOTS)
         {
            _loc3_ = this.asset["slot_" + _loc2_.toString()] as MovieClip;
            _loc3_.alpha = 0;
            if(this.avatarsInRoom[_loc2_ + param1 * this.MAX_SLOTS])
            {
               _loc4_ = String(this.avatarsInRoom[_loc2_ + param1 * this.MAX_SLOTS]);
               (_loc3_["user"] as TextField).text = _loc4_;
               _loc3_.data = _loc4_;
               _loc3_.buttonMode = true;
               _loc3_.alpha = 1;
               _loc3_.addEventListener(MouseEvent.CLICK,this.onButtonClicked);
            }
            _loc2_++;
         }
      }
      
      private function userNotAvailable() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.MAX_SLOTS)
         {
            _loc2_ = this.asset["slot_" + _loc1_.toString()] as MovieClip;
            _loc2_.alpha = 0;
            _loc1_++;
         }
         this.notAvailable.visible = true;
         this.listAvatarsInRoom();
         this.tasks.add(new Timeout(this.populatePage,2000,this.currentPage));
      }
      
      override protected function ready() : void
      {
         super.ready();
         this.tasks = new TaskRunner(this);
         this.tasks.start();
         this.asset = view as MovieClip;
         this.notAvailable = this.asset["notAvailable"];
         this.notAvailable.visible = false;
         this.setupNavigation();
         this.listAvatarsInRoom();
         this.populatePage(this.currentPage);
      }
      
      private function setupNavigation() : void
      {
         this.next = this.asset["scrollBtns"]["next"];
         this.prev = this.asset["scrollBtns"]["prev"];
         this.prev.addEventListener(MouseEvent.CLICK,this.click);
         this.prev.addEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.prev.addEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.next.addEventListener(MouseEvent.CLICK,this.click);
         this.next.addEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.next.addEventListener(MouseEvent.MOUSE_OVER,this.over);
      }
      
      private function listAvatarsInRoom() : void
      {
         this.avatarsInRoom = [];
         logger.debug("avatars in room:",this._roomAPI.avatars.length);
         var _loc1_:int = 0;
         while(_loc1_ < this._roomAPI.avatars.length)
         {
            if(this._roomAPI.avatars[_loc1_] != this._roomAPI.userAvatar)
            {
               this.avatarsInRoom.push(this._roomAPI.avatars[_loc1_].username);
            }
            _loc1_++;
         }
         this.avatarsInRoom.sort();
         this.lastPage = this.avatarsInRoom.length / this.MAX_SLOTS;
      }
      
      private function onButtonClicked(param1:MouseEvent = null) : void
      {
         var _loc2_:String = String(param1.currentTarget.data.toUpperCase());
         if(!this.gaturroInRoom(_loc2_))
         {
            this.userNotAvailable();
            return;
         }
         api.trackEvent("RIVER:PENALES","invitacion");
         this._roomAPI.room.proposeInteraction(InteractionTypes.FUTBOL_RIVER_GAME,_loc2_);
         logger.debug(this,param1.currentTarget.data);
      }
   }
}
