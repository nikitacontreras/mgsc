package com.qb9.gaturro.view.components.banner.emoting
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.user.inventory.GaturroInventorySceneObject;
   import com.qb9.gaturro.view.components.canvas.common.ExplanationCanvas;
   import com.qb9.gaturro.view.components.canvas.common.ISwitchPostExplanation;
   import com.qb9.gaturro.view.gui.base.modal.AbstractCanvasFrameBanner;
   import flash.utils.Dictionary;
   
   public class ActionConfigurationBanner extends AbstractCanvasFrameBanner implements ISwitchPostExplanation
   {
       
      
      private const EXPLANATION:String = "explanation";
      
      private const CONFIGURE:String = "recicle";
      
      private var excluded:Dictionary;
      
      private var itemsLoaded:Array;
      
      private var allItems:Array;
      
      public function ActionConfigurationBanner()
      {
         super("ActionConfiguration","ActionConfigurationAsset");
      }
      
      private function filterRepeated(param1:Array) : Array
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
               if(_loc4_.questItem)
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
      
      override protected function ready() : void
      {
         super.ready();
         this.setupData();
         this.setupDisplays();
      }
      
      override protected function setInitialCanvasName() : void
      {
         initialCanvasName = this.CONFIGURE;
      }
      
      private function setupData() : void
      {
         this.excluded = new Dictionary();
         this.excluded["gatoonsEstatuas.estatua04"] = "gatoonsEstatuas.estatua04";
         this.excluded["gatoonsEstatuas.estatua03"] = "gatoonsEstatuas.estatua03";
         this.excluded["gatoonsEstatuas.estatua02"] = "gatoonsEstatuas.estatua02";
         this.excluded["gatoonsEstatuas.estatua01"] = "gatoonsEstatuas.estatua01";
         this.allItems = this.filterRepeated(api.user.allItems as Array);
         this.itemsLoaded = this.filterItems(this.allItems);
      }
      
      private function filterItems(param1:Array) : Array
      {
         var _loc3_:Object = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            if(this.availableItem(_loc3_))
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      private function setupDisplays() : void
      {
         trace(this,"setupDisplays()");
         api.freeze();
      }
      
      public function get items() : Array
      {
         return this.itemsLoaded;
      }
      
      public function switchToPostExplanation() : void
      {
         switchTo(this.CONFIGURE,this.itemsLoaded);
      }
      
      override protected function setupCanvas() : void
      {
         addCanvas(new com.qb9.gaturro.view.components.canvas.common.ExplanationCanvas(this.EXPLANATION,this.EXPLANATION,canvasContainer,this));
         addCanvas(new ActionConfigCanvas(this.CONFIGURE,this.CONFIGURE,canvasContainer,this));
      }
      
      override public function dispose() : void
      {
         api.unfreeze();
         super.dispose();
      }
      
      private function availableItem(param1:Object) : Boolean
      {
         if(this.excluded[param1.name])
         {
            return false;
         }
         return true;
      }
   }
}
