package com.qb9.gaturro.view.world.whitelist
{
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.whitelist.WhiteListVariableReplacer;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.view.MamboView;
   import flash.display.DisplayObject;
   
   public final class WhiteListPane extends MamboView
   {
      
      private static const SCREEN_MARGIN:uint = 0;
      
      private static const SCREEN_WIDTH:uint = 179;
       
      
      private var tasks:TaskContainer;
      
      private var variables:WhiteListVariableReplacer;
      
      private var tree:WhiteListNode;
      
      public function WhiteListPane(param1:WhiteListNode, param2:WhiteListVariableReplacer, param3:TaskContainer)
      {
         super();
         this.tree = param1;
         this.variables = param2;
         this.tasks = param3;
      }
      
      private function cropAtCategory(param1:WhiteListViewEvent) : void
      {
         var _loc2_:WhiteListScreen = param1.target as WhiteListScreen;
         this.disposeAfter(_loc2_);
      }
      
      override protected function whenAddedToStage() : void
      {
         addEventListener(WhiteListViewEvent.CATEGORY_SELECTED,this.whenCategoryIsSelected);
         addEventListener(WhiteListViewEvent.CROP,this.cropAtCategory);
         this.addScreen(this.tree);
         this.show(this,1);
      }
      
      override public function dispose() : void
      {
         this.disposeSince(0);
         removeEventListener(WhiteListViewEvent.CATEGORY_SELECTED,this.whenCategoryIsSelected);
         this.tree = null;
         this.tasks = null;
         super.dispose();
      }
      
      private function whenCategoryIsSelected(param1:WhiteListViewEvent) : void
      {
         var _loc2_:WhiteListScreen = param1.target as WhiteListScreen;
         this.disposeAfter(_loc2_);
         this.addScreen(param1.node,param1.pos);
      }
      
      private function addScreen(param1:WhiteListNode, param2:int = 0) : void
      {
         var _loc3_:WhiteListScreen = null;
         _loc3_ = new WhiteListScreen(param1,this.variables,param2);
         _loc3_.x = (SCREEN_WIDTH + SCREEN_MARGIN) * (numChildren - 1);
         addChild(_loc3_);
         if(param2)
         {
            this.show(_loc3_,1);
         }
      }
      
      private function disposeSince(param1:int) : void
      {
         var _loc3_:WhiteListScreen = null;
         var _loc2_:int = numChildren - 1;
         param1++;
         while(_loc2_ >= param1)
         {
            _loc3_ = getChildAt(_loc2_) as WhiteListScreen;
            _loc3_.dispose();
            removeChildAt(_loc2_);
            _loc2_--;
         }
      }
      
      private function show(param1:DisplayObject, param2:Number) : void
      {
         param1.alpha = 0;
         this.tasks.add(new Tween(param1,250,{"alpha":param2}));
      }
      
      private function disposeAfter(param1:WhiteListScreen) : void
      {
         this.disposeSince(getChildIndex(param1));
      }
   }
}
