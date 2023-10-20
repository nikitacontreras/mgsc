package com.qb9.gaturro.world.parties.target
{
   import com.qb9.gaturro.globals.*;
   import flash.utils.Dictionary;
   
   public class TargetMonitor
   {
       
      
      private var targetData:Dictionary;
      
      public function TargetMonitor()
      {
         this.targetData = new Dictionary(true);
         super();
      }
      
      public function get targets() : Array
      {
         var _loc1_:Array = this.targetData[this.actualPartyKey()];
         if(_loc1_)
         {
            return _loc1_;
         }
         return null;
      }
      
      private function createPartyData(param1:String) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Target = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in settings.parties.targets)
         {
            if(_loc4_ = this.createTarget(_loc3_))
            {
               _loc2_.push(_loc4_);
            }
         }
         this.targetData[param1] = _loc2_;
      }
      
      private function checkThis(param1:String) : void
      {
         var _loc3_:Target = null;
         var _loc2_:Array = this.targetData[param1];
         if(!_loc2_)
         {
            return;
         }
         for each(_loc3_ in _loc2_)
         {
            _loc3_.check(api);
         }
      }
      
      private function actualPartyKey() : String
      {
         var _loc1_:String = String(api.room.id.toString());
         var _loc2_:String = String(api.room.attributes.partyOwner);
         var _loc3_:String = String(api.room.attributes.init);
         var _loc4_:String;
         return (_loc4_ = _loc1_ + "_" + _loc2_ + "_" + _loc3_).replace(" ","_");
      }
      
      public function check() : void
      {
         if(!api || !api.room || !api.room.attributes.partyOwner)
         {
            return;
         }
         var _loc1_:String = this.actualPartyKey();
         var _loc2_:Array = this.targetData[_loc1_];
         if(!_loc2_)
         {
            this.createPartyData(_loc1_);
         }
         this.checkThis(_loc1_);
      }
      
      private function createTarget(param1:Object) : Target
      {
         var _loc2_:* = param1.user == "both";
         if(api.room.attributes.partyOwner == user.username && param1.user == "onlyOwner")
         {
            _loc2_ = true;
         }
         else if(api.room.attributes.partyOwner != user.username && param1.user == "onlyGuest")
         {
            _loc2_ = true;
         }
         if(!_loc2_)
         {
            return null;
         }
         switch(param1.type)
         {
            case "attendance":
               return new Attendance(param1);
            case "dance":
               return new Dance(param1);
            case "greet":
               return new Greet(param1);
            case "joke":
               return new Joke(param1);
            case "jump":
               return new Jump(param1);
            case "laugh":
               return new Laugh(param1);
            case "love":
               return new Love(param1);
            case "vertical":
               return new Vertical(param1);
            default:
               return null;
         }
      }
   }
}
