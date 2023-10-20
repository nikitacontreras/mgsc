package com.qb9.mambo.queue
{
   import com.qb9.flashlib.collections.Set;
   import com.qb9.flashlib.lang.foreach;
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.mambo.core.objects.MamboObject;
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   import com.qb9.mambo.net.requests.queue.ForceStartGameActionRequest;
   import com.qb9.mambo.net.requests.queue.JoinQueueActionRequest;
   import com.qb9.mambo.net.requests.queue.RemoveFromQueueActionRequest;
   import com.qb9.mambo.user.User;
   import com.qb9.mines.mobject.Mobject;
   
   public final class WaitingQueue extends MamboObject
   {
       
      
      private var _subscribed:Boolean = false;
      
      private var names:Set;
      
      private var user:User;
      
      private var id:Number;
      
      private var net:NetworkManager;
      
      private var _minPlayers:int;
      
      private var _serverLogin:com.qb9.mambo.queue.ServerLoginData;
      
      private var _name:String;
      
      private var game:String;
      
      public function WaitingQueue(param1:NetworkManager, param2:User, param3:Number, param4:String)
      {
         super();
         this.net = param1;
         this.user = param2;
         this.id = param3;
         this._name = param4;
      }
      
      public function get size() : uint
      {
         return this.names.size;
      }
      
      private function isOwnEvent(param1:NetworkManagerEvent) : Boolean
      {
         return param1.mobject.getInteger("queueId") === this.id;
      }
      
      public function get minPlayers() : int
      {
         return this._minPlayers;
      }
      
      private function initEvents() : void
      {
         this.net.addEventListener(NetworkManagerEvent.QUEUE_CREATED,this.whenCreated);
         this.net.addEventListener(NetworkManagerEvent.USER_ADDED_TO_QUEUE,this.whenUserIsAdded);
         this.net.addEventListener(NetworkManagerEvent.USER_REMOVED_FROM_QUEUE,this.whenUserIsRemoved);
         this.net.addEventListener(NetworkManagerEvent.QUEUE_FAILED,this.whenFailed);
         this.net.addEventListener(NetworkManagerEvent.QUEUE_READY,this.whenReady);
      }
      
      public function subscribe() : void
      {
         info("Subscribing to",this.name);
         this.initEvents();
         this._subscribed = true;
         this.net.sendAction(new JoinQueueActionRequest(this.id,this.name));
      }
      
      public function get users() : Array
      {
         return !!this.names ? this.names.toArray() : null;
      }
      
      private function cancelled() : void
      {
         debug("Leaving queue",this.name);
         this._subscribed = false;
         this.dispatch(WaitingQueueEvent.CANCELLED);
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      private function whenCreated(param1:NetworkManagerEvent) : void
      {
         if(!this.isOwnEvent(param1))
         {
            return;
         }
         if(!param1.success)
         {
            return warning("Could not join to a queue for",this.name);
         }
         var _loc2_:Mobject = param1.mobject;
         var _loc3_:Array = _loc2_.getStringArray("currentUsers");
         this.names = new Set(_loc2_.getInteger("queueSize"));
         this.game = _loc2_.getString("game");
         this._minPlayers = _loc2_.getInteger("minPlayers");
         debug("Subscribed to queue",this.name,"for game",this.game,"with users",_loc3_.join(", "));
         foreach(_loc3_,this.names.add);
         this.dispatch(WaitingQueueEvent.CREATED);
         this.changed();
      }
      
      private function whenFailed(param1:NetworkManagerEvent) : void
      {
         if(this.isOwnEvent(param1))
         {
            warning("Queue launch failed:",param1.errorCode);
            this.cancelled();
         }
      }
      
      private function whenUserIsAdded(param1:NetworkManagerEvent) : void
      {
         if(!this.isOwnEvent(param1))
         {
            return;
         }
         var _loc2_:String = param1.mobject.getString("username");
         debug(_loc2_,"joined queue",this.name);
         this.names.add(_loc2_);
         this.changed();
         this.dispatch(WaitingQueueEvent.ADDED,_loc2_);
      }
      
      public function get subscribed() : Boolean
      {
         return this._subscribed;
      }
      
      final override public function dispatch(param1:String, param2:* = null) : Boolean
      {
         return dispatchEvent(new WaitingQueueEvent(param1,param2));
      }
      
      public function unsubscribe() : void
      {
         info("Unsubscribing from",this.name);
         this._subscribed = false;
         this.net.sendAction(new RemoveFromQueueActionRequest(this.id,this.name));
      }
      
      private function whenReady(param1:NetworkManagerEvent) : void
      {
         if(!this.isOwnEvent(param1))
         {
            return;
         }
         debug("Queue",this.name,"is ready");
         this._subscribed = false;
         this._serverLogin = new com.qb9.mambo.queue.ServerLoginData(this.game);
         this.serverLogin.buildFromMobject(param1.mobject);
         this.dispatch(WaitingQueueEvent.READY,this.serverLogin);
      }
      
      public function get serverLogin() : com.qb9.mambo.queue.ServerLoginData
      {
         return this._serverLogin;
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         this.net = null;
         this.user = null;
         if(this.names)
         {
            this.names.dispose();
         }
         this.names = null;
         super.dispose();
      }
      
      private function whenUserIsRemoved(param1:NetworkManagerEvent) : void
      {
         if(!this.isOwnEvent(param1))
         {
            return;
         }
         var _loc2_:String = param1.mobject.getString("username");
         if(StringUtil.icompare(_loc2_,this.user.username))
         {
            this.cancelled();
         }
         else
         {
            debug(_loc2_,"left queue",this.name);
            this.names.remove(_loc2_);
            this.changed();
            this.dispatch(WaitingQueueEvent.REMOVED,_loc2_);
         }
      }
      
      private function changed() : void
      {
         this.dispatch(WaitingQueueEvent.CHANGED,this.users);
      }
      
      public function forceStart() : void
      {
         debug("Forcing start for queue",this.name);
         this.net.sendAction(new ForceStartGameActionRequest(this.id,this.name));
      }
      
      private function removeEvents() : void
      {
         this.net.removeEventListener(NetworkManagerEvent.QUEUE_CREATED,this.whenCreated);
         this.net.removeEventListener(NetworkManagerEvent.USER_ADDED_TO_QUEUE,this.whenUserIsAdded);
         this.net.removeEventListener(NetworkManagerEvent.USER_REMOVED_FROM_QUEUE,this.whenUserIsRemoved);
         this.net.removeEventListener(NetworkManagerEvent.QUEUE_FAILED,this.whenFailed);
         this.net.removeEventListener(NetworkManagerEvent.QUEUE_READY,this.whenReady);
      }
   }
}
