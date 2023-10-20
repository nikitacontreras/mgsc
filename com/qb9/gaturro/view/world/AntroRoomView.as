package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.manager.music.MusicManager;
   import com.qb9.gaturro.view.world.avatars.GaturroAvatarView;
   import com.qb9.gaturro.view.world.elements.NpcRoomSceneObjectView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.core.attributes.events.CustomAttributeEvent;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.core.events.RoomEvent;
   import com.qb9.mambo.world.path.Path;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class AntroRoomView extends GaturroRoomView
   {
       
      
      private var musicManager:MusicManager;
      
      private var piano:NpcRoomSceneObjectView;
      
      private var moveToPianoTimeoutIndex:uint;
      
      private var moveOutTimeoutIndex:uint;
      
      private var turnos:NpcRoomSceneObjectView;
      
      private var showModalSubiATocarTimeOutIndex:uint;
      
      private var setAttrMessageTimeoutIndex:uint;
      
      private var showModalHasTerminadoTimeoutIndex:uint;
      
      private var currentPlayingAvatar:Avatar;
      
      private var cleanVarTimeoutIndex:uint;
      
      private var turnManager:TurnManager;
      
      private var nowPlaying:NpcRoomSceneObjectView;
      
      private var cheersTimeout:int;
      
      public function AntroRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:Mailer, param5:WhiteListNode)
      {
         super(param1,param3,param4,param5);
         this.turnManager = new TurnManager();
      }
      
      override public function dispose() : void
      {
         var _loc1_:String = api.userAvatar.attributes["message"] as String;
         if(Boolean(_loc1_) && _loc1_.indexOf("playingPiano") != -1)
         {
            this.piano.object.attributes["exit"] = this.turnManager.myTurnID;
         }
         var _loc2_:Boolean = this.isATurn(_loc1_);
         if(_loc2_)
         {
            api.setAvatarAttribute("message","");
         }
         this.piano.object.removeCustomAttributeListener("song",this.onPlayPiano);
         room.userAvatar.removeCustomAttributeListener("message",this.saveMyTurn);
         this.turnos.object.removeCustomAttributeListener("turnos",this.saveOthersTurn);
         if(this.currentPlayingAvatar)
         {
            this.currentPlayingAvatar.removeCustomAttributeListener("message",this.onPlayingAvatarMessage);
         }
         this.musicManager.stopSequence();
         api.stopSound("antro2017/backtrack");
         clearTimeout(this.cleanVarTimeoutIndex);
         clearTimeout(this.setAttrMessageTimeoutIndex);
         clearTimeout(this.showModalSubiATocarTimeOutIndex);
         clearTimeout(this.moveToPianoTimeoutIndex);
         clearTimeout(this.showModalHasTerminadoTimeoutIndex);
         clearTimeout(this.moveOutTimeoutIndex);
         super.dispose();
      }
      
      private function cheers() : void
      {
         api.playSound("escenarioVip/aplausos");
         api.playSound("aplausoCasamiento");
         clearTimeout(this.cheersTimeout);
      }
      
      override protected function removeSceneObject(param1:RoomEvent) : void
      {
         var _loc2_:Avatar = null;
         var _loc3_:String = null;
         super.removeSceneObject(param1);
         if(param1.sceneObject is Avatar)
         {
            _loc2_ = param1.sceneObject as Avatar;
            _loc2_.removeCustomAttributeListener("message",this.onPlayingAvatarMessage);
            _loc3_ = _loc2_.attributes["message"] as String;
            if(Boolean(_loc3_) && this.isATurn(_loc3_))
            {
               this.turnManager.refreshTurns(api.avatars);
            }
            if(!this.isSomeonePlaying() && this.turnManager.amINext())
            {
               this.gotoPiano();
            }
         }
      }
      
      override protected function addSceneObject(param1:RoomSceneObject) : void
      {
         var _loc2_:Avatar = null;
         var _loc3_:String = null;
         if(param1 is Avatar)
         {
            _loc2_ = param1 as Avatar;
            _loc3_ = _loc2_.attributes["message"] as String;
            _loc2_.addCustomAttributeListener("message",this.onPlayingAvatarMessage);
            if(Boolean(_loc3_) && this.isATurn(_loc3_))
            {
               this.turnManager.refreshTurns(api.avatars);
            }
         }
         super.addSceneObject(param1);
      }
      
      private function setAttrMessgePlayingPiano() : void
      {
         clearTimeout(this.setAttrMessageTimeoutIndex);
         api.setAvatarAttribute("message","playingPiano" + ":" + api.user.username);
      }
      
      private function onPlayPiano(param1:CustomAttributeEvent) : void
      {
         var _loc2_:String = null;
         trace("playing song: " + param1.attribute.value);
         if(this.musicManager)
         {
            _loc2_ = param1.attribute.value as String;
            if(_loc2_.charAt(0) == "0")
            {
               api.stopSound("antro2017/backtrack");
               api.playSound("antro2017/backtrack");
            }
            this.musicManager.playSerializedSequence(_loc2_.substr(2),this.onSongFinished);
         }
         else
         {
            trace("NO TIENE MUSIC MANAGER INSTANCIADO!");
         }
      }
      
      override protected function createOtherSceneObject(param1:RoomSceneObject) : DisplayObject
      {
         var _loc3_:NpcRoomSceneObjectView = null;
         var _loc4_:String = null;
         var _loc2_:DisplayObject = super.createOtherSceneObject(param1);
         if(_loc2_ is NpcRoomSceneObjectView)
         {
            _loc3_ = _loc2_ as NpcRoomSceneObjectView;
            if((_loc4_ = _loc3_.object.name).indexOf("teclado_so") != -1)
            {
               this.piano = _loc3_;
            }
            else if(_loc4_.indexOf("turnos_so") != -1)
            {
               this.turnos = _loc3_;
            }
            else if(_loc4_.indexOf("nowPlaying_so") != -1)
            {
               this.nowPlaying = _loc3_;
            }
         }
         return _loc2_;
      }
      
      private function showModalHasTerminado() : void
      {
         clearTimeout(this.showModalHasTerminadoTimeoutIndex);
         api.showModal("HAS TERMINADO DE TOCAR","information");
      }
      
      private function leavePiano() : void
      {
         this.nowPlaying.object.attributes["playerName"] = "";
         api.setSession("tengoTurno",false);
         api.setAvatarAttribute("message","leaving");
         clearTimeout(this.showModalHasTerminadoTimeoutIndex);
         this.showModalHasTerminadoTimeoutIndex = setTimeout(this.showModalHasTerminado,1500);
         clearTimeout(this.moveOutTimeoutIndex);
         this.moveOutTimeoutIndex = setTimeout(this.moveOut,1500);
         clearTimeout(this.cleanVarTimeoutIndex);
         this.cleanVarTimeoutIndex = setTimeout(this.cleanVars,6000);
         this.cheersTimeout = setTimeout(this.cheers,4000);
      }
      
      private function movetToPiano() : void
      {
         clearTimeout(this.moveToPianoTimeoutIndex);
         var _loc1_:Path = new Path([room.userAvatar.coord,this.piano.object.coord],this.piano.object.coord);
         room.userAvatar.moveBy(_loc1_);
      }
      
      override protected function checkIfTileSelected(param1:MouseEvent) : void
      {
         var _loc2_:String = String(room.userAvatar.attributes["message"]);
         if(_loc2_ == "playingPiano:" + room.userAvatar.username || _loc2_ == "leaving")
         {
            return;
         }
         super.checkIfTileSelected(param1);
      }
      
      private function onPlayingAvatarMessage(param1:CustomAttributeEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:GaturroAvatarView = null;
         var _loc2_:String = param1.attribute.value as String;
         if(this.nowPlaying && this.nowPlaying.object && Boolean(this.nowPlaying.object.attributes))
         {
            _loc3_ = this.nowPlaying.object.attributes["playerName"] as String;
         }
         if(_loc2_.indexOf("playingPiano") != -1)
         {
            _loc4_ = "playingPiano:".length;
            _loc3_ = _loc2_.substr(_loc4_);
            trace("// ESPERANDO AL JUGADOR A QUE TERMINE DE GRABAR.");
            api.textMessageToGUI("EL JUGADOR " + _loc3_ + " ESTÁ GRABANDO SU CANCIÓN");
            this.currentPlayingAvatar = api.getAvatarByName(_loc3_);
            trace(this.currentPlayingAvatar.username);
            _loc5_ = this.piano.getChildAt(0) as MovieClip;
            _loc6_ = getAvatarView(this.currentPlayingAvatar.avatarId);
            _loc5_.addChild(_loc6_);
         }
         if(_loc2_ == "finished")
         {
            trace("// REPRODUCIENDO LA CANCIÓN.");
            api.textMessageToGUI("¡ESCUCHEMOS LA CANCIÓN DE " + _loc3_ + "!");
         }
         if(_loc2_ == "leaving")
         {
            trace("// YA SE PUEDE ELEGIR EL PROXIMO JUGADOR.",param1.attribute.value);
            if(this.currentPlayingAvatar == room.userAvatar)
            {
               this.nowPlaying.object.attributes["playerName"] = "";
               api.setSession("tengoTurno",false);
               clearTimeout(this.showModalHasTerminadoTimeoutIndex);
               this.showModalHasTerminadoTimeoutIndex = setTimeout(this.showModalHasTerminado,1500);
               clearTimeout(this.moveOutTimeoutIndex);
               this.moveOutTimeoutIndex = setTimeout(this.moveOut,3000);
               this.currentPlayingAvatar = null;
               clearTimeout(this.cleanVarTimeoutIndex);
               this.cleanVarTimeoutIndex = setTimeout(this.cleanVars,8000);
            }
            else
            {
               this.turnManager.refreshTurns(api.avatars);
               if(this.turnManager.amINext())
               {
                  this.gotoPiano();
               }
            }
         }
      }
      
      private function cleanVars() : void
      {
         clearTimeout(this.cleanVarTimeoutIndex);
         api.setAvatarAttribute("message","");
         api.setSession("tengoTurno",false);
      }
      
      override protected function finalInit() : void
      {
         super.finalInit();
         this.piano.object.addCustomAttributeListener("song",this.onPlayPiano);
         room.userAvatar.addCustomAttributeListener("message",this.saveMyTurn);
         this.turnos.object.addCustomAttributeListener("turnos",this.saveOthersTurn);
         if(Context.instance.hasByType(MusicManager))
         {
            this.musicManager = Context.instance.getByType(MusicManager) as MusicManager;
         }
         else
         {
            this.musicManager = new MusicManager();
            Context.instance.addByType(this.musicManager,MusicManager);
         }
         this.cleanVars();
      }
      
      private function saveOthersTurn(param1:CustomAttributeEvent) : void
      {
         var _loc2_:Boolean = this.isATurn(param1.attribute.value.toString());
         if(_loc2_)
         {
            this.turnManager.refreshTurns(api.avatars);
         }
      }
      
      private function saveMyTurn(param1:CustomAttributeEvent) : void
      {
         var _loc2_:Boolean = this.isATurn(param1.attribute.value.toString());
         if(_loc2_)
         {
            this.turnManager.refreshTurns(api.avatars);
            this.turnManager.registerMyTurn(param1.attribute.value as String);
            trace("AntroRoomView > saveMyTurn >  !isSomeonePlaying() " + this.isSomeonePlaying() + "-- && turnManager.amINext():" + this.turnManager.amINext());
            if(!this.isSomeonePlaying() && this.turnManager.amINext())
            {
               this.gotoPiano();
            }
         }
      }
      
      private function showModalSubiATocar() : void
      {
         clearTimeout(this.showModalSubiATocarTimeOutIndex);
         api.showModal("PUEDES SUBIR A TOCAR TU MUSICA","information");
      }
      
      private function isATurn(param1:String) : Boolean
      {
         return Boolean(param1) && param1.indexOf("turno:") != -1;
      }
      
      private function gotoPiano() : void
      {
         this.currentPlayingAvatar = room.userAvatar;
         clearTimeout(this.setAttrMessageTimeoutIndex);
         this.setAttrMessageTimeoutIndex = setTimeout(this.setAttrMessgePlayingPiano,1500);
         clearTimeout(this.showModalSubiATocarTimeOutIndex);
         this.showModalSubiATocarTimeOutIndex = setTimeout(this.showModalSubiATocar,1500);
         clearTimeout(this.moveToPianoTimeoutIndex);
         this.moveToPianoTimeoutIndex = setTimeout(this.movetToPiano,3000);
         this.nowPlaying.object.attributes["playerName"] = api.userAvatar.username;
      }
      
      private function onSongFinished() : void
      {
         var _loc1_:String = null;
         api.textMessageToGUI("HA TERMINADO LA CANCIÓN");
         this.musicManager.stopSequence();
         if(room)
         {
            _loc1_ = room.userAvatar.attributes["message"] as String;
            if(_loc1_ == "finished")
            {
               this.leavePiano();
            }
         }
      }
      
      private function moveOut() : void
      {
         clearTimeout(this.moveOutTimeoutIndex);
         var _loc1_:Array = [room.userAvatar.coord,new Coord(room.userAvatar.coord.x,6)];
         var _loc2_:Path = new Path(_loc1_,new Coord(room.userAvatar.coord.x,6));
         room.userAvatar.moveBy(_loc2_);
      }
      
      private function isSomeonePlaying() : Boolean
      {
         var _loc2_:Avatar = null;
         var _loc3_:String = null;
         var _loc1_:int = 0;
         while(_loc1_ < api.avatars.length)
         {
            _loc2_ = api.avatars[_loc1_];
            _loc3_ = _loc2_.attributes["message"] as String;
            if(_loc3_ && _loc3_.indexOf("playingPiano") != -1 || _loc3_ == "finished")
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
   }
}

