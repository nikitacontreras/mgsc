package com.qb9.gaturro.view.components.banner.craft
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.manager.crafting.CraftingManager;
   import com.qb9.gaturro.model.config.crafting.model.CraftingModuleModel;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class ChristmasCraftingBanner extends InstantiableGuiModal
   {
      
      public static const CRAFT_FEATURE_CODE:int = 101;
       
      
      private var materialModel:CraftingModuleModel;
      
      private var claimButton:SimpleButton;
      
      private var countLabel:TextField;
      
      private var progressBar:MovieClip;
      
      private var material:ChristmasCraftingMaterial;
      
      private var materialList:IIterator;
      
      private var craftManager:CraftingManager;
      
      public function ChristmasCraftingBanner()
      {
         super("ChristmasCraftingBanner","ChristmasCraftingBannerAsset");
         this.setupCraftManager();
      }
      
      private function configProgressBar() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(Boolean(this.craftManager) && Boolean(view))
         {
            _loc1_ = 0;
            _loc2_ = 0;
            this.materialList.reset();
            while(this.materialList.next())
            {
               this.materialModel = this.materialList.current() as CraftingModuleModel;
               _loc1_ += this.materialModel.requirement.amount;
               _loc2_ += this.materialModel.requirement.count;
            }
            _loc3_ = _loc2_ * 100 / _loc1_;
            this.progressBar.gotoAndStop(_loc3_);
            this.countLabel.text = _loc3_ + "%";
         }
      }
      
      private function setupMaterial() : void
      {
         var _loc1_:MovieClip = view.getChildByName("material") as MovieClip;
         this.material = new ChristmasCraftingMaterial(_loc1_);
         this.material.data = this.materialModel;
         this.material.addEventListener(ChristmasCraftingMaterial.CLAIM,this.onClickClaim);
         this.material.addEventListener(ChristmasCraftingMaterial.SEND,this.onClickSend);
      }
      
      private function setupClaimButton() : void
      {
         var _loc1_:Boolean = this.isClaimButtonAllowed();
         this.claimButton = view.getChildByName("claimButton") as SimpleButton;
         if(!this.claimButton.hasEventListener(MouseEvent.CLICK))
         {
            this.claimButton.addEventListener(MouseEvent.CLICK,this.onClaimClick);
         }
         this.claimButton.visible = _loc1_;
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
      
      private function onClickSend(param1:Event) : void
      {
         this.craftManager.increaseFromInventory(CRAFT_FEATURE_CODE,this.materialModel.requirement.item);
         this.setupVisible();
         this.configProgressBar();
      }
      
      private function onAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == CraftingManager)
         {
            this.setCraftManager();
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onAdded);
         }
      }
      
      private function onClickClaim(param1:Event) : void
      {
         this.craftManager.claimMaterialReward(CRAFT_FEATURE_CODE,this.materialModel.requirement.item);
         this.setupVisible();
      }
      
      override protected function ready() : void
      {
         super.ready();
         this.setupMovieClips();
         this.configProgressBar();
         this.setupMaterial();
      }
      
      private function setupProgressBar() : void
      {
         this.progressBar = view.getChildByName("progressBar") as MovieClip;
         var _loc1_:Sprite = this.progressBar.getChildByName("countLabel") as Sprite;
         this.countLabel = _loc1_.getChildByName("label") as TextField;
      }
      
      private function onClaimClick(param1:MouseEvent) : void
      {
         this.craftManager.claimReward(CRAFT_FEATURE_CODE);
         this.claimButton.visible = false;
      }
      
      override public function dispose() : void
      {
         if(this.claimButton)
         {
            this.claimButton.removeEventListener(MouseEvent.CLICK,this.onClaimClick);
         }
         super.dispose();
      }
      
      private function setCraftManager() : void
      {
         this.craftManager = Context.instance.getByType(CraftingManager) as CraftingManager;
         this.materialList = this.craftManager.getMaterialList(CRAFT_FEATURE_CODE);
         this.craftManager.freezeInventoryMap();
         this.configProgressBar();
      }
      
      private function setupMovieClips() : void
      {
         this.setupProgressBar();
         this.setupClaimButton();
      }
      
      private function isClaimButtonAllowed() : Boolean
      {
         var _loc2_:CraftingModuleModel = null;
         this.materialList.reset();
         var _loc1_:Boolean = false;
         while(this.materialList.next())
         {
            _loc2_ = this.materialList.current() as CraftingModuleModel;
            _loc1_ = _loc2_.isReached;
            if(!_loc1_)
            {
               break;
            }
         }
         return _loc1_ && !this.craftManager.isRewardGranted(CRAFT_FEATURE_CODE);
      }
      
      private function setupVisible() : void
      {
         this.claimButton.visible = this.isClaimButtonAllowed();
      }
   }
}

