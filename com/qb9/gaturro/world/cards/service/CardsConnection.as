package com.qb9.gaturro.world.cards.service
{
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.util.xmprpc.XMLRPCDataTypes;
   import com.qb9.gaturro.util.xmprpc.services.ServicesConnection;
   import com.qb9.gaturro.world.cards.Card;
   import com.qb9.gaturro.world.cards.Deck;
   
   public class CardsConnection extends ServicesConnection
   {
       
      
      public function CardsConnection(param1:Function = null, param2:Function = null)
      {
         super(param1,param2);
      }
      
      private function composeCardsStr(param1:Array, param2:Array) : String
      {
         var _loc4_:Card = null;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:Deck = null;
         var _loc3_:* = "";
         for each(_loc4_ in param1)
         {
            _loc5_ = "";
            _loc5_ = (_loc5_ = (_loc5_ = _loc4_.id.toString() + "|") + _loc4_.upgradeAttack.toString() + "|") + _loc4_.upgradeDefense.toString() + "|";
            _loc6_ = "";
            for each(_loc7_ in param2)
            {
               if(_loc7_.contains(_loc4_))
               {
                  _loc6_ = _loc6_ + _loc7_.id.toString() + ",";
               }
            }
            if(_loc6_.length > 0)
            {
               _loc6_ = _loc6_.substr(0,_loc6_.length - 1);
            }
            _loc5_ += _loc6_;
            _loc3_ = _loc3_ + _loc5_ + ";";
         }
         if(_loc3_.length > 0)
         {
            _loc3_ = _loc3_.substr(0,_loc3_.length - 1);
         }
         return _loc3_;
      }
      
      public function saveMatchResult(param1:int, param2:int, param3:Number, param4:int, param5:int) : void
      {
         this.addParam(user.username,XMLRPCDataTypes.STRING);
         applySecurity();
         this.addParam(user.id.toString(),XMLRPCDataTypes.STRING);
         this.addParam(param1.toString(),XMLRPCDataTypes.STRING);
         this.addParam(param2.toString(),XMLRPCDataTypes.STRING);
         this.addParam(param3.toString(),XMLRPCDataTypes.STRING);
         this.addParam(param4.toString(),XMLRPCDataTypes.STRING);
         this.addParam(param5.toString(),XMLRPCDataTypes.STRING);
         sendMessage("saveMatchResult");
      }
      
      public function saveCards(param1:Array, param2:Array) : void
      {
         this.addParam(user.username,XMLRPCDataTypes.STRING);
         applySecurity();
         this.addParam(user.id.toString(),XMLRPCDataTypes.STRING);
         this.addParam(this.composeCardsStr(param1,param2),XMLRPCDataTypes.STRING);
         sendMessage("saveCards");
      }
      
      override protected function get urlApi() : String
      {
         return settings.services.cards.api;
      }
      
      public function saveActiveDeck(param1:int) : void
      {
         this.addParam(user.username,XMLRPCDataTypes.STRING);
         applySecurity();
         this.addParam(user.id.toString(),XMLRPCDataTypes.STRING);
         this.addParam(param1.toString(),XMLRPCDataTypes.STRING);
         sendMessage("saveActiveDeck");
      }
      
      public function getCards() : void
      {
         this.addParam(user.username,XMLRPCDataTypes.STRING);
         applySecurity();
         this.addParam(user.id.toString(),XMLRPCDataTypes.STRING);
         sendMessage("getCards",this.readCardsStatus);
      }
      
      private function readCardsStatus(param1:Array) : void
      {
         var _loc9_:Array = null;
         var _loc10_:Object = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:Array = null;
         var _loc2_:Object = {};
         var _loc3_:Array = String(param1[0]).split(";");
         var _loc4_:Array = new Array();
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(!((_loc9_ = String(_loc3_[_loc5_]).split("|")).length == 0 || _loc9_[0] == ""))
            {
               _loc10_ = {};
               _loc11_ = int(_loc9_[0]);
               _loc12_ = int(_loc9_[1]);
               _loc13_ = int(_loc9_[2]);
               _loc14_ = String(_loc9_[3]) == "" ? [] : String(_loc9_[3]).split(",");
               _loc4_.push({
                  "id":_loc11_,
                  "upgAtt":_loc12_,
                  "upgDef":_loc13_,
                  "decks":_loc14_
               });
            }
            _loc5_++;
         }
         var _loc6_:Array = String(param1[1]) == "" ? [0,0,0] : String(param1[1]).split(",");
         var _loc7_:Object = {
            "win":_loc6_[0],
            "lose":_loc6_[1],
            "abandon":_loc6_[2],
            "experience":_loc6_[3]
         };
         var _loc8_:int = String(param1[2]) == "" ? -1 : int(param1[2]);
         _loc2_["cardsData"] = _loc4_;
         _loc2_["historyData"] = _loc7_;
         _loc2_["deckIdActive"] = _loc8_;
         if(successCallback != null)
         {
            successCallback(this.usernameConsulted,_loc2_);
         }
      }
   }
}