import com.qb9.mambo.world.avatars.Avatar;

class TurnManager
{
    
   
   public var myTurnID:Number;
   
   private var turnsInRoom:Array;
   
   public function TurnManager()
   {
      super();
      this.turnsInRoom = new Array();
   }
   
   public function amINext() : Boolean
   {
      trace("CHECKEANDO SI SOY EL PROXIMO: ",this.turnsInRoom,this.myTurnID,this.turnsInRoom[0] == this.myTurnID);
      return this.turnsInRoom[0] == this.myTurnID;
   }
   
   private function removeTurn(param1:Number) : void
   {
      var _loc2_:int = 0;
      while(_loc2_ < this.turnsInRoom.length)
      {
         if(this.turnsInRoom[_loc2_] == param1)
         {
            this.turnsInRoom.splice(_loc2_,1);
            return;
         }
         _loc2_++;
      }
   }
   
   public function refreshTurns(param1:Array) : void
   {
      var _loc3_:Avatar = null;
      var _loc4_:String = null;
      this.turnsInRoom = [];
      var _loc2_:int = 0;
      while(_loc2_ < param1.length)
      {
         _loc3_ = param1[_loc2_];
         if((Boolean(_loc4_ = _loc3_.attributes["message"] as String)) && _loc4_.indexOf("turno:") != -1)
         {
            this.addTurnFromMessage(_loc4_);
         }
         _loc2_++;
      }
   }
   
