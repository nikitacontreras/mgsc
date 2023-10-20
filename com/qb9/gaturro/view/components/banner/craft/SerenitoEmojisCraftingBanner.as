package com.qb9.gaturro.view.components.banner.craft
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.event.ItemRendererEvent;
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.model.item.ItemConfig;
   import com.qb9.gaturro.commons.model.item.ItemDefinition;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.manager.crafting.CraftingManager;
   import com.qb9.gaturro.model.config.crafting.model.CraftingModuleModel;
   import com.qb9.gaturro.view.components.repeater.item.implementation.craft.CraftingItemRenderer;
   import com.qb9.gaturro.view.components.repeater.item.implementation.craft.CraftingItemRendererFactory;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class SerenitoEmojisCraftingBanner extends InstantiableGuiModal
   {
      
      public static const CRAFT_FEATURE_CODE:int = 103;
       
      
      private var claimButton:MovieClip;
      
      private var countLabel:TextField;
      
      private var progressBar:MovieClip;
      
      private var holder:Sprite;
      
      private var craftManager:CraftingManager;
      
      private var materialList:IIterator;
      
      private var itemRendererFactory:CraftingItemRendererFactory;
      
      public function SerenitoEmojisCraftingBanner(param1:String = "", param2:String = "")
      {
         super("serenitoEmojisCraftingBanner","SerenitoEmojisCraftingBannerAsset");
         this.setupCraftManager();
      }
      
      private function configProgressBar() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:CraftingModuleModel = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
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
            if(_loc4_ == 100)
            {
               if(!(_loc5_ = api.getProfileAttribute("serenito2017/finished")))
               {
                  api.setProfileAttribute("serenito2017/finished",1);
               }
            }
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
         var _loc3_:ItemConfig = Context.instance.getByType(ItemConfig) as ItemConfig;
         var _loc4_:ItemDefinition = _loc3_.getDefinitionByCode(_loc2_.requirement.item);
         api.trackEvent("FEATURES:SERENITO2017:bannerCrafting:entrega_mascara_emoji",_loc4_.path);
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
         this.claimButton = view.getChildByName("claimButton") as MovieClip;
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
      }
      
      private function onClaimClick(param1:MouseEvent) : void
      {
         this.craftManager.claimReward(CRAFT_FEATURE_CODE);
         this.claimButton.visible = false;
         api.setProfileAttribute("serenito2017/entregado",1);
         api.playSound("serenito2017/obtengoRockola");
         api.trackEvent("FEATURES:SERENITO2017:bannerCrafting:Rockola","true");
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
         api.playSound("serenito2017/cierreBanner");
         super.close();
      }
      
      private function setupRepeater() : void
      {
         this.materialList.iterable.sort("requirementCode");
         this.itemRendererFactory = new CraftingItemRendererFactory(getDefinition("SerenitoEmojisCraftItemRendererAsset"));
         this.parseHolder();
      }
      
      private function onClickSend(param1:ItemRendererEvent) : void
      {
         var _loc2_:CraftingModuleModel = param1.itemRenderer.data as CraftingModuleModel;
         this.craftManager.increaseFromInventory(CRAFT_FEATURE_CODE,_loc2_.requirement.item);
         api.playSound("serenito2017/acumuloEmoji");
         api.trackEvent("FEATURES:SERENITO2017:bannerCrafting:CargaMascara",_loc2_.requirement.item.toString());
         this.setupVisible();
         this.configProgressBar();
         api.playSound("serenito2017/cargaRockola");
      }
      
      private function parseHolder() : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:CraftingItemRenderer = null;
         var _loc4_:Object = null;
         this.materialList.reset();
         var _loc1_:int = this.holder.numChildren;
         while(this.materialList.next())
         {
            _loc2_ = this.holder.getChildAt(this.materialList.index) as Sprite;
            _loc4_ = this.materialList.current() as Object;
            _loc3_ = this.itemRendererFactory.buildItemRenderer(_loc4_) as CraftingItemRenderer;
            _loc3_.addEventListener(CraftingItemRenderer.CLAIM,this.onClickClaim);
            _loc3_.addEventListener(CraftingItemRenderer.SEND,this.onClickSend);
            _loc2_.addChild(_loc3_);
         }
      }
   }
}

import com.qb9.gaturro.view.components.repeater.item.AbstractItemRenderer;
import com.qb9.gaturro.view.components.repeater.item.implementation.craft.CraftingItemRendererFactory;

class SerenitoEmojisCraftingItemRendererFactory extends com.qb9.gaturro.view.components.repeater.item.implementation.craft.CraftingItemRendererFactory
{
    
   
   public function SerenitoEmojisCraftingItemRendererFactory()
   {
      super(null);
   }
   
   override public function buildItemRenderer(param1:Object) : AbstractItemRenderer
   {
      var _loc2_:SerenitoEmojisCraftingItemRenderer = new SerenitoEmojisCraftingItemRenderer(param1.view);
      _loc2_.data = param1.data;
      return _loc2_;
   }
}

import com.qb9.gaturro.view.components.repeater.item.implementation.craft.CraftingItemRenderer;
import flash.display.Sprite;

class SerenitoEmojisCraftingItemRenderer extends CraftingItemRenderer
{
    
   
   private var _view:Sprite;
   
   public function SerenitoEmojisCraftingItemRenderer(param1:Sprite)
   {
      this._view = param1;
      super(null);
   }
   
   override protected function getView() : Sprite
   {
      return this._view;
   }
}
