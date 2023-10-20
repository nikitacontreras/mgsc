package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.view.world.elements.HolderRoomSceneObjectView;
   import com.qb9.gaturro.view.world.elements.NpcRoomSceneObjectView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.elements.HolderRoomSceneObject;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class SalaEnsayoRoomView extends GaturroRoomView
   {
       
      
      private var currentDrumTrack:String;
      
      private var drums:Instrument;
      
      private var currentBassTrack:String;
      
      private var bass:Instrument;
      
      public function SalaEnsayoRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:Mailer, param5:WhiteListNode)
      {
         super(param1,param3,param4,param5);
         this.drums = new Instrument("drums",this.alertAvatarPlaying,this.alertAvatarLeaving);
         this.bass = new Instrument("bass",this.alertAvatarPlaying,this.alertAvatarLeaving);
      }
      
      private function playAllInstrumentsInUse(param1:Event = null) : void
      {
         if(this.bass.holder.full)
         {
            this.bass.playCurrentSong(true,this.playAllInstrumentsInUse);
            if(this.drums.holder.full)
            {
               this.drums.playCurrentSong();
            }
            return;
         }
         if(this.drums.holder.full)
         {
            this.drums.playCurrentSong(true,this.playAllInstrumentsInUse);
         }
      }
      
      override public function dispose() : void
      {
         this.bass.dispose();
         this.drums.dispose();
         super.dispose();
      }
      
      private function repeatDrumsForPlayer(param1:Event = null) : void
      {
         if(this.drums.playerInHolder)
         {
            this.drums.playCurrentSong(true,this.repeatDrumsForPlayer);
            if(this.bass.holder.full)
            {
               this.bass.playCurrentSong();
            }
         }
      }
      
      private function registerNPCListeners() : void
      {
         this.bass.registerListeners();
         this.drums.registerListeners();
      }
      
      private function alertAvatarLeaving() : void
      {
         this.bass.stopAllMusic();
         this.drums.stopAllMusic();
         this.playAllInstrumentsInUse();
      }
      
      private function repeatBassForPlayer(param1:Event = null) : void
      {
         if(this.bass.playerInHolder)
         {
            this.bass.playCurrentSong(true,this.repeatBassForPlayer);
            if(this.drums.holder.full)
            {
               this.drums.playCurrentSong();
            }
         }
      }
      
      private function captureHolder(param1:HolderRoomSceneObject) : void
      {
         if(param1.name.indexOf("drumHolder") != -1)
         {
            this.drums.holder = param1;
         }
         else if(param1.name.indexOf("bassHolder") != -1)
         {
            this.bass.holder = param1;
         }
      }
      
      override protected function finalInit() : void
      {
         super.finalInit();
         this.registerNPCListeners();
         this.playAllInstrumentsInUse();
      }
      
      override protected function createOtherSceneObject(param1:RoomSceneObject) : DisplayObject
      {
         var _loc2_:DisplayObject = super.createOtherSceneObject(param1);
         if(_loc2_ is NpcRoomSceneObjectView)
         {
            this.captureNPC(_loc2_ as NpcRoomSceneObjectView);
         }
         else if(_loc2_ is HolderRoomSceneObjectView)
         {
            this.captureHolder(param1 as HolderRoomSceneObject);
         }
         return _loc2_;
      }
      
      private function alertAvatarPlaying(param1:HolderRoomSceneObject) : void
      {
         this.bass.stopAllMusic();
         this.drums.stopAllMusic();
         if(param1 == this.bass.holder)
         {
            this.bass.playCurrentSong(true,this.repeatBassForPlayer);
            if(this.drums.holder.full)
            {
               this.drums.playCurrentSong();
            }
         }
         else
         {
            this.drums.playCurrentSong(true,this.repeatDrumsForPlayer);
            if(this.bass.holder.full)
            {
               this.bass.playCurrentSong();
            }
         }
      }
      
      private function captureNPC(param1:NpcRoomSceneObjectView) : void
      {
         trace(param1.object.name.indexOf("drums_so") != -1);
         trace(param1.object.name.indexOf("bass_so") != -1);
         if(param1.object.name.indexOf("drums_so") != -1)
         {
            this.drums.npc = param1;
         }
         else if(param1.object.name.indexOf("bass_so") != -1)
         {
            this.bass.npc = param1;
         }
      }
   }
}

import com.qb9.gaturro.globals.api;
import com.qb9.gaturro.globals.audio;
import com.qb9.gaturro.view.world.elements.NpcRoomSceneObjectView;
import com.qb9.gaturro.world.core.elements.HolderRoomSceneObject;
import com.qb9.gaturro.world.core.elements.events.HolderRoomSceneObjectEvent;
import flash.events.Event;

class Instrument
{
    
   
   public var npc:NpcRoomSceneObjectView;
   
   public var name:String;
   
   public var holder:HolderRoomSceneObject;
   
   private var alertAvatarPlaying:Function;
   
   private var alertAvatarLeaving:Function;
   
   public function Instrument(param1:String, param2:Function, param3:Function)
   {
      super();
      this.name = param1;
      this.alertAvatarPlaying = param2;
      this.alertAvatarLeaving = param3;
   }
   
   public function stopAllMusic() : void
   {
      var _loc1_:* = "antro2017/loop/" + this.name + "_trackA";
      var _loc2_:* = "antro2017/loop/" + this.name + "_trackB";
      var _loc3_:* = "antro2017/loop/" + this.name + "_trackC";
      if(audio.isRunning(_loc1_))
      {
         audio.stop(_loc1_);
      }
      if(audio.isRunning(_loc2_))
      {
         audio.stop(_loc2_);
      }
      if(audio.isRunning(_loc3_))
      {
         audio.stop(_loc3_);
      }
   }
   
   public function get currentTrack() : String
   {
      return this.npc.object.attributes.song as String || "trackA";
   }
   
   private function onHolderEnter(param1:HolderRoomSceneObjectEvent) : void
   {
      trace(this.name + " ENTERS");
      trace(param1.holder,param1.object);
      if(param1.object == api.userAvatar)
      {
         this.alertAvatarPlaying(this.holder);
      }
   }
   
   public function dispose() : void
   {
      this.stopAllMusic();
      this.holder.removeEventListener(HolderRoomSceneObjectEvent.ENTERING,this.onHolderEnter);
      this.holder.removeEventListener(HolderRoomSceneObjectEvent.LEAVING,this.onHolderLeave);
   }
   
   public function get playerInHolder() : Boolean
   {
      trace(this.holder.children);
      trace(this.holder.children[0]);
      return Boolean(this.holder.full) && this.holder.children[0] == api.userAvatar;
   }
   
   public function playCurrentSong(param1:Boolean = false, param2:Function = null) : void
   {
      var _loc3_:String = "antro2017/loop/" + this.name + "_" + this.currentTrack;
      audio.addLazyPlay(_loc3_);
      if(param1)
      {
         audio.getChannel(_loc3_).addEventListener(Event.SOUND_COMPLETE,param2);
      }
   }
   
   private function onHolderLeave(param1:HolderRoomSceneObjectEvent) : void
   {
      trace(this.name + " LEAVES");
      trace(param1.holder,param1.object);
      if(param1.object == api.userAvatar)
      {
         this.alertAvatarLeaving();
      }
   }
   
   public function registerListeners() : void
   {
      this.holder.addEventListener(HolderRoomSceneObjectEvent.ENTERING,this.onHolderEnter);
      this.holder.addEventListener(HolderRoomSceneObjectEvent.LEAVING,this.onHolderLeave);
   }
}