   private function getTurnFromMessage(param1:String) : Number
   {
      var _loc2_:String = param1.substr(param1.indexOf(":") + 1);
      return Number(_loc2_);
   }
   
   public function removeTurnFromMessage(param1:String) : void
   {
      if(Boolean(param1) && param1.indexOf("turno:") != -1)
      {
         this.removeTurn(this.getTurnFromMessage(param1));
      }
      else
      {
         trace("NO ERA UN TURNO:",param1);
      }
   }
   
   public function registerMyTurn(param1:String) : void
   {
      this.myTurnID = this.getTurnFromMessage(param1);
   }
   
   public function addTurnFromMessage(param1:String, param2:Boolean = false) : void
   {
      if(!param1)
      {
         throw new Error("Can\'t be a null turn data");
      }
      this.turnsInRoom.push(this.getTurnFromMessage(param1));
      this.turnsInRoom.sort(Array.NUMERIC);
      if(param2)
      {
         this.myTurnID = this.getTurnFromMessage(param1);
      }
   }
}

import com.qb9.mambo.core.objects.BaseCustomAttributeDispatcher;
import com.qb9.mambo.world.avatars.Avatar;

class Holder extends BaseCustomAttributeDispatcher
{
    
   
   public function Holder(param1:Avatar)
   {
      super();
      _attributes = param1.attributes.clone(this);
   }
}
