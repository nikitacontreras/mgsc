package com.qb9.gaturro.manager.music
{
   import com.qb9.flashlib.net.LoadFile;
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.globals.audio;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class MusicSoundPlayer implements ICheckableDisposable
   {
      
      private static const DECREASE:Number = 0.12;
       
      
      private var _disposed:Boolean;
      
      private var soundMap:com.qb9.gaturro.manager.music.MusicSoundMap;
      
      private var motor:MovieClip;
      
      private var currentSound:String;
      
      private var currentGain:Number = 1;
      
      public function MusicSoundPlayer(param1:com.qb9.gaturro.manager.music.MusicSoundMap)
      {
         super();
         this.soundMap = param1;
         this.setup();
      }
      
      public function stop(param1:String) : void
      {
         this.currentSound = this.soundMap.getSound(param1);
         this.currentGain -= DECREASE;
         this.motor.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.motor.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function play(param1:String) : void
      {
         this.currentGain = 1;
         this.motor.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         var _loc2_:String = this.soundMap.getSound(param1);
         audio.gain(_loc2_,this.currentGain);
         audio.play(_loc2_);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         audio.gain(this.currentSound,this.currentGain);
         if(this.currentGain <= 0.01)
         {
            this.motor.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            audio.stop(this.currentSound);
            this.currentGain = 1;
            audio.gain(this.currentSound,this.currentGain);
            this.currentSound = null;
         }
         this.currentGain -= DECREASE;
      }
      
      public function stopSound(param1:String = null) : void
      {
         this.stop(param1);
      }
      
      private function setup() : void
      {
         var _loc2_:String = null;
         var _loc3_:LoadFile = null;
         var _loc1_:IIterator = this.soundMap.iterator;
         while(_loc1_.next())
         {
            _loc2_ = _loc1_.current() as String;
            _loc3_ = audio.register(_loc2_,null,true);
            _loc3_.start();
         }
         this.motor = new MovieClip();
      }
      
      public function dispose() : void
      {
         audio.stop(this.currentSound);
         this.soundMap = null;
         this.motor.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.motor = null;
         this._disposed = true;
      }
   }
}
