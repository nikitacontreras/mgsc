package com.qb9.mines.network
{
   import com.qb9.mines.io.MinesOutputStream;
   import com.qb9.mines.mobject.Mobject;
   import com.qb9.mines.network.event.MinesEvent;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.clearInterval;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   
   public class MinesServer extends EventDispatcher
   {
      
      private static const TIMEOUT_INTERVAL:uint = 1000;
      
      private static const RESPONSE_TYPE_MAPPING:Object = {
         "login":MinesEvent.LOGIN,
         "logout":MinesEvent.LOGOUT,
         "data":MinesEvent.MESSAGE,
         "ping":""
      };
       
      
      private var message:com.qb9.mines.network.Message;
      
      private var sentStamp:int = 0;
      
      private var socket:Socket;
      
      private var debug:Boolean;
      
      private var timeoutId:int;
      
      private var timeout:uint;
      
      private var receivedStamp:int = 0;
      
      public function MinesServer(param1:Boolean = true, param2:uint = 0)
      {
         super();
         this.debug = param1;
         this.timeout = param2;
         this.init();
      }
      
      private function connectHandler(param1:Event) : void
      {
         this.dispatch(MinesEvent.CONNECT);
      }
      
      private function send(param1:Mobject) : void
      {
         var _loc2_:MinesOutputStream = new MinesOutputStream();
         _loc2_.writeMobject(param1);
         this.socket.writeByte(com.qb9.mines.network.Message.HEADER_TYPE);
         this.socket.writeInt(_loc2_.length);
         this.socket.writeBytes(_loc2_,0,_loc2_.length);
         this.socket.flush();
         this.log("MINES DEBUG: Sending",param1);
         if(!this.waitingForAReply)
         {
            this.sentStamp = getTimer();
         }
      }
      
      private function initEvents() : void
      {
         this.socket.addEventListener(Event.CLOSE,this.closeHandler);
         this.socket.addEventListener(Event.CONNECT,this.connectHandler);
         this.socket.addEventListener(IOErrorEvent.IO_ERROR,this.failedConnectHandler);
         this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.failedConnectHandler);
         this.socket.addEventListener(ProgressEvent.SOCKET_DATA,this.socketDataHandler);
      }
      
      public function loginWithId(param1:String) : void
      {
         var _loc2_:Mobject = new Mobject();
         _loc2_.setString("type","login");
         _loc2_.setString("hash",param1);
         this.send(_loc2_);
      }
      
      private function socketDataHandler(param1:ProgressEvent) : void
      {
         var _loc2_:int = 0;
         this.receivedStamp = getTimer();
         while(Boolean(this.socket) && this.socket.bytesAvailable > 0)
         {
            if(!this.message)
            {
               _loc2_ = this.socket.readByte();
               if(_loc2_ !== com.qb9.mines.network.Message.HEADER_TYPE)
               {
                  return this.log("MINES ERROR: Read header",String.fromCharCode(_loc2_) + "[" + _loc2_ + "]");
               }
               this.message = new com.qb9.mines.network.Message();
            }
            if(this.message.needsPayload())
            {
               if(this.socket.bytesAvailable < 4)
               {
                  return;
               }
               this.message.setPayload(this.socket.readInt());
            }
            this.message.read(this.socket);
            if(this.message.isComplete())
            {
               this.processMessage(this.message);
               this.message = null;
            }
         }
      }
      
      public function get connected() : Boolean
      {
         return !this.disposed && this.socket.connected;
      }
      
      public function logout() : void
      {
         var _loc1_:Mobject = new Mobject();
         _loc1_.setString("type","logout");
         this.send(_loc1_);
      }
      
      private function log(... rest) : void
      {
         if(this.debug)
         {
            trace.apply(null,rest);
         }
      }
      
      private function init() : void
      {
         this.socket = new Socket();
         this.initEvents();
         if(this.timeout)
         {
            this.timeoutId = setInterval(this.checkTimeout,TIMEOUT_INTERVAL);
         }
      }
      
      private function processMessage(param1:com.qb9.mines.network.Message) : void
      {
         var _loc2_:Mobject = param1.toMobject();
         var _loc3_:String = _loc2_.getString("type");
         var _loc4_:String = String(RESPONSE_TYPE_MAPPING[_loc3_]);
         switch(_loc4_)
         {
            case "":
               break;
            case null:
               this.log("MINES ERROR: Unexpected type",_loc3_);
               break;
            default:
               this.dispatch(_loc4_,_loc2_.getBoolean("result"),_loc2_.getString("errorCode"),_loc2_.getMobject("mobject"));
         }
      }
      
      private function failedConnectHandler(param1:Event) : void
      {
         this.dispatch(MinesEvent.CONNECT,false,param1.type);
      }
      
      public function dispose() : void
      {
         this.clean();
         this.socket = null;
         this.message = null;
      }
      
      private function get waitingForAReply() : Boolean
      {
         return this.sentStamp !== 0 && this.sentStamp >= this.receivedStamp;
      }
      
      public function login(param1:String, param2:String) : void
      {
         var _loc3_:Mobject = new Mobject();
         _loc3_.setString("type","login");
         _loc3_.setString("username",param1);
         _loc3_.setString("password",param2);
         this.send(_loc3_);
      }
      
      public function connect(param1:String, param2:int) : void
      {
         this.socket.connect(param1,param2);
      }
      
      private function clean() : void
      {
         if(this.disposed)
         {
            return;
         }
         this.socket.removeEventListener(Event.CLOSE,this.closeHandler);
         this.socket.removeEventListener(Event.CONNECT,this.connectHandler);
         this.socket.removeEventListener(IOErrorEvent.IO_ERROR,this.failedConnectHandler);
         this.socket.removeEventListener(ProgressEvent.SOCKET_DATA,this.socketDataHandler);
         if(this.connected)
         {
            this.socket.close();
         }
         clearInterval(this.timeoutId);
      }
      
      private function get disposed() : Boolean
      {
         return this.socket === null;
      }
      
      public function sendMobject(param1:Mobject) : void
      {
         var _loc2_:Mobject = new Mobject();
         _loc2_.setString("type","data");
         _loc2_.setMobject("mobject",param1);
         this.send(_loc2_);
      }
      
      private function closeHandler(param1:Event) : void
      {
         this.dispatch(MinesEvent.CONNECTION_LOST);
      }
      
      private function checkTimeout() : void
      {
         if(this.waitingForAReply && getTimer() - this.sentStamp >= this.timeout)
         {
            this.sentStamp = getTimer();
            this.dispatch(MinesEvent.TIMEOUT);
         }
      }
      
      private function dispatch(param1:String, param2:Boolean = true, param3:String = null, param4:Mobject = null) : void
      {
         dispatchEvent(new MinesEvent(param1,param2,param3,param4));
      }
   }
}
