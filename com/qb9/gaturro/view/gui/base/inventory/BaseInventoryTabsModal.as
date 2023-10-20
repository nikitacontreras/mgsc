package com.qb9.gaturro.view.gui.base.inventory
{
   import assets.InventoryTabsMC;
   import com.qb9.gaturro.globals.api;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class BaseInventoryTabsModal extends BaseInventoryModal
   {
       
      
      private var contentHolder:Sprite;
      
      private var btn0:DisplayObject;
      
      private var btn1:DisplayObject;
      
      private var btn2:DisplayObject;
      
      private var btn3:DisplayObject;
      
      private var btn4:DisplayObject;
      
      private const SELECTED:String = "selected";
      
      private var wraps:Array;
      
      public var widgets:Array;
      
      private const UNSELECTED:String = "unselected";
      
      private var tabs:MovieClip;
      
      public function BaseInventoryTabsModal(param1:Array, param2:MovieClip = null, param3:int = 0)
      {
         super(null);
         this.widgets = param1;
         this.wraps = new Array();
         param2 ||= new InventoryTabsMC();
         this.setupContentHolder(param2);
         var _loc4_:int = 0;
         while(_loc4_ < this.widgets.length)
         {
            this.wraps.push(param1[_loc4_]);
            this.init(param1[_loc4_],this.contentHolder,param3);
            _loc4_++;
         }
         this.initTabs(param2);
      }
      
      private function clickPassportBtn1(param1:MouseEvent) : void
      {
         this.trackingVipInventoryUse();
         api.instantiateBannerModal("LooksAnimales",null,"looksAnimales");
      }
      
      protected function setupContentHolder(param1:DisplayObjectContainer) : void
      {
         this.contentHolder = param1.getChildByName("holder") as Sprite;
      }
      
      public function get tabNumber() : int
      {
         return !!this.widgets ? int(this.widgets.length) : 0;
      }
      
      protected function get activeInventory() : InventoryWidget
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.widgets.length)
         {
            if(InventoryWidget(this.widgets[_loc1_]).visible == true)
            {
               return InventoryWidget(this.widgets[_loc1_]);
            }
            _loc1_++;
         }
         return null;
      }
      
      override protected function init(param1:Sprite, param2:Sprite, param3:int = 0) : void
      {
         param2.addChild(param1);
         if(this.hasOverlay())
         {
            this.addRactAndOverlay(param2);
         }
         param2.mouseEnabled = false;
         mouseEnabled = false;
      }
      
      private function trackingVipInventoryUse() : void
      {
         if(api.isCitizen)
         {
            api.trackEvent("FEATURES:INVENTARIO_VIP:USER_ACCESS","VIP");
         }
         else
         {
            api.trackEvent("FEATURES:INVENTARIO_VIP:USER_ACCESS","NO_VIP");
         }
      }
      
      override protected function hasOverlay() : Boolean
      {
         return false;
      }
      
      override public function dispose() : void
      {
         var _loc2_:int = 0;
         var _loc3_:HouseInventoryWidget = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.widgets.length)
         {
            if(this.tabs["tab" + (_loc1_ + 1).toString()])
            {
               this.tabs["tab" + (_loc1_ + 1).toString()].removeEventListener(MouseEvent.CLICK,this.clickOnTab);
            }
            _loc1_++;
         }
         if(this.widgets)
         {
            _loc2_ = 0;
            while(_loc2_ < this.widgets.length)
            {
               _loc3_ = this.widgets[_loc2_];
               if(_loc3_)
               {
                  _loc3_.dispose();
               }
               _loc2_++;
            }
         }
         this.widgets = null;
         this.wraps = null;
         this.disposeBtns();
         super.dispose();
      }
      
      private function disposeBtns() : void
      {
         if(Boolean(this.btn0) && Boolean(this.btn1) && Boolean(this.btn2))
         {
            this.btn0.removeEventListener(MouseEvent.CLICK,this.clickPassportBtn0);
            this.btn1.removeEventListener(MouseEvent.CLICK,this.clickPassportBtn1);
            this.btn2.removeEventListener(MouseEvent.CLICK,this.clickPassportBtn2);
         }
      }
      
      private function clickOnTab(param1:MouseEvent) : void
      {
         var _loc2_:String = DisplayObject(param1.currentTarget).name;
         var _loc3_:Array = _loc2_.split("tab");
         var _loc4_:int = int(_loc3_[1]);
         this.selectTab(_loc4_);
      }
      
      private function clickPassportBtn3(param1:MouseEvent) : void
      {
         this.trackingVipInventoryUse();
         api.instantiateBannerModal("SuperheroWardrobeBanner");
      }
      
      private function clickPassportBtn4(param1:MouseEvent) : void
      {
         this.trackingVipInventoryUse();
         api.instantiateBannerModal("VestidorTematico",null,"invierno");
      }
      
      private function initTabs(param1:MovieClip) : void
      {
         var _loc3_:MovieClip = null;
         var _loc5_:MovieClip = null;
         this.tabs = param1;
         addChild(this.tabs);
         this.setChildIndex(this.tabs,0);
         var _loc2_:int = 0;
         while(_loc2_ < this.widgets.length)
         {
            this.tabs.getChildByName("tab" + (_loc2_ + 1).toString()).addEventListener(MouseEvent.CLICK,this.clickOnTab);
            _loc2_++;
         }
         while(this.tabs.getChildByName("tab" + (++_loc2_).toString()) != null)
         {
            (_loc5_ = MovieClip(this.tabs.getChildByName("tab" + _loc2_.toString()))).visible = false;
         }
         var _loc4_:int = 1;
         while(_loc4_ <= this.widgets.length)
         {
            _loc3_ = MovieClip(MovieClip(this.tabs.getChildByName("tab" + _loc4_)).getChildByName("image"));
            _loc3_.gotoAndStop(_loc4_);
            _loc3_.mouseChildren = false;
            _loc3_.mouseEnabled = false;
            _loc4_++;
         }
         this.selectTab(1);
      }
      
      public function selectTab(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.widgets.length)
         {
            MovieClip(this.tabs.getChildByName("tab" + (_loc2_ + 1).toString())).gotoAndStop(this.UNSELECTED);
            _loc2_++;
         }
         MovieClip(this.tabs.getChildByName("tab" + param1.toString())).gotoAndStop(this.SELECTED);
         var _loc3_:int = 0;
         while(_loc3_ < this.widgets.length)
         {
            this.widgets[_loc3_].visible = false;
            _loc3_++;
         }
         var _loc4_:int = param1 - 1;
         this.widgets[_loc4_].visible = true;
         this.btn0 = this.tabs.getChildByName("btnPassPort0");
         this.btn1 = this.tabs.getChildByName("btnPassPort1");
         this.btn2 = this.tabs.getChildByName("btnPassPort2");
         this.btn3 = this.tabs.getChildByName("btnPassPort3");
         this.btn4 = this.tabs.getChildByName("btnPassPort4");
         if(Boolean(this.btn0) && Boolean(this.btn1) && Boolean(this.btn2) && Boolean(this.btn3))
         {
            this.btn0.visible = false;
            this.btn1.visible = false;
            this.btn2.visible = false;
            this.btn3.visible = false;
            this.btn4.visible = false;
         }
         if(this.widgets[_loc4_] is PassportInventoryWidget)
         {
            this.btn0.visible = true;
            (this.btn0 as MovieClip).buttonMode = true;
            this.btn0.addEventListener(MouseEvent.CLICK,this.clickPassportBtn0);
            this.btn1.visible = true;
            (this.btn1 as MovieClip).buttonMode = true;
            this.btn1.addEventListener(MouseEvent.CLICK,this.clickPassportBtn1);
            this.btn2.visible = true;
            (this.btn2 as MovieClip).buttonMode = true;
            this.btn2.addEventListener(MouseEvent.CLICK,this.clickPassportBtn2);
            this.btn3.visible = true;
            (this.btn3 as MovieClip).buttonMode = true;
            this.btn3.addEventListener(MouseEvent.CLICK,this.clickPassportBtn3);
            this.btn4.visible = true;
            (this.btn4 as MovieClip).buttonMode = true;
            this.btn4.addEventListener(MouseEvent.CLICK,this.clickPassportBtn4);
         }
      }
      
      override protected function addRactAndOverlay(param1:Sprite) : void
      {
      }
      
      private function clickPassportBtn0(param1:MouseEvent) : void
      {
         this.trackingVipInventoryUse();
         api.instantiateBannerModal("WearBuilder",null,"gatoons");
      }
      
      private function clickPassportBtn2(param1:MouseEvent) : void
      {
         this.trackingVipInventoryUse();
         api.instantiateBannerModal("LooksColegio",null,"colegio");
      }
   }
}
