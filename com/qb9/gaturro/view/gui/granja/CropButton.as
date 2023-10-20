package com.qb9.gaturro.view.gui.granja
{
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.view.world.GaturroHomeGranjaView;
   import farm.CropBuyButton;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   
   public class CropButton extends CropBuyButton
   {
       
      
      private var cropObj:Object;
      
      private var popUp:com.qb9.gaturro.view.gui.granja.GranjaModal;
      
      private var granjaView:GaturroHomeGranjaView;
      
      private var tasks:TaskRunner;
      
      private var jobLevel:int;
      
      private var objectAPI:GaturroSceneObjectAPI;
      
      public var playingAnim:Boolean;
      
      public var absoluteIndex:int;
      
      public var relativeIndex:int;
      
      private const margin:int = 30;
      
      private var playSound:Function;
      
      public function CropButton(param1:Object)
      {
         super();
         this.cropObj = param1.cropObj;
         this.relativeIndex = param1.relativeIndex;
         this.absoluteIndex = param1.absoluteIndex;
         this.jobLevel = param1.jobLevel;
         this.granjaView = param1.granjaView;
         this.objectAPI = param1.objectAPI;
         this.tasks = param1.tasks;
         this.popUp = param1.popUp;
         this.playSound = param1.playSound;
         x = (width + this.margin) * this.relativeIndex;
         buttonMode = true;
         this.playingAnim = false;
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         addEventListener(MouseEvent.CLICK,this.onClick);
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Array = null;
         cropName.text = api.getText(this.cropObj.gameName);
         if(this.cropObj.unlockAt <= this.jobLevel)
         {
            unlocked.price.text = this.cropObj.price;
            locked.visible = false;
            lock.visible = false;
            timeToGrow.infoTime.text = this.formatTime(this.cropObj.timeToGrow);
         }
         else
         {
            unlocked.visible = false;
            timeToGrow.visible = false;
            lock.visible = true;
            locked.level.text = api.getText("NIVEL: ") + this.cropObj.unlockAt;
            _loc1_ = 1 / 3;
            _loc2_ = 1 / 3;
            _loc3_ = 1 / 3;
            _loc4_ = [new ColorMatrixFilter([_loc1_,_loc2_,_loc3_,0,0,_loc1_,_loc2_,_loc3_,0,0,_loc1_,_loc2_,_loc3_,0,0,0,0,0,1,0])];
            cropName.filters = _loc4_;
            cropPH.filters = _loc4_;
         }
         api.libraries.fetch(this.cropObj.name + "Seed",this.addImageToButton);
      }
      
      private function formatTime(param1:int) : String
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:int = param1 / 1000;
         _loc5_ = Math.floor(_loc2_ / 3600);
         _loc2_ -= _loc5_ * 3600;
         _loc4_ = Math.floor(_loc2_ / 60);
         _loc2_ -= _loc4_ * 60;
         _loc3_ = _loc2_;
         var _loc6_:String = _loc4_ > 9 ? _loc4_.toString() : "0" + _loc4_.toString();
         var _loc7_:String = _loc3_ > 9 ? _loc3_.toString() : "0" + _loc3_.toString();
         return _loc5_ + ":" + _loc6_ + ":" + _loc7_;
      }
      
      private function addImageToButton(param1:DisplayObject) : void
      {
         cropPH.addChild(param1);
         addChild(lock);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:int = api.getProfileAttribute("coins") as int;
         if(this.cropObj.unlockAt <= this.jobLevel && _loc2_ >= this.cropObj.price)
         {
            this.granjaView.plantCrop(this.cropObj,this.objectAPI);
            this.granjaView.activeCrop = this.cropObj;
            this.granjaView.planting = true;
            this.playSound("granja/saleBrote");
            this.popUp.close();
            Telemetry.getInstance().trackEvent(TrackCategories.GRANJA,TrackActions.GRANJA_PLANT + ":" + this.cropObj.name,"",this.cropObj.price);
         }
         else
         {
            if(this.playingAnim)
            {
               return;
            }
            this.playingAnim = true;
            _loc3_ = x;
            _loc4_ = int(unlocked.price.textColor);
            if(this.cropObj.unlockAt <= this.jobLevel)
            {
               unlocked.price.textColor = 16711680;
            }
            this.tasks.add(new Sequence(new Tween(this,200,{"x":_loc3_ + 5},{"transition":"easeIn"}),new Tween(this,200,{"x":_loc3_ - 5},{"transition":"easeIn"}),new Tween(this,100,{"x":_loc3_},{"transition":"easeIn"}),new Tween(unlocked.price,1,{"textColor":_loc4_}),new Tween(this,1,{"playingAnim":false})));
         }
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         filters = [];
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         filters = [new GlowFilter(16777215)];
      }
   }
}
