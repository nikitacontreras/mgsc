package com.qb9.mambo.net.manager.simulated
{
   import com.qb9.mambo.core.objects.MamboObject;
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   import com.qb9.mambo.net.requests.base.MamboRequest;
   import com.qb9.mines.mobject.Mobject;
   import com.qb9.mines.mobject.MobjectCreator;
   import com.qb9.mines.network.event.MinesEvent;
   import flash.utils.setTimeout;
   
   public class SimulatedNetworkManager extends MamboObject implements NetworkManager
   {
       
      
      private var creator:MobjectCreator;
      
      private var latency:uint;
      
      public function SimulatedNetworkManager(param1:uint = 1)
      {
         super();
         this.latency = param1;
         this.init();
      }
      
      private function informMobject(param1:String, param2:Mobject) : void
      {
         param2.setString("type",param1);
         dispatchEvent(new NetworkManagerEvent(param1,param2,this.getSuccess(param2),param2.getString("errorCode")));
      }
      
      public function logWithID(param1:String) : void
      {
         info("Logging with id",param1);
         this.handleConnectionStep(MinesEvent.LOGIN);
      }
      
      private function informRequest(param1:MamboRequest) : void
      {
         dispatchEvent(new NetworkManagerEvent(param1.type,param1.toMobject()));
      }
      
      public function response(param1:String, param2:Object = null) : void
      {
         this.mobjectResponse(param1,!!param2 ? this.creator.convert(param2) : new Mobject());
      }
      
      public function login(param1:String, param2:String) : void
      {
         info("Logging in as",param1 + ":" + param2);
         this.handleConnectionStep(MinesEvent.LOGIN);
      }
      
      public function connect(param1:String, param2:uint) : void
      {
         info("Connecting to",param1 + ":" + param2);
         this.handleConnectionStep(MinesEvent.CONNECT);
      }
      
      private function getSuccess(param1:Mobject) : Boolean
      {
         return param1.hasBoolean("success") ? param1.getBoolean("success") : true;
      }
      
      public function mobjectResponse(param1:String, param2:Mobject) : void
      {
         var _loc3_:String = String(param2.getString("errorCode") || param2.getString("errorMessage"));
         if(this.getSuccess(param2))
         {
            debug("Received successful",param1);
         }
         else
         {
            warning("Received a failing",param1 + (!!_loc3_ ? ":" + _loc3_ : ""));
         }
         this.informMobject(param1,param2);
      }
      
      private function init() : void
      {
         this.creator = new MobjectCreator();
      }
      
      protected function handleConnectionStep(param1:String) : void
      {
         this.informMobject(param1,new Mobject());
      }
      
      public function sendAction(param1:MamboRequest) : void
      {
         debug("Sending action",param1.type);
         if(this.latency)
         {
            setTimeout(this.informRequest,this.latency,param1);
         }
         else
         {
            this.informRequest(param1);
         }
      }
      
      public function logout() : void
      {
         info("Logging out");
         this.handleConnectionStep(MinesEvent.LOGOUT);
      }
      
      override public function dispose() : void
      {
         this.creator = null;
         super.dispose();
      }
   }
}
