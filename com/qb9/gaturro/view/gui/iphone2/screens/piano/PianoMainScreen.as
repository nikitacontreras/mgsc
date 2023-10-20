package com.qb9.gaturro.view.gui.iphone2.screens.piano
{
   import assets.PianoMainMC;
   import com.qb9.gaturro.globals.audio;
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import com.qb9.gaturro.view.gui.iphone2.screens.BaseIPhone2Screen;
   import com.qb9.gaturro.view.gui.iphone2.screens.IPhone2Screens;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class PianoMainScreen extends BaseIPhone2Screen
   {
       
      
      private const KEY_SOUND_NAME:String = "piano";
      
      private var _piano:MovieClip;
      
      private var _keyCount:uint = 12;
      
      private var _keys:Array;
      
      private var _keyFocus:MovieClip;
      
      private var _soundName:String;
      
      private var _pressing:Boolean;
      
      public function PianoMainScreen(param1:IPhone2Modal, param2:MovieClip, param3:Object)
      {
         this._keys = new Array();
         super(param1,param2,{});
      }
      
      override protected function backButton() : void
      {
         back(IPhone2Screens.MENU);
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         this._keyFocus = param1.target as MovieClip;
         var _loc2_:String = this._keyFocus.name.replace("k","");
         this._soundName = this.KEY_SOUND_NAME + _loc2_;
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         (param1.target as MovieClip).gotoAndStop("out");
         this._soundName = null;
      }
      
      private function update(param1:Event) : void
      {
         if(this._pressing && this._soundName != null)
         {
            this._keyFocus.gotoAndStop("press");
            if(!audio.isRunning(this._soundName))
            {
               audio.play(this._soundName);
            }
         }
         if(!this._pressing)
         {
            if(this._keyFocus)
            {
               this._keyFocus.gotoAndStop("out");
            }
         }
         trace("pressing: " + this._pressing);
      }
      
      override protected function whenAdded() : void
      {
         var _loc2_:String = null;
         var _loc3_:MovieClip = null;
         var _loc1_:uint = 0;
         while(_loc1_ < this._keyCount)
         {
            _loc2_ = String(_loc1_ + 1);
            _loc3_ = PianoMainMC(asset)["k" + _loc2_] as MovieClip;
            _loc3_.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
            _loc3_.mouseChildren = false;
            _loc3_.buttonMode = true;
            _loc3_.stop();
            audio.register(this.KEY_SOUND_NAME + _loc2_).start();
            this._keys.push(_loc3_);
            _loc1_++;
         }
         this._piano = PianoMainMC(asset);
         this._piano.addEventListener(Event.ENTER_FRAME,this.update);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         this._pressing = false;
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         this._pressing = true;
         if(this._soundName != null)
         {
            if(audio.isRunning(this._soundName))
            {
               audio.stop(this._soundName);
            }
            audio.play(this._soundName);
         }
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         this._pressing = false;
      }
      
      override public function dispose() : void
      {
         var _loc2_:String = null;
         var _loc3_:MovieClip = null;
         this._piano.removeEventListener(Event.ENTER_FRAME,this.update);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         super.dispose();
         var _loc1_:uint = 0;
         while(_loc1_ < this._keys.length)
         {
            _loc2_ = String(_loc1_ + 1);
            _loc3_ = this._keys[_loc1_] as MovieClip;
            _loc3_.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            _loc3_.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
            audio.disposeSound(this.KEY_SOUND_NAME + _loc2_);
            _loc1_++;
         }
      }
   }
}
