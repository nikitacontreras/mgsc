package com.qb9.gaturro.view.components.banner.craft
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.event.ItemRendererEvent;
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.manager.crafting.CraftingManager;
   import com.qb9.gaturro.model.config.crafting.model.CraftingModuleModel;
   import com.qb9.gaturro.view.components.repeater.Repeater;
   import com.qb9.gaturro.view.components.repeater.item.implementation.craft.CraftingItemRenderer;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class SuitMachineBanner extends InstantiableGuiModal
   {
      
      public static const CRAFT_FEATURE_CODE:int = 100;
       
      
      private var repeater:Repeater;
      
      private var claimButton:SimpleButton;
      
      private var materialList:IIterator;
      
      private var progressBar:MovieClip;
      
      private var holder:Sprite;
      
      private var craftManager:CraftingManager;
      
      private var countLabel:TextField;
      
      public function SuitMachineBanner()
      {
         super("GatoonsMaquinaTrajeBanner","GatoonsMaquinaTrajeBannerAsset");
         this.setupCraftManager();
         api.setSession("SuitMachineBannerClosed",0);
      }
      
      private function configProgressBar() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:CraftingModuleModel = null;
         var _loc4_:int = 0;
         if(Boolean(this.craftManager) && Boolean(view))
         {
            _loc1_ = 0;
            _loc2_ = 0;
            this.materialList.reset();
            while(this.materialList.next())
            {
               _loc3_ = this.materialList.current() as CraftingModuleModel;
               _loc1_ += _loc3_.requirement.amount;
               _loc2_ += _loc3_.requirement.count;
            }
            _loc4_ = _loc2_ * 100 / _loc1_;
            this.progressBar.gotoAndStop(_loc4_);
            this.countLabel.text = _loc4_ + "%";
         }
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
      
      private function onClickClaim(param1:ItemRendererEvent) : void
      {
         var _loc2_:CraftingModuleModel = param1.itemRenderer.data as CraftingModuleModel;
         this.craftManager.claimMaterialReward(CRAFT_FEATURE_CODE,_loc2_.requirement.item);
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
      
      private function onAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == CraftingManager)
         {
            this.setCraftManager();
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onAdded);
         }
      }
      
      override protected function ready() : void
      {
         super.ready();
         this.setupMovieClips();
         this.setupRepeater();
         this.configProgressBar();
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
         this.repeater.removeEventListener(CraftingItemRenderer.CLAIM,this.onClickClaim);
         this.repeater.removeEventListener(CraftingItemRenderer.SEND,this.onClickSend);
         this.repeater.dispose();
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
         this.holder = view.getChildByName("holder") as MovieClip;
         this.setupProgressBar();
         this.setupClaimButton();
      }
      
      private function setupVisible() : void
      {
         this.claimButton.visible = this.isClaimButtonAllowed();
      }
      
      override public function close() : void
      {
         api.setSession("SuitMachineBannerClosed",1);
         super.close();
      }
      
      private function setupRepeater() : void
      {
         this.materialList.iterable.sort("requirementCode");
         this.repeater = new Repeater(this.materialList.iterable,null,Repeater.SINGLE_SELECTABLE);
         this.repeater.itemRendererFactory = new CraftingItemRendererFactory(getDefinition("SuitMachineItemRendererAsset"));
         this.repeater.addEventListener(CraftingItemRenderer.CLAIM,this.onClickClaim);
         this.repeater.addEventListener(CraftingItemRenderer.SEND,this.onClickSend);
         this.repeater.columns = 2;
         this.repeater.build();
         this.holder.addChild(this.repeater);
      }
      
      private function onClickSend(param1:ItemRendererEvent) : void
      {
         var _loc2_:CraftingModuleModel = param1.itemRenderer.data as CraftingModuleModel;
         this.craftManager.increaseFromInventory(CRAFT_FEATURE_CODE,_loc2_.requirement.item);
         this.setupVisible();
         this.configProgressBar();
      }
   }
}

import com.qb9.gaturro.view.components.repeater.item.AbstractItemRenderer;
import com.qb9.gaturro.view.components.repeater.item.IItemRendererFactory;
import com.qb9.gaturro.view.components.repeater.item.implementation.craft.CraftingItemRenderer;

class CraftingItemRendererFactory implements IItemRendererFactory
{
    
   
   private var contentViewClass:Class;
   
   public function CraftingItemRendererFactory(param1:Class)
   {
      super();
      this.contentViewClass = param1;
   }
   
   public function refreshItemRenderer(param1:AbstractItemRenderer, param2:Object = null) : AbstractItemRenderer
   {
      if(Boolean(param1) && param2 != null)
      {
         param1.refresh(param2);
      }
      else if(Boolean(param1) && param2 == null)
      {
         param1 = null;
      }
      else if(!param1 && param2 != null)
      {
         param1 = this.buildItemRenderer(param2);
      }
      return param1;
   }
   
   public function buildItemRenderer(param1:Object) : AbstractItemRenderer
   {
      var _loc2_:CraftingItemRenderer = new CraftingItemRenderer(this.contentViewClass);
      _loc2_.data = param1;
      return _loc2_;
   }
}
