package com.qb9.gaturro.world.parties.service
{
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.util.xmprpc.XMLRPCDataTypes;
   import com.qb9.gaturro.util.xmprpc.services.ServicesConnection;
   import flash.events.Event;
   
   public class PartiesConnection extends ServicesConnection
   {
       
      
      public function PartiesConnection(param1:Function = null, param2:Function = null)
      {
         super(param1,param2);
      }
      
      private function completeGetPopularity(param1:Array) : void
      {
         var _loc2_:Object = {
            "popularity":param1[0],
            "abilitiesStr":param1[1]
         };
         if(successCallback != null)
         {
            successCallback(this.usernameConsulted,_loc2_);
         }
      }
      
      public function getPopularity() : void
      {
         this.addParam(user.username,XMLRPCDataTypes.STRING);
         applySecurity();
         this.addParam(user.id.toString(),XMLRPCDataTypes.STRING);
         sendMessage("getPopularity",this.completeGetPopularity);
      }
      
      private function completeCreate(param1:Array) : void
      {
         var _loc2_:Object = {"roomId":int(param1[1])};
         if(successCallback != null)
         {
            successCallback(this.usernameConsulted,_loc2_);
         }
      }
      
      private function completeSetPopularity(param1:Array) : void
      {
      }
      
      public function setPopularity(param1:int, param2:String) : void
      {
         this.addParam(user.username,XMLRPCDataTypes.STRING);
         applySecurity();
         this.addParam(user.id.toString(),XMLRPCDataTypes.STRING);
         this.addParam(param1.toString(),XMLRPCDataTypes.STRING);
         this.addParam(param2,XMLRPCDataTypes.STRING);
         sendMessage("setPopularity",this.completeSetPopularity);
      }
      
      private function completePartiesList(param1:Array) : void
      {
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:Number = NaN;
         var _loc8_:Boolean = false;
         var _loc9_:String = null;
         var _loc10_:Array = null;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc2_:Object = {};
         var _loc3_:int = 1;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = int(param1[_loc4_++]);
            _loc6_ = String(param1[_loc4_++]);
            _loc7_ = Number(param1[_loc4_++]);
            _loc8_ = Boolean(param1[_loc4_++]);
            _loc10_ = (_loc9_ = String(param1[_loc4_++])) == "" ? [] : _loc9_.split(";");
            _loc11_ = int(param1[_loc4_++]);
            _loc12_ = String(param1[_loc4_++]);
            _loc13_ = String(param1[_loc4_++]);
            _loc14_ = Number(param1[_loc4_++]);
            _loc15_ = Number(param1[_loc4_++]);
            _loc2_["party" + _loc3_.toString()] = {
               "capacity":_loc5_,
               "invited":_loc6_,
               "timestampInit":_loc7_,
               "isPublic":_loc8_,
               "props":_loc10_,
               "type":_loc11_,
               "serverName":_loc12_,
               "owner":_loc13_,
               "duration":_loc14_,
               "roomId":_loc15_
            };
            _loc3_++;
         }
         if(successCallback != null)
         {
            successCallback(this.usernameConsulted,_loc2_);
         }
      }
      
      public function createParty(param1:Number, param2:Boolean, param3:int, param4:int, param5:String, param6:String, param7:Number, param8:int, param9:String) : void
      {
         this.addParam(user.username,XMLRPCDataTypes.STRING);
         applySecurity();
         this.addParam(user.id.toString(),XMLRPCDataTypes.STRING);
         this.addParam(param1.toString(),XMLRPCDataTypes.STRING);
         this.addParam(param2.toString(),XMLRPCDataTypes.STRING);
         this.addParam(param3.toString(),XMLRPCDataTypes.STRING);
         this.addParam(param4.toString(),XMLRPCDataTypes.STRING);
         this.addParam(param5.toString(),XMLRPCDataTypes.STRING);
         this.addParam(param6.toString(),XMLRPCDataTypes.STRING);
         this.addParam(param7.toString(),XMLRPCDataTypes.STRING);
         this.addParam(param8.toString(),XMLRPCDataTypes.STRING);
         this.addParam(param9.toString(),XMLRPCDataTypes.STRING);
         sendMessage("createParty",this.completeCreate);
      }
      
      override protected function get urlApi() : String
      {
         return settings.services.parties.api;
      }
      
      override protected function removeListeners() : void
      {
         this.removeEventListener(Event.COMPLETE,this.completePartiesList);
         super.removeListeners();
      }
      
      public function getParties() : void
      {
         this.addParam(user.username,XMLRPCDataTypes.STRING);
         applySecurity();
         sendMessage("getParties",this.completePartiesList);
      }
   }
}
