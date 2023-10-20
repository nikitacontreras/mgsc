package com.qb9.gaturro.view.components.banner.partyElite
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.service.events.EventData;
   import com.qb9.gaturro.service.events.EventsAttributeEnum;
   import com.qb9.gaturro.service.events.EventsService;
   import com.qb9.gaturro.user.inventory.GaturroInventory;
   import com.qb9.gaturro.view.components.canvas.common.ExplanationCanvas;
   import com.qb9.gaturro.view.components.canvas.common.ISwitchPostExplanation;
   import com.qb9.gaturro.view.gui.base.modal.AbstractCanvasFrameBanner;
   import com.qb9.mambo.world.avatars.Avatar;
   import flash.utils.Dictionary;
   
   public class PartyEliteWinnerSelectorBanner extends AbstractCanvasFrameBanner implements ISwitchPostExplanation
   {
      
      public static const AWARD_SELECTOR:String = "awardSelector";
      
      internal static const GOLDEN_AWARD:String = "galaPremios2017/props.estatuaDoradaBag";
      
      internal static const SILVER_AWARD:String = "galaPremios2017/props.estatuaPlataBag";
      
      public static const NO_CANDIDATES:String = "noCandidate";
      
      public static const USER_SELECTOR:String = "userSelector";
      
      public static const NO_AWARDS:String = "noAwards";
      
      private static var AWARD_NAME_LIST:Dictionary;
      
      internal static const BRONZE_AWARD:String = "galaPremios2017/props.estatuaBronzeBag";
      
      public static var AWARD_LIST:Array = new Array(GOLDEN_AWARD,SILVER_AWARD,BRONZE_AWARD);
      
      public static const CANDIDATE_GONE:String = "candidateGone";
       
      
      private var candidate:String;
      
      private var availableCandidates:Boolean;
      
      private var eventsService:EventsService;
      
      private var award:String;
      
      private var availableAwards:Array;
      
      public function PartyEliteWinnerSelectorBanner()
      {
         super("PartyEliteWinnerSelectorBanner","PartyEliteWinnerSelectorBannerAsset");
         this.setup();
      }
      
      public static function getAwardNameList() : Dictionary
      {
         if(!AWARD_NAME_LIST)
         {
            AWARD_NAME_LIST = new Dictionary();
            AWARD_NAME_LIST[GOLDEN_AWARD] = "gold";
            AWARD_NAME_LIST[SILVER_AWARD] = "silver";
            AWARD_NAME_LIST[BRONZE_AWARD] = "bronze";
         }
         return AWARD_NAME_LIST;
      }
      
      private function processCamdidates() : void
      {
         var _loc2_:EventData = null;
         var _loc3_:String = null;
         var _loc4_:Avatar = null;
         var _loc1_:Array = api.avatars;
         this.availableCandidates = false;
         for each(_loc4_ in _loc1_)
         {
            _loc3_ = String(_loc4_.attributes[EventsAttributeEnum.EVENT_ATTR]);
            if(_loc3_)
            {
               _loc2_ = EventData.fromString(_loc3_);
               if(_loc4_ != api.userAvatar && this.eventsService.eventData.host == _loc2_.host)
               {
                  this.availableCandidates = true;
                  return;
               }
            }
         }
      }
      
      public function setCandidate(param1:String) : void
      {
         var _loc3_:Avatar = null;
         var _loc2_:Array = api.avatars;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.username == param1)
            {
               this.candidate = param1;
               this.processAward();
               return;
            }
         }
         switchTo(CANDIDATE_GONE);
      }
      
      private function setup() : void
      {
         this.eventsService = Context.instance.getByType(EventsService) as EventsService;
         this.evalStock();
         this.processCamdidates();
         api.playSound("gala2017/musica_premiacion",100);
         api.stopSound("gala2017/musica_festiva");
      }
      
      override protected function setInitialCanvasName() : void
      {
         if(!this.availableAwards.length)
         {
            initialCanvasName = NO_AWARDS;
         }
         else if(!this.availableCandidates)
         {
            initialCanvasName = NO_CANDIDATES;
         }
         else
         {
            initialCanvasName = AWARD_SELECTOR;
         }
      }
      
      override public function close() : void
      {
         super.close();
      }
      
      private function evalStock() : void
      {
         this.availableAwards = new Array();
         this.processStock(GOLDEN_AWARD);
         this.processStock(SILVER_AWARD);
         this.processStock(BRONZE_AWARD);
      }
      
      public function switchToPostExplanation() : void
      {
         if(getCurrentCanvasName() == CANDIDATE_GONE)
         {
            switchTo(AWARD_SELECTOR);
         }
         else
         {
            this.close();
         }
      }
      
      override protected function setupCanvas() : void
      {
         addCanvas(new PartyEliteAwardSelectorCanvas(AWARD_SELECTOR,AWARD_SELECTOR,canvasContainer,this,this.availableAwards));
         addCanvas(new PartyEliteUserSelectorCanvas(USER_SELECTOR,USER_SELECTOR,canvasContainer,this));
         addCanvas(new com.qb9.gaturro.view.components.canvas.common.ExplanationCanvas(NO_AWARDS,NO_AWARDS,canvasContainer,this));
         addCanvas(new com.qb9.gaturro.view.components.canvas.common.ExplanationCanvas(NO_CANDIDATES,NO_CANDIDATES,canvasContainer,this));
         addCanvas(new com.qb9.gaturro.view.components.canvas.common.ExplanationCanvas(CANDIDATE_GONE,CANDIDATE_GONE,canvasContainer,this));
      }
      
      private function processStock(param1:String) : Boolean
      {
         var _loc2_:GaturroInventory = user.inventory(GaturroInventory.BAG) as GaturroInventory;
         if(_loc2_.hasByType(param1))
         {
            this.availableAwards.push(param1);
            return true;
         }
         return false;
      }
      
      private function processAward() : void
      {
         api.takeFromUser(this.award);
         var _loc1_:String = String(api.JSONEncode({
            "user":this.candidate,
            "award":this.award
         }));
         api.setAvatarAttribute("message",_loc1_);
      }
      
      public function setAward(param1:String) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in AWARD_NAME_LIST)
         {
            if(AWARD_NAME_LIST[_loc2_] == param1)
            {
               this.award = _loc2_;
               break;
            }
         }
         switchTo(USER_SELECTOR);
      }
   }
}

