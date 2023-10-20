package com.qb9.gaturro.world.quest
{
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.util.xmprpc.XMLRPCDataTypes;
   import com.qb9.gaturro.util.xmprpc.services.ServicesConnection;
   import flash.events.Event;
   
   public class QuestConnection extends ServicesConnection
   {
       
      
      public function QuestConnection(param1:Function = null, param2:Function = null)
      {
         super(param1,param2);
      }
      
      public function getStarData(param1:String, param2:Number) : void
      {
         this.usernameConsulted = param1;
         this.addParam(param1,XMLRPCDataTypes.STRING);
         applySecurity();
         this.addParam(param2.toString(),XMLRPCDataTypes.STRING);
         sendMessage("getStarData",this.completeGetData);
      }
      
      public function getStarRank(param1:String) : void
      {
         this.usernameConsulted = param1;
         this.addParam(param1,XMLRPCDataTypes.STRING);
         applySecurity();
         sendMessage("getStarRank",this.completeRank);
      }
      
      private function completeRank(param1:Array) : void
      {
         var _loc5_:Array = null;
         var _loc2_:Object = {};
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1[_loc4_].split("|");
            _loc3_.push({
               "username":_loc5_[0],
               "creative":_loc5_[1],
               "skill":_loc5_[4],
               "friendly":_loc5_[2],
               "elegant":_loc5_[3],
               "respectable":_loc5_[5]
            });
            _loc4_++;
         }
         _loc2_["data"] = _loc3_;
         if(successCallback != null)
         {
            successCallback(this.usernameConsulted,_loc2_);
         }
      }
      
      private function completeGetData(param1:Array) : void
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
         if(successCallback != null)
         {
            successCallback(this.usernameConsulted,_loc2_);
         }
      }
      
      public function saveStarData(param1:String, param2:Number, param3:int, param4:int, param5:int, param6:int, param7:int) : void
      {
         this.usernameConsulted = param1;
         this.addParam(param1,XMLRPCDataTypes.STRING);
         this.addParam(param2.toString(),XMLRPCDataTypes.STRING);
         this.addParam(param3.toString(),XMLRPCDataTypes.STRING);
         this.addParam(param4.toString(),XMLRPCDataTypes.STRING);
         this.addParam(param5.toString(),XMLRPCDataTypes.STRING);
         this.addParam(param6.toString(),XMLRPCDataTypes.STRING);
         this.addParam(param7.toString(),XMLRPCDataTypes.STRING);
         applySecurity();
         sendMessage("saveStarData");
      }
      
      override protected function removeListeners() : void
      {
         this.removeEventListener(Event.COMPLETE,this.completeGetData);
         super.removeListeners();
      }
      
      override protected function get urlApi() : String
      {
         return settings.services.quest.api;
      }
   }
}
