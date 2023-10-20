package com.qb9.gaturro.net.multiplayer
{
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.net.GaturroNetResponses;
   import com.qb9.gaturro.net.requests.multiplayer.MultiplayerActionRequestCreate;
   import com.qb9.gaturro.net.requests.multiplayer.MultiplayerActionRequestDisconnect;
   import com.qb9.gaturro.net.requests.multiplayer.MultiplayerActionRequestJoin;
   import com.qb9.gaturro.net.requests.multiplayer.MultiplayerActionRequestList;
   import com.qb9.gaturro.net.requests.multiplayer.MultiplayerActionRequestListBySlot;
   import com.qb9.gaturro.net.requests.multiplayer.MultiplayerActionRequestMessage;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   
   public class GaturroMultiplayerManager
   {
      
      public static const METHOD_DISCONNECT:String = "out";
      
      public static const METHOD_LIST:String = "list";
      
      public static const METHOD_MESSAGE:String = "message";
      
      public static const METHOD_INIT:String = "init";
      
      public static const METHOD_PARTICIPE:String = "participe";
      
      private static var _instance:com.qb9.gaturro.net.multiplayer.GaturroMultiplayerManager = null;
      
      public static const METHOD_CREATION:String = "creation";
       
      
      private var disconnectMultiplayerCallback:Function = null;
      
      private var getMultiplayerListCallback:Function = null;
      
      private var getMultiplayerListBySlotCallback:Function = null;
      
      private var createMultiplayerCallback:Function = null;
      
      private var multiplayerMessageCallback:Function = null;
      
      private var joinMultiplayerCallback:Function = null;
      
      private var startMultiplayerCallback:Function = null;
      
      public function GaturroMultiplayerManager()
      {
         super();
         net.addEventListener(GaturroNetResponses.MULTIPLAYER_MESSAGE_RECEIVED,this.onResponseMultiplayerMessage);
      }
      
      public static function get instance() : com.qb9.gaturro.net.multiplayer.GaturroMultiplayerManager
      {
         if(_instance == null)
         {
            _instance = new com.qb9.gaturro.net.multiplayer.GaturroMultiplayerManager();
         }
         return _instance;
      }
      
      private function onResponseGetMultiplayerList(param1:NetworkManagerEvent) : void
      {
         var _loc3_:Array = null;
         net.removeEventListener(GaturroNetResponses.MULTIPLAYER_RESPONSE,this.onResponseGetMultiplayerList);
         var _loc2_:Boolean = param1.mobject.getBoolean("sucess");
         if(_loc2_)
         {
            _loc3_ = param1.mobject.getMobjectArray("sessions");
            this.getMultiplayerListCallback(_loc3_);
         }
      }
      
      public function setMultiplayerCallback(param1:Function = null) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.multiplayerMessageCallback = param1;
      }
      
      public function createMultiplayer(param1:String, param2:String, param3:int, param4:Function) : void
      {
         if(param4 == null)
         {
            return;
         }
         this.createMultiplayerCallback = param4;
         net.addEventListener(GaturroNetResponses.MULTIPLAYER_RESPONSE,this.onResponseCreateMultiplayer);
         net.sendAction(new MultiplayerActionRequestCreate(param1,param2,param3));
      }
      
      public function joinMultiplayer(param1:String, param2:String, param3:String, param4:Function) : void
      {
         if(param4 == null)
         {
            return;
         }
         this.joinMultiplayerCallback = param4;
         net.addEventListener(GaturroNetResponses.MULTIPLAYER_RESPONSE,this.onResponseJoinMultiplayer);
         net.sendAction(new MultiplayerActionRequestJoin(param1,param2,param3));
      }
      
      public function multiplayerMessage(param1:String, param2:String, param3:String) : void
      {
         net.sendAction(new MultiplayerActionRequestMessage(param1,param2,param3));
      }
      
      private function onResponseGetMultiplayerListBySlot(param1:NetworkManagerEvent) : void
      {
         var _loc3_:Array = null;
         net.removeEventListener(GaturroNetResponses.MULTIPLAYER_RESPONSE,this.onResponseGetMultiplayerListBySlot);
         var _loc2_:Boolean = param1.mobject.getBoolean("sucess");
         if(_loc2_)
         {
            _loc3_ = param1.mobject.getMobjectArray("sessions");
            if(_loc3_.length)
            {
               this.getMultiplayerListBySlotCallback(_loc3_[0].getStringArray("participants"));
            }
         }
      }
      
      private function onResponseCreateMultiplayer(param1:NetworkManagerEvent) : void
      {
         net.removeEventListener(GaturroNetResponses.MULTIPLAYER_RESPONSE,this.onResponseCreateMultiplayer);
         var _loc2_:Boolean = param1.mobject.getBoolean("sucess");
         this.createMultiplayerCallback(_loc2_);
         if(!_loc2_)
         {
            return;
         }
      }
      
      public function getMultiplayerList(param1:String, param2:Function) : void
      {
         if(param2 == null)
         {
            return;
         }
         this.getMultiplayerListCallback = param2;
         net.addEventListener(GaturroNetResponses.MULTIPLAYER_RESPONSE,this.onResponseGetMultiplayerList);
         net.sendAction(new MultiplayerActionRequestList(param1));
      }
      
      public function disconnectMultiplayer(param1:String, param2:String, param3:Function) : void
      {
         if(param3 == null)
         {
            return;
         }
         this.disconnectMultiplayerCallback = param3;
         net.addEventListener(GaturroNetResponses.MULTIPLAYER_RESPONSE,this.onResponseDisconnectMultiplayer);
         net.sendAction(new MultiplayerActionRequestDisconnect(param1,param2));
      }
      
      private function onResponseMultiplayerMessage(param1:NetworkManagerEvent) : void
      {
         var _loc2_:String = null;
         if(this.multiplayerMessageCallback != null)
         {
            _loc2_ = param1.mobject.getString("message");
            this.multiplayerMessageCallback(_loc2_);
         }
      }
      
      private function onResponseJoinMultiplayer(param1:NetworkManagerEvent) : void
      {
         net.removeEventListener(GaturroNetResponses.MULTIPLAYER_RESPONSE,this.onResponseJoinMultiplayer);
         var _loc2_:Boolean = param1.mobject.getBoolean("sucess");
         net.addEventListener(GaturroNetResponses.MULTIPLAYER_MESSAGE_RECEIVED,this.onResponseMultiplayerMessage);
         this.joinMultiplayerCallback(_loc2_);
      }
      
      public function getMultiplayerListBySlot(param1:String, param2:String, param3:Function) : void
      {
         if(param3 == null)
         {
            return;
         }
         this.getMultiplayerListBySlotCallback = param3;
         net.addEventListener(GaturroNetResponses.MULTIPLAYER_RESPONSE,this.onResponseGetMultiplayerListBySlot);
         net.sendAction(new MultiplayerActionRequestListBySlot(param1,param2));
      }
      
      private function onResponseDisconnectMultiplayer(param1:NetworkManagerEvent) : void
      {
         net.removeEventListener(GaturroNetResponses.MULTIPLAYER_RESPONSE,this.onResponseDisconnectMultiplayer);
         var _loc2_:Boolean = param1.mobject.getBoolean("sucess");
         this.disconnectMultiplayerCallback(_loc2_);
      }
   }
}