import com.qb9.gaturro.commons.context.Context;
import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
import com.qb9.gaturro.commons.event.ContextEvent;
import com.qb9.gaturro.commons.model.item.ItemConfig;
import com.qb9.gaturro.manager.crafting.CraftingManager;
import com.qb9.gaturro.model.config.crafting.model.CraftingModuleModel;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.text.TextField;

class ChristmasCraftingMaterial extends EventDispatcher implements ICheckableDisposable
{
   
   public static const SEND:String = "send";
   
   public static const CLAIM:String = "claim";
    
   
   private var _disposed:Boolean;
   
   private var coloredItem:Sprite;
   
   private var count:Sprite;
   
   private var sendButton:SimpleButton;
   
   private var view:MovieClip;
   
   private var imageHolder:Sprite;
   
   private var model:CraftingModuleModel;
   
   private var countLabel:TextField;
   
   private var craftManager:CraftingManager;
   
   private var itemConfig:ItemConfig;
   
   private var grantedRewardCheck:Sprite;
   
   public function ChristmasCraftingMaterial(param1:MovieClip)
   {
      super();
      this.view = param1;
      this.setupView();
      this.setupItemConfig();
      this.setupCraftManager();
   }
   
   protected function setupView() : void
   {
      this.imageHolder = this.view.getChildByName("imageHolder") as Sprite;
      this.coloredItem = this.view.getChildByName("coloredItem") as Sprite;
      this.grantedRewardCheck = this.view.getChildByName("grantedRewardCheck") as Sprite;
      this.count = this.view.getChildByName("countLabel") as Sprite;
      this.countLabel = this.count.getChildByName("label") as TextField;
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
   
   private function set data(param1:CraftingModuleModel) : void
   {
      this.model = param1;
      this.setupVisible();
      this.setupAmountLabel();
   }
   
   private function setupVisible() : void
   {
      this.coloredItem.visible = Boolean(this.craftManager.inventoryHasStock(this.model.requirement.item)) && !this.model.requirement.isReached;
      this.sendButton.visible = Boolean(this.craftManager.inventoryHasStock(this.model.requirement.item)) && !this.model.requirement.isReached;
      this.count.visible = !this.model.requirement.isReached;
   }
   
   private function onClickSend(param1:MouseEvent) : void
   {
      dispatchEvent(new Event(SEND));
      this.setupAmountLabel();
      this.setupVisible();
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
   
   public function dispose() : void
   {
      this.sendButton.removeEventListener(MouseEvent.CLICK,this.onClickSend);
      this._disposed = true;
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
   
   private function setCraftManager() : void
   {
      this.craftManager = Context.instance.getByType(CraftingManager) as CraftingManager;
   }
   
   private function setupSendButton() : void
   {
      this.sendButton = this.view.getChildByName("sendButton") as SimpleButton;
      this.sendButton.addEventListener(MouseEvent.CLICK,this.onClickSend);
   }
   
   public function get disposed() : Boolean
   {
      return this._disposed;
   }
   
   private function setItemConfig() : void
   {
      this.itemConfig = Context.instance.getByType(ItemConfig) as ItemConfig;
   }
   
   private function setupAmountLabel() : void
   {
      this.countLabel.text = this.model.requirement.count + "/" + this.model.requirement.amount;
   }
}
