package com.qb9.gaturro.world.achievements.service
{
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.util.xmprpc.XMLRPCDataTypes;
   import com.qb9.gaturro.util.xmprpc.services.ServicesConnection;
   import flash.events.Event;
   
   public class AchievConnection extends ServicesConnection
   {
       
      
      private var keyUsed:String = "";
      
      public function AchievConnection(param1:Function = null, param2:Function = null)
      {
         super(param1,param2);
      }
      
      override protected function removeListeners() : void
      {
         this.removeEventListener(Event.COMPLETE,this.complete);
         super.removeListeners();
      }
      
      public function getAllData(param1:String, param2:Number) : void
      {
         this.usernameConsulted = param1;
         this.addParam(user.username,XMLRPCDataTypes.STRING);
         applySecurity();
         this.addParam(param2.toString(),XMLRPCDataTypes.STRING);
         sendMessage("getAllData",this.complete);
      }
      
      public function saveData(param1:String, param2:String, param3:String) : void
      {
         this.keyUsed = param2;
         this.addParam(param1,XMLRPCDataTypes.STRING);
         this.addParam(param2,XMLRPCDataTypes.STRING);
         this.addParam(param3,XMLRPCDataTypes.STRING);
         applySecurity();
         this.addParam(user.id.toString(),XMLRPCDataTypes.STRING);
         sendMessage("saveData",this.complete);
      }
      
      private function complete(param1:Array) : void
      {
         var _loc2_:Object = {};
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(_loc3_ + 1 < param1.length)
            {
               _loc2_[String(param1[_loc3_])] = String(param1[_loc3_ + 1]);
            }
            _loc3_ += 2;
         }
         if(this.keyUsed != "")
         {
            _loc2_["key"] = this.keyUsed;
         }
         if(successCallback != null)
         {
            successCallback(this.usernameConsulted,_loc2_);
         }
      }
      
      override protected function get urlApi() : String
      {
         return settings.services.achievements.api;
      }
   }
}
