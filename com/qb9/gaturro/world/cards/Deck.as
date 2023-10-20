package com.qb9.gaturro.world.cards
{
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.settings;
   
   public class Deck
   {
       
      
      private var _cards:Array;
      
      private var _id:int = -1;
      
      public function Deck(param1:int)
      {
         this._cards = [];
         super();
         this._id = param1;
      }
      
      public function addCard(param1:Card) : void
      {
         this._cards.push(param1);
      }
      
      public function get cards() : Array
      {
         return this._cards;
      }
      
      public function contains(param1:Card) : Boolean
      {
         var _loc2_:Card = null;
         for each(_loc2_ in this._cards)
         {
            if(param1 == _loc2_)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function removeCard(param1:Card) : void
      {
         ArrayUtil.removeElement(this._cards,param1);
      }
      
      public function get name() : String
      {
         return region.getText(settings.cards.deckNames[this._id]);
      }
      
      public function empty() : void
      {
         this._cards = new Array();
      }
   }
}