import com.qb9.gaturro.commons.context.Context;
import com.qb9.gaturro.commons.event.ItemRendererEvent;
import com.qb9.gaturro.commons.paginator.PaginatorFactory;
import com.qb9.gaturro.globals.api;
import com.qb9.gaturro.service.events.EventData;
import com.qb9.gaturro.service.events.EventsAttributeEnum;
import com.qb9.gaturro.service.events.EventsService;
import com.qb9.gaturro.view.components.banner.partyElite.PartyEliteWinnerSelectorBanner;
import com.qb9.gaturro.view.components.canvas.FrameCanvas;
import com.qb9.gaturro.view.components.repeater.NavegableRepeater;
import com.qb9.gaturro.view.components.repeater.Repeater;
import com.qb9.gaturro.view.components.repeater.config.NavegableRepeaterConfig;
import com.qb9.gaturro.view.components.repeater.item.factory.GenericItemRendererFactory;
import com.qb9.gaturro.view.components.repeater.item.implementation.partyElite.CandidateItemRenderer;
import com.qb9.mambo.world.avatars.Avatar;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;

class PartyEliteUserSelectorCanvas extends FrameCanvas
{
   
   private static const REPEATER_CONTAINER_NAME:String = "repeaterContainer";
   
   private static const MENU_CONTAINER_NAME:String = "menuContainer";
    
   
   private var repeater:NavegableRepeater;
   
   private var acceptBtn:MovieClip;
   
   private var candidates:Array;
   
   private var selected:String;
   
   private var eventsService:EventsService;
   
   public function PartyEliteUserSelectorCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:PartyEliteWinnerSelectorBanner)
   {
      super(param1,param2,param3,param4);
      this.setup();
   }
   
   private function getRepeaterConfig() : NavegableRepeaterConfig
   {
      var _loc1_:Sprite = view.getChildByName(REPEATER_CONTAINER_NAME) as Sprite;
      var _loc2_:Sprite = view.getChildByName(MENU_CONTAINER_NAME) as Sprite;
      var _loc3_:NavegableRepeaterConfig = new NavegableRepeaterConfig(PaginatorFactory.SIMPLE_TYPE,this.candidates,_loc1_,_loc2_,6);
      _loc3_.columns = 2;
      _loc3_.itemRendererFactory = new GenericItemRendererFactory(CandidateItemRenderer,PartyEliteWinnerSelectorBanner(owner).getDefinition("candidateRendererAsset"));
      _loc3_.selectable = Repeater.SINGLE_SELECTABLE;
      return _loc3_;
   }
   
   override public function show(param1:Object = null) : void
   {
      this.acceptBtn = view.getChildByName("acceptBtn") as MovieClip;
      this.acceptBtn.visible = false;
      this.setupRepeater();
      super.show(param1);
   }
   
   private function setupRepeater() : void
   {
      var _loc1_:NavegableRepeaterConfig = this.getRepeaterConfig();
      this.repeater = new NavegableRepeater(_loc1_);
      this.repeater.init();
      this.repeater.repeaterFacade.repeater.addEventListener(ItemRendererEvent.ITEM_SELECTED,this.onItemSelected);
   }
   
   private function onAccept(param1:MouseEvent) : void
   {
      PartyEliteWinnerSelectorBanner(owner).setCandidate(this.selected);
   }
   
   private function onItemSelected(param1:ItemRendererEvent) : void
   {
      this.selected = param1.itemRenderer.data.toString();
      if(this.acceptBtn.visible == false)
      {
         this.setupBtn();
      }
   }
   
   private function setupBtn() : void
   {
      this.acceptBtn.addEventListener(MouseEvent.CLICK,this.onAccept);
      this.acceptBtn.buttonMode = true;
      this.acceptBtn.visible = true;
   }
   
   private function setup() : void
   {
      var _loc2_:EventData = null;
      var _loc3_:Avatar = null;
      this.eventsService = Context.instance.getByType(EventsService) as EventsService;
      var _loc1_:Array = api.avatars;
      this.candidates = new Array();
      for each(_loc3_ in _loc1_)
      {
         _loc2_ = EventData.fromString(_loc3_.attributes[EventsAttributeEnum.EVENT_ATTR]);
         if(_loc3_ != api.userAvatar && this.eventsService.eventData.host == _loc2_.host)
         {
            this.candidates.push(_loc3_.username);
         }
      }
   }
   
   override public function dispose() : void
   {
      if(this.acceptBtn)
      {
         this.acceptBtn.removeEventListener(MouseEvent.CLICK,this.onAccept);
         this.acceptBtn = null;
      }
      if(this.repeater)
      {
         this.repeater.repeaterFacade.repeater.removeEventListener(ItemRendererEvent.ITEM_SELECTED,this.onItemSelected);
      }
      api.stopSound("gala2017/musica_premiacion");
      api.playSound("gala2017/musica_festiva",100);
      super.dispose();
   }
}

import com.qb9.gaturro.commons.event.ItemRendererEvent;
import com.qb9.gaturro.commons.iterator.iterable.IIterable;
import com.qb9.gaturro.commons.iterator.iterable.IterableFactory;
import com.qb9.gaturro.globals.user;
import com.qb9.gaturro.user.inventory.GaturroInventory;
import com.qb9.gaturro.view.components.banner.partyElite.PartyEliteWinnerSelectorBanner;
import com.qb9.gaturro.view.components.canvas.FrameCanvas;
import com.qb9.gaturro.view.components.repeater.Repeater;
import com.qb9.gaturro.view.components.repeater.item.factory.GenericItemRendererFactory;
import com.qb9.gaturro.view.components.repeater.item.implementation.partyElite.ElitePartyAwardItemRenderer;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.utils.Dictionary;

