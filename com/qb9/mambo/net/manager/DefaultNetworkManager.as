package com.qb9.mambo.net.manager
{
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.mambo.core.objects.MamboObject;
   import com.qb9.mambo.net.requests.base.MamboRequest;
   import com.qb9.mines.mobject.Mobject;
   import com.qb9.mines.network.MinesServer;
   import com.qb9.mines.network.event.MinesEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class DefaultNetworkManager extends MamboObject implements NetworkManager
   {
      
      private static var preff:String;
      
      private static const MINES_EVENTS:Array = [MinesEvent.CONNECT,MinesEvent.LOGIN,MinesEvent.TIMEOUT,MinesEvent.LOGOUT,MinesEvent.CONNECTION_LOST];
      
      private static var counter:uint = 0;
      
      private static const REQUEST_RESPONSE_MAP:Object = {"LeaveHomeAction":"ChangeRoomAction"};
      
      private static const SHOULD_WAIT_RESPONSE:Array = ["RoomData","ChangeRoomAction","LeaveHomeAction"];
       
      
      private var mines:MinesServer;
      
      private var retries:Object;
      
      private var pending:Array;
      
      private var canceled:Array;
      
      private var timeoutTimersIds:Object;
      
      private var timeouts:Object;
      
      public function DefaultNetworkManager(param1:uint = 0, param2:Object = null)
      {
         var _loc3_:String = null;
         super();
         this.mines = new MinesServer(false,param1);
         this.mines.addEventListener(MinesEvent.MESSAGE,this.handleMamboEvent);
         this.timeouts = param2 || {};
         this.timeoutTimersIds = {};
         this.retries = {};
         this.pending = [];
         this.canceled = [];
         for each(_loc3_ in MINES_EVENTS)
         {
            this.mines.addEventListener(_loc3_,this.handleMinesEvent);
         }
      }
      
      public function login(param1:String, param2:String) : void
      {
         info("Logging in as",param1);
         this.registerLoginTimer();
         param1 = param1.toUpperCase();
         this.mines.login(param1,param2);
      }
      
      public function handleMinesEvent(param1:MinesEvent) : void
      {
         this.unregisterTimer(param1.type);
         this.handleEvent(param1.type,param1.mobject,param1.success,param1.errorCode);
      }
      
      protected function sendMobject(param1:Mobject) : void
      {
         var _loc2_:String = param1.getString("messageId");
         var _loc3_:String = param1.getString("request");
         if(_loc3_ in this.timeouts)
         {
            this.registerTimer(_loc2_,_loc3_,param1);
         }
         debug("Sending action",_loc3_);
         dispatchEvent(new NetworkManagerEvent(NetworkManagerEvent.ACTION_SENT,param1));
         if(this.shouldWaitResponse(_loc3_))
         {
            ArrayUtil.addUnique(this.pending,this.responseFor(this.cleanRequestName(_loc3_)) + _loc2_);
         }
         this.mines.sendMobject(param1);
      }
      
      public function logWithID(param1:String) : void
      {
         info("Logging with id",param1);
         this.registerLoginTimer();
         this.mines.loginWithId(param1);
      }
      
      private function responseFor(param1:String) : String
      {
         if(param1 in REQUEST_RESPONSE_MAP)
         {
            return REQUEST_RESPONSE_MAP[param1];
         }
         return param1;
      }
      
      private function cleanRequestName(param1:String) : String
      {
         return param1.replace(/request|response/i,"");
      }
      
      public function logout() : void
      {
         info("Logging out");
         this.mines.logout();
      }
      
      private function unregisterTimer(param1:String) : Boolean
      {
         if(param1 in this.timeoutTimersIds)
         {
            clearTimeout(this.timeoutTimersIds[param1]);
            delete this.timeoutTimersIds[param1];
            return true;
         }
         return false;
      }
      
      private function isPending(param1:String) : Boolean
      {
         return ArrayUtil.contains(this.pending,param1);
      }
      
      private function registerTimer(param1:String, param2:String, param3:Mobject = null) : void
      {
         if(this.unregisterTimer(param1))
         {
            warning("Registering timer for existent id, duplicate ids generated?");
         }
         this.timeoutTimersIds[param1] = setTimeout(this.requestTimeout,this.timeouts[param2].timeout * 1000,param1,param2,param3);
         if(!(param1 in this.retries))
         {
            this.retries[param1] = this.timeouts[param2].retries || 0;
         }
      }
      
      private function handleEvent(param1:String, param2:Mobject, param3:Boolean, param4:String) : void
      {
         if(param3)
         {
            debug("Received successful",param1,"(" + (!!param2 ? param2.getString("messageId") : "no mo") + ")");
         }
         else
         {
            warning("Received a failing",param1 + (!!param4 ? ":" + param4 : ""));
         }
         dispatchEvent(new NetworkManagerEvent(param1,param2,param3,param4));
      }
      
      private function handleMamboEvent(param1:MinesEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Boolean = false;
         var _loc2_:Mobject = param1.mobject;
         _loc3_ = _loc2_.getString("messageId");
         _loc4_ = _loc2_.getString("type");
         this.unregisterTimer(_loc3_);
         if(!(_loc5_ = _loc2_.getBoolean("forceProcess")))
         {
            if(this.shouldWaitResponse(_loc4_) && !this.isPending(this.cleanRequestName(_loc4_) + _loc3_))
            {
               return;
            }
            if(this.wasCanceled(_loc3_))
            {
               return;
            }
         }
         this.markAsHandled(this.cleanRequestName(_loc4_) + _loc3_);
         this.handleEvent(_loc2_.getString("type"),_loc2_,_loc2_.hasBoolean("success") ? _loc2_.getBoolean("success") : true,_loc2_.getString("errorCode") || _loc2_.getString("errorMessage"));
      }
      
      private function markAsHandled(param1:String) : void
      {
         ArrayUtil.removeElement(this.pending,param1);
      }
      
      public function sendAction(param1:MamboRequest) : void
      {
         var _loc2_:Mobject = param1.toMobject();
         var _loc3_:String = this.generateId();
         _loc2_.setString("request",param1.type);
         _loc2_.setString("messageId",_loc3_);
         this.sendMobject(_loc2_);
         dispatchEvent(new NetworkManagerEvent(NetworkManagerEvent.UNIQUE_ACTION_SENT,_loc2_));
      }
      
      private function registerLoginTimer() : void
      {
         if(MinesEvent.LOGIN in this.timeouts)
         {
            this.registerTimer(MinesEvent.LOGIN,MinesEvent.LOGIN);
         }
      }
      
      private function wasCanceled(param1:String) : Boolean
      {
         return ArrayUtil.contains(this.canceled,param1);
      }
      
      override public function dispose() : void
      {
         var _loc1_:String = null;
         this.mines.removeEventListener(MinesEvent.MESSAGE,this.handleMamboEvent);
         for each(_loc1_ in MINES_EVENTS)
         {
            this.mines.removeEventListener(_loc1_,this.handleMinesEvent);
         }
         this.mines.dispose();
         this.mines = null;
         super.dispose();
      }
      
      private function retry(param1:Mobject) : void
      {
         var _loc2_:String = null;
         if(!param1)
         {
            warning("Attempted to retry a null Mobject. Ignoring.");
            return;
         }
         _loc2_ = param1.getString("request");
         if(!this.shouldWaitResponse(_loc2_))
         {
            warning("Attempted to retry a non-retryable request. Ignoring.");
            return;
         }
         debug("Retrying action",_loc2_);
         this.sendMobject(param1);
      }
      
      public function connect(param1:String, param2:uint) : void
      {
         info("Connecting to",param1 + ":" + param2);
         this.mines.connect(param1,param2);
      }
      
      private function requestTimeout(param1:String, param2:String, param3:Mobject) : void
      {
         this.unregisterTimer(param1);
         if(this.retries[param1])
         {
            --this.retries[param1];
            this.retry(param3);
         }
         else
         {
            warning("Request timedout, id",param1);
            delete this.retries[param1];
            this.cancel(param3);
            dispatchEvent(new RequestTimeoutEvent(RequestTimeoutEvent.TIMEOUT,param2,param3));
         }
      }
      
      private function generateId() : String
      {
         preff = preff || new Date().getTime() + "_";
         return preff + counter++;
      }
      
      private function shouldWaitResponse(param1:String) : Boolean
      {
         return ArrayUtil.contains(SHOULD_WAIT_RESPONSE,this.cleanRequestName(param1));
      }
      
      private function cancel(param1:Mobject) : void
      {
         ArrayUtil.addUnique(this.canceled,param1.getString("messageId"));
      }
   }
}
