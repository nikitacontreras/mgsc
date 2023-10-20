package com.qb9.gaturro.world.community.service
{
   import com.adobe.serialization.json.JSON;
   import com.adobe.serialization.json.JSONDecoder;
   import com.qb9.gaturro.globals.*;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   
   public class FriendshipConnection extends EventDispatcher
   {
       
      
      private var myUsername:String;
      
      private var _response:URLLoader;
      
      private var successCallback:Function;
      
      private var errorCallback:Function;
      
      private var managerCallback:Function;
      
      private var buddyUsername:String;
      
      public function FriendshipConnection(param1:Function = null, param2:Function = null)
      {
         super();
         this.successCallback = param1;
         this.errorCallback = param2;
         this._response = new URLLoader();
         this.addListeners();
      }
      
      protected function get urlApi() : String
      {
         return settings.services.community.api;
      }
      
      private function _onLoad(param1:Event) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         logger.debug("Amigos-> onLoad FrienshipConnection: " + this._response.data);
         var _loc2_:JSONDecoder = new JSONDecoder(this._response.data,true);
         var _loc3_:Object = _loc2_.getValue();
         if("meta" in _loc3_)
         {
            _loc4_ = String(_loc3_.meta.apiVersion);
            _loc5_ = int(_loc3_.meta.code);
            _loc6_ = _loc3_.meta.errors;
         }
         if("response" in _loc3_)
         {
            if("friendshipList" in _loc3_.response)
            {
               logger.debug("Amigos-> Obtengo la lista de amigos: " + _loc3_.response.friendshipList);
               _loc7_ = 0;
               _loc8_ = 0;
               _loc9_ = 0;
               if("paging" in _loc3_.response)
               {
                  _loc7_ = int(_loc3_.response.paging.offset);
                  _loc8_ = int(_loc3_.response.paging.total);
                  _loc9_ = int(_loc3_.response.paging.max);
               }
               this.successCallback(this.myUsername,_loc3_.response.friendshipList,_loc7_,_loc9_,_loc8_);
            }
            if("friendship" in _loc3_.response)
            {
               logger.debug("Amigos-> Agrego un amiguito: " + _loc3_.response.friendship);
               this.successCallback(this.myUsername,_loc3_.response.friendship);
            }
            if("deleted" in _loc3_.response)
            {
               if(_loc3_.response.deleted == true)
               {
                  logger.debug("Amigos-> Borré a mi amigo: " + this.buddyUsername);
                  this.successCallback(this.myUsername,this.buddyUsername);
               }
               else
               {
                  this.errorCallback();
               }
            }
         }
      }
      
      public function sendFriendRequest(param1:String, param2:String, param3:String, param4:int) : void
      {
         this.buddyUsername = param3;
         this.myUsername = param1;
         var _loc5_:String = this.urlApi + "?access_token=" + param2;
         var _loc6_:URLRequest;
         (_loc6_ = new URLRequest(_loc5_)).contentType = "application/json";
         var _loc7_:Object;
         (_loc7_ = new Object()).friendId = param4;
         _loc6_.data = com.adobe.serialization.json.JSON.encode(_loc7_);
         _loc6_.method = URLRequestMethod.POST;
         _loc6_.url = _loc5_;
         this._response.load(_loc6_);
         logger.debug("Amigos-> sendFriendRequest: POST " + _loc5_ + ", {\"friendId\":" + param4 + "}");
      }
      
      private function _onError(param1:Event) : void
      {
         logger.debug("Amigos-> FALLÓ: " + param1.toString());
         this.removeListeners();
         this.errorCallback();
      }
      
      public function getBuddiesWholeList(param1:String, param2:String) : void
      {
         this.myUsername = param1;
         var _loc3_:int = new Date().getTime();
         var _loc4_:String = this.urlApi + "?access_token=" + param2 + "&timestamp=" + _loc3_;
         var _loc5_:URLRequest;
         (_loc5_ = new URLRequest(_loc4_)).contentType = "text/xml";
         _loc5_.method = URLRequestMethod.GET;
         _loc5_.url = _loc4_;
         logger.debug("Amigos-> getBuddiesList: GET " + _loc4_);
         this._response.load(_loc5_);
      }
      
      public function removeFriend(param1:String, param2:String, param3:String, param4:int) : void
      {
         this.buddyUsername = param3;
         this.myUsername = param1;
         var _loc5_:String = this.urlApi + "/" + param4 + "/delete?access_token=" + param2;
         var _loc6_:URLRequest;
         (_loc6_ = new URLRequest(_loc5_)).contentType = "application/json";
         var _loc7_:Object;
         (_loc7_ = new Object()).friendId = param4;
         _loc6_.data = com.adobe.serialization.json.JSON.encode(_loc7_);
         _loc6_.method = URLRequestMethod.POST;
         _loc6_.url = _loc5_;
         logger.debug("Amigos-> removeFriend: POST" + _loc5_ + ", {\"deleteUserId\":" + param4 + "}");
         this._response.load(_loc6_);
      }
      
      public function getFriend(param1:String, param2:String, param3:String, param4:int) : void
      {
         this.myUsername = param1;
         var _loc5_:int = new Date().getTime();
         var _loc6_:String = this.urlApi + "/" + param4 + "?access_token=" + param2 + "&timestamp=" + _loc5_;
         var _loc7_:URLRequest;
         (_loc7_ = new URLRequest(_loc6_)).contentType = "text/xml";
         _loc7_.method = URLRequestMethod.GET;
         _loc7_.url = _loc6_;
         logger.debug("Amigos-> getBuddy: GET " + _loc6_);
         this._response.load(_loc7_);
      }
      
      private function removeListeners() : void
      {
         this._response.removeEventListener(Event.COMPLETE,this._onLoad);
         this._response.removeEventListener(IOErrorEvent.IO_ERROR,this._onError);
         this._response.removeEventListener(IOErrorEvent.NETWORK_ERROR,this._onError);
         this._response.removeEventListener(IOErrorEvent.VERIFY_ERROR,this._onError);
         this._response.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this._onError);
         this._response = null;
      }
      
      private function addListeners() : void
      {
         this._response.addEventListener(Event.COMPLETE,this._onLoad);
         this._response.addEventListener(IOErrorEvent.IO_ERROR,this._onError);
         this._response.addEventListener(IOErrorEvent.NETWORK_ERROR,this._onError);
         this._response.addEventListener(IOErrorEvent.VERIFY_ERROR,this._onError);
         this._response.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this._onError);
      }
      
      public function getBuddiesBlock(param1:String, param2:String, param3:int, param4:int) : void
      {
         this.myUsername = param1;
         var _loc5_:int = new Date().getTime();
         var _loc6_:String = this.urlApi + "?offset=" + param3 + "&max=" + param4 + "&access_token=" + param2 + "&timestamp=" + _loc5_;
         var _loc7_:URLRequest;
         (_loc7_ = new URLRequest(_loc6_)).contentType = "text/xml";
         _loc7_.method = URLRequestMethod.GET;
         _loc7_.url = _loc6_;
         logger.debug("Amigos-> getBuddiesList: GET " + _loc6_);
         this._response.load(_loc7_);
      }
   }
}
