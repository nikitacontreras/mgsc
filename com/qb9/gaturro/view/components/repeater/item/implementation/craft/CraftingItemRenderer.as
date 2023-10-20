package com.qb9.gaturro.view.components.repeater.item.implementation.craft
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.event.ItemRendererEvent;
   import com.qb9.gaturro.commons.model.item.ItemConfig;
   import com.qb9.gaturro.commons.model.item.ItemDefinition;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.manager.crafting.CraftingManager;
   import com.qb9.gaturro.model.config.crafting.model.CraftingModuleModel;
   import com.qb9.gaturro.view.components.repeater.item.BaseItemRenderer;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class CraftingItemRenderer extends BaseItemRenderer
   {
      
      public static const SEND:String = "send";
      
      public static const CLAIM:String = "claim";
       
      
      private var grantedRewardCheck:Sprite;
      
      private var claimerButton:InteractiveObject;
      
      private var count:Sprite;
      
      private var completeLed:Sprite;
      
      private var sendButton:InteractiveObject;
      
      private var countLabel:TextField;
      
      private var imageHolder:Sprite;
      
      private var model:CraftingModuleModel;
      
      private var craftManager:CraftingManager;
      
      private var itemConfig:ItemConfig;
      
      private var pendingLed:Sprite;
      
      public function CraftingItemRenderer(param1:Class)
      {
         super(param1);
         this.setupItemConfig();
         this.setupCraftManager();
      }
      
      private function setupVisible() : void
      {
         if(this.pendingLed)
         {
            this.pendingLed.visible = this.craftManager.inventoryHasStock(this.model.requirement.item) && !this.model.requirement.isReached;
         }
         this.sendButton.visible = this.craftManager.inventoryHasStock(this.model.requirement.item) && !this.model.requirement.isReached;
         if(this.completeLed)
         {
            this.completeLed.visible = this.model.requirement.isReached && this.model.reward.available;
         }
         this.grantedRewardCheck.visible = this.model.reward.granted;
         this.claimerButton.visible = this.model.reward.available;
      }
      
      private function setItemConfig() : void
      {
         this.itemConfig = Context.instance.getByType(ItemConfig) as ItemConfig;
         if(this.model)
         {
            this.loadItem();
         }
      }
      
      private function onClickClaimer(param1:MouseEvent) : void
      {
         dispatchEvent(new ItemRendererEvent(CLAIM,this));
         this.setupVisible();
      }
      
      protected function onFetchCompleted(param1:DisplayObject) : void
      {
         this.imageHolder.addChild(param1);
      }
      
      override protected function setupView() : void
      {
         super.setupView();
         this.imageHolder = view.getChildByName("imageHolder") as Sprite;
         this.pendingLed = view.getChildByName("pending") as Sprite;
         this.completeLed = view.getChildByName("complete") as Sprite;
         this.grantedRewardCheck = view.getChildByName("grantedRewardCheck") as Sprite;
         this.count = view.getChildByName("countLabel") as Sprite;
         this.countLabel = this.count.getChildByName("label") as TextField;
         this.setupClaimerButton();
         this.setupSendButton();
      }
      
      private function setupItemConfig() : void
      {
         if(Context.instance.hasByType(ItemConfig))
         {
            this.setItemConfig();
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onAdded);
         }
      }
      
      private function setupCraftManager() : void
      {
         if(Context.instance.getByType(CraftingManager))
         {
            this.setCraftManager();
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onAdded);
         }
      }
      
      private function onClickSend(param1:MouseEvent) : void
      {
         dispatchEvent(new ItemRendererEvent(SEND,this));
         this.setupAmountLabel();
         this.setupVisible();
      }
      
      override public function refresh(param1:Object = null) : void
      {
         super.refresh(param1);
         this.setupVisible();
         this.setupAmountLabel();
      }
      
      override protected function dataReady() : void
      {
         super.dataReady();
         this.model = data as CraftingModuleModel;
         if(this.itemConfig)
         {
            this.loadItem();
         }
         this.setupVisible();
         this.setupAmountLabel();
      }
      
      override public function dispose() : void
      {
         this.claimerButton.removeEventListener(MouseEvent.CLICK,this.onClickClaimer);
         this.sendButton.removeEventListener(MouseEvent.CLICK,this.onClickSend);
         super.dispose();
      }
      
      private function setCraftManager() : void
      {
         this.craftManager = Context.instance.getByType(CraftingManager) as CraftingManager;
      }
      
      private function onAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == CraftingManager)
         {
            this.setCraftManager();
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onAdded);
         }
         if(param1.instanceType == ItemConfig)
         {
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onAdded);
            this.setItemConfig();
         }
      }
      
      private function loadItem() : void
      {
         var _loc1_:ItemDefinition = this.itemConfig.getDefinitionByCode(this.model.requirement.item);
         var _loc2_:String = _loc1_.icon;
         api.libraries.fetch(_loc2_,this.onFetchCompleted);
      }
      
      private function setupSendButton() : void
      {
         this.sendButton = view.getChildByName("sendButton") as InteractiveObject;
         this.sendButton.addEventListener(MouseEvent.CLICK,this.onClickSend);
      }
      
      private function setupClaimerButton() : void
      {
         this.claimerButton = view.getChildByName("claimerButton") as InteractiveObject;
         this.claimerButton.addEventListener(MouseEvent.CLICK,this.onClickClaimer);
      }
      
      private function setupAmountLabel() : void
      {
         this.countLabel.text = this.model.requirement.count + "/" + this.model.requirement.amount;
         trace("countLabel.text --> " + this.countLabel.text);
      }
   }
}
