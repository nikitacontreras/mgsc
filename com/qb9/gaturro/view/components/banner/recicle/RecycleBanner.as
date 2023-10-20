package com.qb9.gaturro.view.components.banner.recicle
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.user.inventory.GaturroInventorySceneObject;
   import com.qb9.gaturro.view.components.canvas.common.ExplanationCanvas;
   import com.qb9.gaturro.view.components.canvas.common.ISwitchPostExplanation;
   import com.qb9.gaturro.view.components.canvas.impl.recycle.RecycleCanvas;
   import com.qb9.gaturro.view.components.canvas.impl.recycle.RecycleRewardCanvas;
   import com.qb9.gaturro.view.gui.base.modal.AbstractCanvasFrameBanner;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   
   public class RecycleBanner extends AbstractCanvasFrameBanner implements ISwitchPostExplanation
   {
       
      
      private const REWARDS:String = "rewards";
      
      private const DISABLE:String = "disable";
      
      private const THANKS:String = "thanks";
      
      private var excluded:Dictionary;
      
      private var pointsTF:TextField;
      
      private var allItems:Array;
      
      private var itemsLoaded:Array;
      
      private var reciclePoints:int;
      
      private const RECYCLE:String = "recicle";
      
      private const EXPLANATION:String = "explanation";
      
      public function RecycleBanner()
      {
         api.trackEvent("FEATURE:RECYCLE:BANNER",api.user.username);
         api.trackEvent("FEATURE:RECYCLE:BANNER","OPEN");
         super("RecycleBanner","RecycleBannerAsset");
         this.setupData();
      }
      
      private function setupPoints() : void
      {
         if(api.user.attributes.reciclePoints)
         {
            this.reciclePoints = int(api.user.attributes.reciclePoints);
         }
         this.setPoints(this.reciclePoints);
      }
      
      private function setupItems(param1:Array) : Array
      {
         var _loc4_:Object = null;
         var _loc5_:Boolean = false;
         var _loc2_:Dictionary = new Dictionary();
         var _loc3_:Array = new Array();
         for each(_loc4_ in param1)
         {
            if(!_loc2_[_loc4_.name])
            {
               _loc5_ = false;
               if(_loc4_ is GaturroInventorySceneObject && !this.excluded[_loc4_.name])
               {
                  _loc5_ = true;
               }
               if(Boolean(_loc4_.attributes) && Boolean(_loc4_.attributes.session))
               {
                  _loc5_ = false;
               }
               if(_loc5_)
               {
                  _loc2_[_loc4_.name] = _loc4_;
                  _loc3_.push([_loc4_]);
               }
            }
         }
         return _loc3_;
      }
      
      private function setupData() : void
      {
         this.setupExcluded();
         this.setupAllItems();
         this.filterItems();
      }
      
      private function availableItem(param1:Object) : Boolean
      {
         if(this.excluded[param1.name])
         {
            return false;
         }
         if(param1.questItem)
         {
            return true;
         }
         if(Boolean(param1.attributes) && Boolean(param1.attributes.session))
         {
            return false;
         }
         return true;
      }
      
      private function setupDisplays() : void
      {
         this.pointsTF = view.getChildByName("pointsTF") as TextField;
         this.pointsTF.visible = false;
         var _loc1_:TextField = view.getChildByName("title2") as TextField;
         _loc1_.visible = false;
      }
      
      public function switchToPostExplanation() : void
      {
         if(currentCanvas == this.EXPLANATION)
         {
            api.trackEvent("FEATURE:RECYCLE:BANNER","RECYCLE");
            switchTo(this.RECYCLE,this.itemsLoaded);
         }
         else
         {
            close();
         }
      }
      
      override protected function ready() : void
      {
         this.setupDisplays();
         this.setupPoints();
         super.ready();
      }
      
      private function setupExcluded() : void
      {
         var _loc1_:String = null;
         this.excluded = new Dictionary();
         for each(_loc1_ in api.config.items.recicle.excludeList)
         {
            this.excluded[_loc1_] = _loc1_;
         }
      }
      
      private function filterItems() : void
      {
         var _loc1_:Object = null;
         this.itemsLoaded = [];
         for each(_loc1_ in this.allItems)
         {
            if(this.availableItem(_loc1_))
            {
               this.itemsLoaded.push(_loc1_);
            }
         }
      }
      
      private function getReward(param1:int) : String
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc2_:Object = settings.recycle;
         for each(_loc4_ in _loc2_)
         {
            if(param1 < _loc4_.requirement)
            {
               break;
            }
            _loc3_ = _loc4_;
         }
         return _loc3_.name;
      }
      
      public function reward(param1:int) : void
      {
         api.trackEvent("FEATURE:RECYCLE:BANNER:REWARD",param1.toString());
         var _loc2_:String = this.getReward(param1);
         if(_loc2_)
         {
            api.giveUser(_loc2_,1);
         }
         api.trackEvent("FEATURE:RECYCLE:BANNER","REWARD");
         switchTo(this.REWARDS,_loc2_);
      }
      
      private function setPoints(param1:int) : void
      {
         this.pointsTF.text = String(this.reciclePoints);
      }
      
      override protected function setupCanvas() : void
      {
         addCanvas(new com.qb9.gaturro.view.components.canvas.common.ExplanationCanvas(this.EXPLANATION,this.EXPLANATION,canvasContainer,this));
         addCanvas(new com.qb9.gaturro.view.components.canvas.common.ExplanationCanvas(this.DISABLE,this.DISABLE,canvasContainer,this));
         addCanvas(new RecycleCanvas(this.RECYCLE,this.RECYCLE,canvasContainer,this,settings.recycle[0].requirement));
         addCanvas(new com.qb9.gaturro.view.components.canvas.common.ExplanationCanvas(this.THANKS,this.THANKS,canvasContainer,this));
         addCanvas(new RecycleRewardCanvas(this.REWARDS,this.REWARDS,canvasContainer,this));
      }
      
      private function setupAllItems() : void
      {
         this.allItems = this.setupItems(api.user.allItems as Array);
      }
      
      override protected function setInitialCanvasName() : void
      {
         if(this.itemsLoaded.length == 0)
         {
            api.trackEvent("FEATURE:RECYCLE:BANNER","DISABLE");
            initialCanvasName = this.DISABLE;
         }
         else
         {
            api.trackEvent("FEATURE:RECYCLE:BANNER","EXPLANATION");
            initialCanvasName = this.EXPLANATION;
         }
      }
   }
}
