package com.qb9.gaturro.view.gui.iphone2.screens
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.math.Random;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.audio;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.net.metrics.TrackAreas;
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import com.qb9.gaturro.view.gui.iphone2.transitions.*;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.*;
   
   public class BaseIPhone2Screen extends Sprite implements IDisposable
   {
      
      private static const DISABLED_ALPHA:Number = 0.5;
       
      
      private var _disposed:Boolean = false;
      
      private var defaultTexts:Object;
      
      protected var asset:MovieClip;
      
      protected var main:IPhone2Modal;
      
      protected var actions:Object;
      
      public function BaseIPhone2Screen(param1:IPhone2Modal, param2:MovieClip, param3:Object)
      {
         this.defaultTexts = {};
         super();
         this.main = param1;
         this.asset = param2;
         this.actions = param3;
         addChild(param2);
         this.init();
      }
      
      protected function backButton() : void
      {
      }
      
      protected function delay(param1:Function, ... rest) : void
      {
         setTimeout(this.runFunc,50,param1,rest);
      }
      
      protected function getTarget(param1:Event) : DisplayObject
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         while(Boolean(_loc2_) && _loc2_ !== this)
         {
            if(_loc2_.name in this.actions)
            {
               return _loc2_;
            }
            _loc2_ = _loc2_.parent;
         }
         return null;
      }
      
      protected function whenReady() : void
      {
      }
      
      protected function defaultText(param1:String, param2:String) : void
      {
         var _loc3_:TextField = this.getByPath(param1) as TextField;
         param2 = param2.toUpperCase();
         if(!_loc3_ || _loc3_.text && _loc3_.text !== param2)
         {
            return;
         }
         var _loc4_:String = _loc3_.name;
         this.defaultTexts[_loc4_] = _loc3_.text = param2;
         this.actions[_loc4_] = this.emptyField;
      }
      
      private function init() : void
      {
         this.actions.back = this.backButton;
         addEventListener(MouseEvent.CLICK,this.checkClickedObject);
         addEventListener(Event.ADDED_TO_STAGE,this._whenAdded);
         this.addEventListener(Event.ADDED_TO_STAGE,this._atOnce);
      }
      
      protected function getByPath(param1:String) : DisplayObject
      {
         var _loc2_:DisplayObject = DisplayUtil.getByPath(this.asset,param1);
         if(_loc2_ === null)
         {
            logger.warning("BaseIPhoneScreen > getByPath > Could not find",param1);
         }
         return _loc2_;
      }
      
      protected function atOnce() : void
      {
      }
      
      private function transition(param1:String, param2:uint, param3:Object = null) : void
      {
         this.main.transition(new IPhone2Transition(param1,param2,param3));
      }
      
      protected function get focus() : InteractiveObject
      {
         return null;
      }
      
      private function checkClickedObject(param1:Event) : void
      {
         var _loc2_:DisplayObject = this.getTarget(param1);
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:Function = this.actions[_loc2_.name] as Function;
         if(_loc3_ !== this.backButton)
         {
            this.iphoneSound();
         }
         if(_loc3_.length)
         {
            _loc3_(_loc2_);
         }
         else
         {
            _loc3_();
         }
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.checkClickedObject);
         removeEventListener(Event.ADDED_TO_STAGE,this._whenAdded);
         this.main = null;
         this.actions = null;
         this.asset = null;
         this._disposed = true;
      }
      
      final public function ready() : void
      {
         this.whenReady();
         var _loc1_:InteractiveObject = this.focus;
         if(!stage || !_loc1_)
         {
            return;
         }
         stage.focus = _loc1_;
         var _loc2_:TextField = _loc1_ as TextField;
         if(!_loc2_)
         {
            return;
         }
         _loc2_.setSelection(_loc2_.length,_loc2_.length);
      }
      
      protected function whenAdded() : void
      {
      }
      
      private function _whenAdded(param1:Event) : void
      {
         this.whenAdded();
      }
      
      protected function iphoneSound() : void
      {
         audio.addLazyPlay("celu" + Random.randint(1,4));
      }
      
      private function emptyField(param1:TextField) : void
      {
         param1.text = "";
         delete this.actions[param1.name];
      }
      
      protected function back(param1:String, param2:Object = null) : void
      {
         this.transition(param1,IPhone2TransitionDirection.RIGHT,param2);
      }
      
      private function runFunc(param1:Function, param2:Array) : void
      {
         if(!this.isDisposed)
         {
            param1.apply(null,param2);
         }
      }
      
      private function _atOnce(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this._atOnce);
         this.atOnce();
      }
      
      protected function setText(param1:String, param2:String) : void
      {
         var _loc3_:TextField = this.getByPath(param1) as TextField;
         if(Boolean(_loc3_) && param2 != null)
         {
            _loc3_.text = region.getText(param2).toUpperCase();
         }
      }
      
      protected function setVisible(param1:String, param2:Boolean) : void
      {
         var _loc3_:DisplayObject = this.getByPath(param1);
         if(_loc3_)
         {
            _loc3_.visible = param2;
         }
      }
      
      public function goto(param1:String, param2:Object = null) : void
      {
         var _loc3_:String = ":";
         if(Boolean(param2) && Boolean(param2.message))
         {
            _loc3_ += param2.message;
         }
         Telemetry.getInstance().trackScreen(TrackAreas.CELLPHONE + ":" + param1 + _loc3_);
         this.transition(param1,IPhone2TransitionDirection.LEFT,param2);
      }
      
      public function get isDisposed() : Boolean
      {
         return this._disposed;
      }
      
      protected function setEnabled(param1:String, param2:Boolean) : void
      {
         var _loc3_:DisplayObject = this.getByPath(param1);
         if(!_loc3_)
         {
            return;
         }
         _loc3_.alpha = param2 ? 1 : DISABLED_ALPHA;
         if(_loc3_ is InteractiveObject)
         {
            InteractiveObject(_loc3_).mouseEnabled = param2;
         }
         if(_loc3_ is DisplayObjectContainer)
         {
            DisplayObjectContainer(_loc3_).mouseChildren = param2;
         }
      }
   }
}
