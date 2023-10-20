package com.qb9.gaturro.world.cards
{
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.settings;
   import flash.geom.Point;
   
   public class Card
   {
       
      
      private var upgDefense:int = 0;
      
      private var data:Object;
      
      private var idCard:int = -1;
      
      private var upgAttack:int = 0;
      
      public function Card(param1:int, param2:int, param3:int)
      {
         super();
         this.idCard = param1;
         this.data = settings.cards.types[this.id];
         this.upgAttack = param2;
         this.upgDefense = param3;
      }
      
      public function get defense() : int
      {
         return this.data.defense;
      }
      
      public function get id() : int
      {
         return this.idCard;
      }
      
      public function get upgradeAttack() : int
      {
         return this.upgAttack;
      }
      
      private function segments(param1:int) : Point
      {
         var _loc2_:int = (param1 - 1) % 10;
         var _loc3_:int = param1 - _loc2_;
         var _loc4_:int = param1 + (10 - _loc2_) - 1;
         return new Point(_loc3_,_loc4_);
      }
      
      public function get attack() : int
      {
         return this.data.attack;
      }
      
      public function addAttUpg(param1:int) : void
      {
         this.upgAttack += param1;
      }
      
      public function get name() : String
      {
         return !!this.data.name ? String(region.getText(this.data.name)) : "GATUCARTA";
      }
      
      public function get absDefense() : int
      {
         return this.data.defense + this.upgDefense;
      }
      
      public function get icon() : String
      {
         var _loc1_:int = this.id + 1;
         var _loc2_:Point = this.segments(_loc1_);
         var _loc3_:String = (_loc2_.x < 10 ? "0" + _loc2_.x.toString() : _loc2_.x.toString()) + _loc2_.y.toString();
         return "cards" + _loc3_ + ".carta" + _loc1_.toString() + "_so";
      }
      
      public function get logo() : String
      {
         return Boolean(this.data) && Boolean(this.data.logo) ? String(this.data.logo) : "";
      }
      
      public function addDefUpg(param1:int) : void
      {
         this.upgDefense += param1;
      }
      
      public function get special() : String
      {
         return Boolean(this.data) && Boolean(this.data.special) ? String(this.data.special) : "";
      }
      
      public function get absAttack() : int
      {
         return this.data.attack + this.upgAttack;
      }
      
      public function get upgradeDefense() : int
      {
         return this.upgDefense;
      }
   }
}