class PartyEliteAwardSelectorCanvas extends FrameCanvas
{
   
   private static const REPEATER_CONTAINER_NAME:String = "repeaterContainer";
    
   
   private var itemContainer:Sprite;
   
   private var repeater:Repeater;
   
   private var acceptBtn:MovieClip;
   
   private var dataProvider:Array;
   
   private var award:String;
   
   private var availableAwards:Array;
   
   public function PartyEliteAwardSelectorCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:PartyEliteWinnerSelectorBanner, param5:Array)
   {
      super(param1,param2,param3,param4);
      this.availableAwards = param5;
      this.setup();
   }
   
   private function setupBtn() : void
   {
      this.acceptBtn.addEventListener(MouseEvent.CLICK,this.onAccept);
      this.acceptBtn.buttonMode = true;
      this.acceptBtn.visible = true;
   }
   
   override public function hide() : void
   {
      this.itemContainer.removeChild(this.repeater);
      if(this.repeater)
      {
         this.repeater.removeEventListener(ItemRendererEvent.ITEM_SELECTED,this.onItemSelected);
      }
      if(this.acceptBtn)
      {
         this.acceptBtn.removeEventListener(MouseEvent.CLICK,this.onAccept);
      }
      super.hide();
   }
   
   private function setup() : void
   {
      var _loc1_:Boolean = false;
      var _loc2_:int = 0;
      var _loc5_:String = null;
      var _loc6_:String = null;
      this.dataProvider = new Array();
      var _loc3_:Dictionary = PartyEliteWinnerSelectorBanner.getAwardNameList();
      var _loc4_:GaturroInventory = user.inventory(GaturroInventory.BAG) as GaturroInventory;
      for each(_loc5_ in PartyEliteWinnerSelectorBanner.AWARD_LIST)
      {
         _loc1_ = false;
         _loc2_ = 0;
         for each(_loc6_ in this.availableAwards)
         {
            if(_loc5_ == _loc6_)
            {
               _loc2_ = _loc4_.getQuantityByType(_loc5_);
               _loc1_ = true;
               break;
            }
         }
         this.dataProvider.push({
            "name":_loc3_[_loc5_],
            "available":_loc1_,
            "amount":_loc2_
         });
      }
   }
   
   private function setupRepeater() : void
   {
      var _loc1_:IIterable = IterableFactory.build(this.dataProvider);
      this.repeater = new Repeater(_loc1_,null,Repeater.SINGLE_SELECTABLE);
      this.repeater.rows = 1;
      this.repeater.itemRendererFactory = new GenericItemRendererFactory(ElitePartyAwardItemRenderer,PartyEliteWinnerSelectorBanner(owner).getDefinition("awardRendererAsset"));
      this.repeater.build();
      this.itemContainer.addChild(this.repeater);
      this.repeater.addEventListener(ItemRendererEvent.ITEM_SELECTED,this.onItemSelected);
   }
   
   override public function dispose() : void
   {
      if(this.repeater)
      {
         this.repeater.removeEventListener(ItemRendererEvent.ITEM_SELECTED,this.onItemSelected);
         this.repeater.dispose();
      }
      if(this.acceptBtn)
      {
         this.acceptBtn.removeEventListener(MouseEvent.CLICK,this.onAccept);
      }
      super.dispose();
   }
   
   private function onAccept(param1:MouseEvent) : void
   {
      PartyEliteWinnerSelectorBanner(owner).setAward(this.award);
   }
   
   override public function show(param1:Object = null) : void
   {
      super.show(param1);
      this.itemContainer = view.getChildByName(REPEATER_CONTAINER_NAME) as Sprite;
      this.setupRepeater();
      this.acceptBtn = view.getChildByName("acceptBtn") as MovieClip;
      this.acceptBtn.visible = false;
   }
   
   private function onItemSelected(param1:ItemRendererEvent) : void
   {
      this.award = param1.itemRenderer.data.name.toString();
      if(!this.acceptBtn.visible)
      {
         this.setupBtn();
      }
   }
}
