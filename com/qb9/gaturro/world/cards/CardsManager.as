package com.qb9.gaturro.world.cards
{
   import com.qb9.flashlib.math.Random;
   import com.qb9.flashlib.security.SafeNumber;
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.world.cards.service.CardsConnection;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class CardsManager extends EventDispatcher
   {
       
      
      private var _decks:Array;
      
      private var _opponentBettedCard:com.qb9.gaturro.world.cards.Card;
      
      private var _experience:SafeNumber;
      
      private var _win:int = 0;
      
      private var _isLoaded:Boolean = false;
      
      private var _abandon:int = 0;
      
      private var _bettedCardDecks:Array;
      
      public const ABANDON_MATCH:int = 3;
      
      private var _myBettedCard:com.qb9.gaturro.world.cards.Card;
      
      public const WIN_MATCH:int = 1;
      
      private var _activeDeck:com.qb9.gaturro.world.cards.Deck;
      
      private var _cards:Array;
      
      private var _lose:int = 0;
      
      public const LOSE_MATCH:int = 2;
      
      public function CardsManager()
      {
         this._cards = new Array();
         this._decks = new Array();
         this._experience = new SafeNumber(0);
         super();
      }
      
      public function get level() : int
      {
         var _loc2_:int = 0;
         var _loc1_:int = 1;
         for each(_loc2_ in settings.cards.config.expLevels)
         {
            if(this._experience.value < _loc2_)
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return _loc1_;
      }
      
      public function get forNextLevel() : Number
      {
         var _loc1_:Array = settings.cards.config.expLevels;
         var _loc2_:int = this.level;
         var _loc3_:int = _loc2_ == 1 ? 0 : int(_loc1_[_loc2_ - 2]);
         var _loc4_:int = _loc2_ > _loc1_.length ? int(_loc1_[_loc1_.length - 1]) : int(_loc1_[_loc2_ - 1]);
         if(_loc3_ == _loc4_)
         {
            return 1;
         }
         var _loc5_:Number;
         return (_loc5_ = (this.experience - _loc3_) * 100 / (_loc4_ - _loc3_)) / 100;
      }
      
      private function cleanBet() : void
      {
         this._myBettedCard = null;
         this._bettedCardDecks = new Array();
         this._opponentBettedCard = null;
      }
      
      public function init() : void
      {
         if(!settings.services.cards.enabled)
         {
            return;
         }
         var _loc1_:CardsConnection = new CardsConnection(this.createCards,this.serviceError);
         _loc1_.getCards();
      }
      
      public function getDeckById(param1:int) : com.qb9.gaturro.world.cards.Deck
      {
         var _loc2_:com.qb9.gaturro.world.cards.Deck = null;
         for each(_loc2_ in this._decks)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function get lose() : int
      {
         return this._lose;
      }
      
      public function getNewCard(param1:int, param2:int, param3:int) : com.qb9.gaturro.world.cards.Card
      {
         return new com.qb9.gaturro.world.cards.Card(param1,param2,param3);
      }
      
      public function initMatch() : void
      {
         this.cleanBet();
      }
      
      public function set activeDeck(param1:com.qb9.gaturro.world.cards.Deck) : void
      {
         this._activeDeck = param1;
      }
      
      public function sortAll() : void
      {
         var _loc1_:com.qb9.gaturro.world.cards.Deck = null;
         this._cards.sort(this.sortCard);
         this._decks.sort(this.sortDeck);
         for each(_loc1_ in this._decks)
         {
            _loc1_.cards.sort(this.sortCard);
         }
      }
      
      public function saveActiveDeck() : void
      {
         if(!settings.services.cards.enabled)
         {
            return;
         }
         var _loc1_:int = !!this._activeDeck ? this._activeDeck.id : -1;
         var _loc2_:CardsConnection = new CardsConnection(null,null);
         _loc2_.saveActiveDeck(_loc1_);
      }
      
      public function loseMatch() : void
      {
         ++this._lose;
         this._experience.value = this.calculateExp(this._experience.value,this.LOSE_MATCH);
         this.cleanBet();
      }
      
      public function createDeck(param1:int) : com.qb9.gaturro.world.cards.Deck
      {
         var _loc2_:com.qb9.gaturro.world.cards.Deck = new com.qb9.gaturro.world.cards.Deck(param1);
         this._decks.push(_loc2_);
         return _loc2_;
      }
      
      private function createCards(param1:String, param2:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:com.qb9.gaturro.world.cards.Deck = null;
         for each(_loc3_ in param2.cardsData)
         {
            this.createCard(_loc3_.id,_loc3_.upgAtt,_loc3_.upgDef,_loc3_.decks);
         }
         if((_loc4_ = int(param2.deckIdActive)) >= 0)
         {
            if(_loc5_ = this.getDeckById(_loc4_))
            {
               this._activeDeck = _loc5_;
            }
         }
         this._win = param2.historyData.win;
         this._lose = param2.historyData.lose;
         this._abandon = param2.historyData.abandon;
         this._experience.value = param2.historyData.experience;
         this.sortAll();
         this._isLoaded = true;
      }
      
      public function winMatch(param1:Number, param2:int, param3:int) : void
      {
         this.saveBettedCard();
         ++this._win;
         this._experience.value = this.calculateExp(this._experience.value,this.WIN_MATCH);
         param3 = this.calculateExp(param3,param2);
         var _loc4_:CardsConnection;
         (_loc4_ = new CardsConnection(null,null)).saveMatchResult(this.WIN_MATCH,this._experience.value,param1,param2,param3);
      }
      
      public function createRandomCards(param1:int, param2:int = -1) : Array
      {
         var _loc7_:int = 0;
         var _loc8_:Array = null;
         var _loc9_:Object = null;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc3_:Array = new Array();
         var _loc4_:* = "";
         var _loc5_:Array = settings.cards.config.randomProbCat;
         var _loc6_:int = 0;
         while(_loc6_ < param1)
         {
            _loc7_ = 1;
            if(param2 > -1)
            {
               _loc7_ = param2;
            }
            else if((_loc11_ = Random.randrange(0,99)) < _loc5_[0])
            {
               _loc7_ = 1;
            }
            else if(_loc11_ < _loc5_[0] + _loc5_[1])
            {
               _loc7_ = 2;
            }
            else
            {
               _loc7_ = 3;
            }
            _loc8_ = this.catSet(_loc7_);
            _loc9_ = ArrayUtil.choice(_loc8_);
            _loc10_ = int(settings.cards.types.indexOf(_loc9_));
            if(_loc4_.indexOf(_loc10_.toString()) < 0)
            {
               _loc4_ = _loc4_ + _loc10_.toString() + ";";
               _loc3_.push(this.createCard(_loc10_,0,0,[]));
               _loc6_++;
            }
         }
         return _loc3_;
      }
      
      public function createCard(param1:int, param2:int, param3:int, param4:Array) : com.qb9.gaturro.world.cards.Card
      {
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:com.qb9.gaturro.world.cards.Deck = null;
         var _loc9_:com.qb9.gaturro.world.cards.Deck = null;
         var _loc5_:com.qb9.gaturro.world.cards.Card = this.getNewCard(param1,param2,param3);
         this._cards.push(_loc5_);
         for each(_loc6_ in param4)
         {
            _loc7_ = false;
            for each(_loc8_ in this._decks)
            {
               if(_loc8_.id == _loc6_)
               {
                  _loc8_.addCard(_loc5_);
                  _loc7_ = true;
               }
            }
            if(!_loc7_)
            {
               (_loc9_ = new com.qb9.gaturro.world.cards.Deck(_loc6_)).addCard(_loc5_);
               this._decks.push(_loc9_);
            }
         }
         return _loc5_;
      }
      
      public function get opponentBettedCard() : com.qb9.gaturro.world.cards.Card
      {
         return this._opponentBettedCard;
      }
      
      public function abandonMatch() : void
      {
         ++this._abandon;
         this.cleanBet();
      }
      
      private function serviceError(param1:String, param2:Object) : void
      {
         this.dispatchEvent(new Event(ErrorEvent.ERROR));
      }
      
      private function sortCard(param1:com.qb9.gaturro.world.cards.Card, param2:com.qb9.gaturro.world.cards.Card) : int
      {
         if(param1.id < param2.id)
         {
            return -1;
         }
         if(param1.id > param2.id)
         {
            return 1;
         }
         if(param1.attack > param2.attack)
         {
            return -1;
         }
         if(param1.attack < param2.attack)
         {
            return -1;
         }
         if(param1.defense > param2.defense)
         {
            return -1;
         }
         if(param1.defense < param2.defense)
         {
            return -1;
         }
         return 0;
      }
      
      public function get activeDeck() : com.qb9.gaturro.world.cards.Deck
      {
         return this._activeDeck;
      }
      
      private function calculateExp(param1:int, param2:int) : int
      {
         if(param2 == this.WIN_MATCH)
         {
            param1 += settings.cards.config.winExp;
         }
         else if(param2 == this.LOSE_MATCH)
         {
            param1 += settings.cards.config.loseExp;
         }
         var _loc3_:Array = settings.cards.config.expLevels;
         if(param1 > _loc3_[_loc3_.length - 1])
         {
            param1 = int(_loc3_[_loc3_.length - 1]);
         }
         return param1;
      }
      
      private function catSet(param1:int) : Array
      {
         var _loc3_:Object = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in settings.cards.types)
         {
            if(_loc3_.cat == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function get win() : int
      {
         return this._win;
      }
      
      public function get myBettedCard() : com.qb9.gaturro.world.cards.Card
      {
         return this._myBettedCard;
      }
      
      public function initBetMatch(param1:com.qb9.gaturro.world.cards.Card, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:com.qb9.gaturro.world.cards.Deck = null;
         if(!ArrayUtil.contains(this._cards,param1))
         {
            return;
         }
         this._myBettedCard = param1;
         ArrayUtil.removeElement(this._cards,this._myBettedCard);
         this._bettedCardDecks = new Array();
         for each(_loc5_ in this._decks)
         {
            if(_loc5_.contains(this._myBettedCard))
            {
               this._bettedCardDecks.push(_loc5_);
               _loc5_.removeCard(this._myBettedCard);
            }
         }
         this._opponentBettedCard = new com.qb9.gaturro.world.cards.Card(param2,param3,param4);
         this.saveCards();
      }
      
      public function saveCards() : void
      {
         if(!settings.services.cards.enabled)
         {
            return;
         }
         var _loc1_:CardsConnection = new CardsConnection(null,null);
         _loc1_.saveCards(this.cards,this.decks);
      }
      
      public function get isLoaded() : Boolean
      {
         return this._isLoaded;
      }
      
      public function get experience() : int
      {
         return this._experience.value;
      }
      
      public function toBetCards() : Array
      {
         var _loc2_:com.qb9.gaturro.world.cards.Card = null;
         var _loc1_:Array = this._cards.slice();
         if(!_loc1_)
         {
            return [];
         }
         if(!this._activeDeck)
         {
            return _loc1_;
         }
         for each(_loc2_ in this._activeDeck.cards)
         {
            ArrayUtil.removeElement(_loc1_,_loc2_);
         }
         return _loc1_;
      }
      
      private function saveBettedCard() : void
      {
         var _loc1_:com.qb9.gaturro.world.cards.Deck = null;
         if(!this._myBettedCard || !this._opponentBettedCard)
         {
            return;
         }
         this._cards.push(this._myBettedCard);
         this._cards.push(this._opponentBettedCard);
         for each(_loc1_ in this._bettedCardDecks)
         {
            _loc1_.addCard(this._myBettedCard);
         }
         this.saveCards();
         this.cleanBet();
      }
      
      public function get decks() : Array
      {
         return this._decks;
      }
      
      public function get cards() : Array
      {
         return this._cards;
      }
      
      public function get abandon() : int
      {
         return this._abandon;
      }
      
      private function sortDeck(param1:com.qb9.gaturro.world.cards.Deck, param2:com.qb9.gaturro.world.cards.Deck) : int
      {
         if(param1.id < param2.id)
         {
            return -1;
         }
         if(param1.id > param2.id)
         {
            return 1;
         }
         return 0;
      }
   }
}
