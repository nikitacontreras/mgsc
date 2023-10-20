package com.qb9.gaturro.view.components.banner.albumHalloween2018
{
   import com.adobe.serialization.json.JSON;
   import com.qb9.flashlib.config.Settings;
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.net.LoadFile;
   import com.qb9.flashlib.net.LoadFileFormat;
   import com.qb9.flashlib.net.LoadFileParsers;
   import com.qb9.flashlib.tasks.Loop;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskEvent;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.gaturro.view.components.banner.albummundial2018.util.CardsGroupedByRarity;
   import com.qb9.gaturro.view.gui.banner.properties.IHasData;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class HalloweenBoosterRewardBanner extends InstantiableGuiModal implements IHasData, IHasRoomAPI
   {
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var _settings:Object;
      
      private var _opened:Boolean;
      
      private var _selectedCards:Array;
      
      private var _groupOfCardsSortedByRarity:Array;
      
      private var _showingCards:Boolean;
      
      private var _givedCard1:Boolean = false;
      
      private var _givedCard2:Boolean = false;
      
      private var _givedCard3:Boolean = false;
      
      private var taskRunner:TaskRunner;
      
      private var _data:Object;
      
      private var _allAvailableCards:Array;
      
      private var _rewardData:Object;
      
      private var boosterMC:MovieClip;
      
      private var _showedCards:int = 0;
      
      private var background:MovieClip;
      
      private var _currentCardAdded:int;
      
      private var boosterTween:Loop;
      
      private var mundialDef:Settings;
      
      private var _showed:Boolean;
      
      private var _iteraciones:int;
      
      public function HalloweenBoosterRewardBanner(param1:String = "", param2:String = "")
      {
         super("halloweenBoosterGUI","halloweenBoosterGUIasset");
      }
      
      private function onClickCard(param1:MouseEvent) : void
      {
         if(param1.target.name == this.boosterMC.open.cards.card3.name && Boolean(api.isCitizen))
         {
            this.showCard(param1.target as MovieClip);
            this._givedCard3 = true;
            api.giveUser(this._selectedCards[2].asset);
         }
         else if(!api.isCitizen && param1.target.name == this.boosterMC.open.cards.card3.name)
         {
            this.boosterMC.open.cards.card3.passport.gotoAndPlay(0);
            api.stopSound("cofreNegativo");
            api.playSound("cofreNegativo");
         }
         if(param1.target.name == this.boosterMC.open.cards.card1.name)
         {
            this.showCard(param1.target as MovieClip);
            this._givedCard1 = true;
            api.giveUser(this._selectedCards[0].asset);
         }
         if(param1.target.name == this.boosterMC.open.cards.card2.name)
         {
            this.showCard(param1.target as MovieClip);
            this._givedCard2 = true;
            api.giveUser(this._selectedCards[1].asset);
         }
      }
      
      private function randomInt(param1:int, param2:int = 0) : int
      {
         return int(param2 + Math.random() * param1);
      }
      
      private function groupCardsByRarity() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Boolean = false;
         var _loc3_:CardsGroupedByRarity = null;
         var _loc4_:CardsGroupedByRarity = null;
         this._groupOfCardsSortedByRarity = new Array();
         for each(_loc1_ in this._allAvailableCards)
         {
            _loc2_ = false;
            for each(_loc3_ in this._groupOfCardsSortedByRarity)
            {
               if(_loc1_.chance == _loc3_.rarity)
               {
                  _loc2_ = true;
                  _loc3_.cards.push(_loc1_);
               }
            }
            if(!_loc2_)
            {
               (_loc4_ = new CardsGroupedByRarity(_loc1_.chance)).cards.push(_loc1_);
               this._groupOfCardsSortedByRarity.push(_loc4_);
            }
         }
         this._groupOfCardsSortedByRarity;
      }
      
      private function addChildCards() : void
      {
         api.libraries.fetch(this._selectedCards[0].asset,function(param1:DisplayObject):void
         {
            ++_currentCardAdded;
            boosterMC.open.cards["card1"].holder.addChild(param1);
         });
         api.libraries.fetch(this._selectedCards[1].asset,function(param1:DisplayObject):void
         {
            ++_currentCardAdded;
            boosterMC.open.cards["card2"].holder.addChild(param1);
         });
         api.libraries.fetch(this._selectedCards[2].asset,function(param1:DisplayObject):void
         {
            ++_currentCardAdded;
            boosterMC.open.cards["card3"].holder.addChild(param1);
         });
      }
      
      override protected function ready() : void
      {
         this.initconfig();
         this.taskRunner = new TaskRunner(view);
         this.taskRunner.start();
      }
      
      private function showCard(param1:MovieClip) : void
      {
         ++this._showedCards;
         param1.removeEventListener(MouseEvent.CLICK,this.onClickCard);
         api.stopSound("armado");
         api.playSound("armado");
         param1.gotoAndPlay(0);
      }
      
      override public function dispose() : void
      {
         if(this.boosterMC)
         {
            this.boosterMC.removeEventListener(MouseEvent.CLICK,this.onConfirm);
         }
         if(this.background)
         {
            this.background.removeEventListener(MouseEvent.CLICK,this.onConfirm);
         }
         if(!this._givedCard1)
         {
            this._givedCard1 = true;
            api.giveUser(this._selectedCards[0].asset);
         }
         if(!this._givedCard2)
         {
            this._givedCard2 = true;
            api.giveUser(this._selectedCards[1].asset);
         }
         if(Boolean(api.isCitizen) && !this._givedCard3)
         {
            this._givedCard3 = true;
            api.giveUser(this._selectedCards[2].asset);
         }
         api.trackEvent("FEATURES:HALLOWEEN_2018:BOOSTER:GIVED_CARDS:" + this._selectedCards[0].asset,"");
         api.trackEvent("FEATURES:HALLOWEEN_2018:BOOSTER:GIVED_CARDS:" + this._selectedCards[1].asset,"");
         if(api.isCitizen)
         {
            api.trackEvent("FEATURES:HALLOWEEN_2018:BOOSTER:GIVED_CARDS:" + this._selectedCards[2].asset,"");
         }
         api.unfreeze();
         super.dispose();
      }
      
      private function sorteoCartas() : void
      {
         var _loc3_:int = 0;
         ++this._iteraciones;
         if(Boolean(this._selectedCards) && this._selectedCards.length >= 3)
         {
            return;
         }
         var _loc1_:int = this.randomInt(this._groupOfCardsSortedByRarity.length);
         var _loc2_:Number = Math.random();
         if(this._groupOfCardsSortedByRarity[_loc1_].rarity >= _loc2_)
         {
            _loc3_ = this.randomInt((this._groupOfCardsSortedByRarity[_loc1_] as CardsGroupedByRarity).cards.length);
            this._selectedCards.push((this._groupOfCardsSortedByRarity[_loc1_] as CardsGroupedByRarity).cards[_loc3_]);
         }
         this.sorteoCartas();
      }
      
      private function setupView(param1:Event = null) : void
      {
         this._selectedCards = new Array();
         this._settings = this.mundialDef.MundialCards;
         this._allAvailableCards = this._settings.activeCards;
         this.boosterMC = view.getChildByName("boosterMC") as MovieClip;
         this.background = view.getChildByName("background") as MovieClip;
         api.trackEvent("FEATURES:HALLOWEEN_2018:BOOSTER:OPEN"," ");
         api.freeze();
         this.boosterTween = new Loop(new Sequence(new Tween(this.boosterMC,600,{
            "scaleX":1.03,
            "scaleY":1.03
         },{"transition":"bounceEaseIn"}),new Tween(this.boosterMC,600,{
            "scaleX":1,
            "scaleY":1
         },{"transition":"easeIn"})));
         this.taskRunner.add(this.boosterTween);
         this.groupCardsByRarity();
         this.sorteoCartas();
         this.addChildCards();
         this.boosterMC.addEventListener(MouseEvent.CLICK,this.onConfirm);
         this.boosterMC.buttonMode = true;
         this.background.addEventListener(MouseEvent.CLICK,this.onConfirm);
         this.addEventListener(Event.ENTER_FRAME,this.update);
      }
      
      private function update(param1:Event) : void
      {
         if(this.boosterMC && this._opened && !this._showed && this.boosterMC.open.currentFrame == this.boosterMC.open.totalFrames)
         {
            this._showed = true;
            this.boosterMC.open.cards.gotoAndPlay(0);
            this.removeEventListener(Event.ENTER_FRAME,this.update);
            this._showingCards = true;
            this.boosterMC.open.cards.card1.addEventListener(MouseEvent.CLICK,this.onClickCard);
            this.boosterMC.open.cards.card1.mouseChildren = false;
            this.boosterMC.open.cards.card1.buttonMode = true;
            this.boosterMC.open.cards.card2.addEventListener(MouseEvent.CLICK,this.onClickCard);
            this.boosterMC.open.cards.card2.mouseChildren = false;
            this.boosterMC.open.cards.card2.buttonMode = true;
            this.boosterMC.open.cards.card3.addEventListener(MouseEvent.CLICK,this.onClickCard);
            this.boosterMC.open.cards.card3.mouseChildren = false;
            this.boosterMC.open.cards.card3.buttonMode = true;
            this.onConfirm(null);
         }
      }
      
      private function initconfig() : void
      {
         this.mundialDef = new Settings();
         LoadFileParsers.registerParser(LoadFileFormat.JSON,com.adobe.serialization.json.JSON.decode);
         var _loc1_:String = URLUtil.getUrl("cfgs/banners/HalloweenCards2018.json");
         var _loc2_:LoadFile = new LoadFile(_loc1_,"json");
         this.mundialDef.addFile(_loc2_);
         _loc2_.addEventListener(TaskEvent.COMPLETE,this.setupView);
         _loc2_.start();
      }
      
      public function set data(param1:Object) : void
      {
         this._rewardData = param1;
      }
      
      private function onConfirm(param1:MouseEvent) : void
      {
         if(!this._opened)
         {
            this.boosterMC.open.gotoAndPlay(0);
            api.playSound("globos/soplar");
            this.taskRunner.remove(this.boosterTween);
            this._opened = true;
         }
         if(this._showed)
         {
            if(this.boosterMC.open.cards.currentFrame == this.boosterMC.open.cards.totalFrames)
            {
               if(this._showedCards >= 3)
               {
                  if(this.boosterMC.open.cards.card2.currentFrame == this.boosterMC.open.cards.card2.totalFrames && this.boosterMC.open.cards.card1.currentFrame == this.boosterMC.open.cards.card1.totalFrames && this.boosterMC.open.cards.card3.currentFrame == this.boosterMC.open.cards.card3.totalFrames)
                  {
                     close();
                  }
               }
            }
         }
      }
      
      private function onCardFetch(param1:DisplayObject) : void
      {
         ++this._currentCardAdded;
         this.boosterMC.open.cards["card" + this._currentCardAdded.toString()].holder.addChild(param1);
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
   }
}
