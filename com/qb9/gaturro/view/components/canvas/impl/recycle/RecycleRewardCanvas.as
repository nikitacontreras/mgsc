package com.qb9.gaturro.view.components.canvas.impl.recycle
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.view.components.canvas.common.ExplanationCanvas;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   
   public class RecycleRewardCanvas extends com.qb9.gaturro.view.components.canvas.common.ExplanationCanvas
   {
       
      
      private var holder:DisplayObjectContainer;
      
      public function RecycleRewardCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:InstantiableGuiModal)
      {
         super(param1,param2,param3,param4);
      }
      
      private function sign(param1:Number) : int
      {
         return param1 > 0 ? 1 : (param1 < 0 ? -1 : 0);
      }
      
      private function loadReward(param1:String) : void
      {
         api.libraries.fetch(param1,this.onLoadComplete);
      }
      
      override public function show(param1:Object = null) : void
      {
         this.loadReward(param1.toString());
         super.show(param1);
      }
      
      private function onLoadComplete(param1:DisplayObject) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:MovieClip = null;
         _loc4_ = 25;
         _loc5_ = 20;
         if((Boolean(_loc6_ = param1 as MovieClip)) && "process" in _loc6_)
         {
            _loc6_.process();
            param1.x -= _loc4_ * (_loc6_.sizeW - 1);
            param1.x += _loc4_ * 0.3 * (_loc6_.sizeH - 1);
            param1.y -= _loc5_ * (_loc6_.sizeH - 1);
         }
         var _loc7_:Number = 150 / param1.width;
         var _loc8_:Number = 120 / param1.height;
         var _loc9_:Number = Math.min(_loc7_,_loc8_);
         param1.scaleX = this.sign(param1.scaleX) * _loc9_;
         param1.scaleY = this.sign(param1.scaleY) * _loc9_;
         this.holder.addChild(param1);
      }
      
      override protected function setupShowView() : void
      {
         super.setupShowView();
         this.holder = view.getChildByName("holder") as MovieClip;
      }
   }
}
