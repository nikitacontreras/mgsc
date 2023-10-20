package com.qb9.gaturro.view.components.banner.itemConsumer
{
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.user.inventory.ConsumableInventorySceneObject;
   import com.qb9.gaturro.user.inventory.GaturroInventorySceneObject;
   import com.qb9.gaturro.view.components.canvas.common.ExplanationCanvas;
   import com.qb9.gaturro.view.components.canvas.common.ISwitchPostExplanation;
   import com.qb9.gaturro.view.components.canvas.impl.itemConsumer.ConsumerCanvas;
   import com.qb9.gaturro.view.components.canvas.impl.itemConsumer.RewardCanvas;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.AbstractCanvasFrameBanner;
   import flash.utils.Dictionary;
   
   public class ItemConsumerBanner extends AbstractCanvasFrameBanner implements IHasRoomAPI, ISwitchPostExplanation
   {
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      public const REWARDS:String = "rewards";
      
      public const DISABLE:String = "disable";
      
      private var allItems:Array;
      
      private var itemsLoaded:Array;
      
      public const EXPLANATION:String = "explanation";
      
      private var included:Dictionary;
      
      public const DEPOSIT:String = "deposit";
      
      public function ItemConsumerBanner()
      {
         super("ItemConsumerBanner","ItemConsumerBannerAsset");
         this.setupExcluded();
         this.setupAllValidItems();
         this.filterItems();
      }
      
      private function validItemType(param1:Object) : Boolean
      {
         if(param1 is ConsumableInventorySceneObject)
         {
            return true;
         }
         if(param1 is GaturroInventorySceneObject)
         {
            return true;
         }
         return false;
      }
      
      private function filterAllValidItems(param1:Array) : Array
      {
         var _loc3_:Object = null;
         trace(this," > filterAllValidItems");
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            if(this.validItemType(_loc3_))
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function switchToPostExplanation() : void
      {
         if(currentCanvas == this.EXPLANATION)
         {
            switchTo(this.DEPOSIT,this.itemsLoaded);
         }
         else if(currentCanvas == this.DISABLE)
         {
            close();
         }
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
      
      private function setupExcluded() : void
      {
         var _loc1_:String = null;
         this.included = new Dictionary();
         for each(_loc1_ in api.config.items.navidadHeladera.includeList)
         {
            this.included[_loc1_] = _loc1_;
         }
      }
      
      private function filterItems() : void
      {
         var _loc1_:Object = null;
         this.itemsLoaded = [];
         for each(_loc1_ in this.allItems)
         {
            if(this.included[_loc1_.name] || _loc1_.name.indexOf("yogurt.") != -1 || _loc1_.name.indexOf("food.") != -1)
            {
               this.itemsLoaded.push(_loc1_);
            }
         }
      }
      
      override protected function setInitialCanvasName() : void
      {
         initialCanvasName = this.EXPLANATION;
      }
      
      private function setupAllValidItems() : void
      {
         this.allItems = this.filterAllValidItems(api.user.allItems as Array);
      }
      
      override protected function setupCanvas() : void
      {
         addCanvas(new com.qb9.gaturro.view.components.canvas.common.ExplanationCanvas(this.EXPLANATION,this.EXPLANATION,canvasContainer,this));
         addCanvas(new ConsumerCanvas(this.DEPOSIT,this.DEPOSIT,canvasContainer,this));
         addCanvas(new RewardCanvas(this.REWARDS,this.REWARDS,canvasContainer,this));
         addCanvas(new com.qb9.gaturro.view.components.canvas.common.ExplanationCanvas(this.DISABLE,this.DISABLE,canvasContainer,this));
      }
      
      public function switchCanvas(param1:String, param2:Object = null) : void
      {
         switchTo(param1,param2);
      }
   }
}
