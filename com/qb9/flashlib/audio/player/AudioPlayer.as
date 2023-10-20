package com.qb9.flashlib.audio.player
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.net.LoadFile;
   import com.qb9.flashlib.net.LoadFileFormat;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   
   public class AudioPlayer implements IDisposable
   {
       
      
      private var crop:Number;
      
      private var base:String;
      
      private var master:Number = 1;
      
      private var data:Object;
      
      public function AudioPlayer(param1:String = "", param2:Number = 60)
      {
         this.data = {};
         super();
         this.base = param1;
         this.crop = param2;
      }
      
      public function stop(param1:String = null) : void
      {
         if(param1 === null)
         {
            for(param1 in this.data)
            {
               this.stop(param1);
            }
            return;
         }
         if(!this.isRunning(param1))
         {
            return;
         }
         this.getChannel(param1).removeEventListener(Event.SOUND_COMPLETE,this.soundComplete);
         this.getChannel(param1).stop();
         this.getData(param1).channel = null;
      }
      
      public function registerFile(param1:LoadFile, param2:Boolean = false, param3:String = null) : LoadFile
      {
         param3 ||= param1.id;
         if(this.getData(param3))
         {
            this.disposeSound(param3);
         }
         this.data[param3] = new AudioData(param1,param2);
         return param1;
      }
      
      public function getChannel(param1:String) : SoundChannel
      {
         return this.getData(param1).channel;
      }
      
      public function makeTask(param1:String, param2:Boolean = false) : AudioTask
      {
         var _loc3_:AudioTask = new AudioTask(this.getSound(param1),this.crop,param2);
         _loc3_.volume = this.getVolume(param1);
         _loc3_.pan = this.getData(param1).pan;
         return _loc3_;
      }
      
      protected function getVolume(param1:String) : Number
      {
         return this.getData(param1).gain * this.master;
      }
      
      public function getSound(param1:String) : Sound
      {
         return this.getData(param1).sound;
      }
      
      public function has(param1:String) : Boolean
      {
         return this.getData(param1) !== null;
      }
      
      public function get masterVolume() : Number
      {
         return this.master;
      }
      
      public function pan(param1:String, param2:Number) : void
      {
         this.getData(param1).pan = param2;
         this.updateRunningChannel(param1);
      }
      
      private function makeTransform(param1:String) : SoundTransform
      {
         return new SoundTransform(this.getVolume(param1),this.getData(param1).pan);
      }
      
      public function dispose() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in this.data)
         {
            this.disposeSound(_loc1_);
         }
         this.data = {};
      }
      
      protected function makeURL(param1:String) : String
      {
         return this.base + param1 + ".mp3";
      }
      
      public function register(param1:String, param2:String = null, param3:Boolean = false) : LoadFile
      {
         return this.registerFile(new LoadFile(this.makeURL(param2 || param1),LoadFileFormat.SOUND,param1),param3);
      }
      
      public function loop(param1:String, param2:int = 2147483647) : void
      {
         if(this.isRunning(param1))
         {
            if(!this.getData(param1).multiChannel)
            {
               return;
            }
            this.getChannel(param1).removeEventListener(Event.SOUND_COMPLETE,this.soundComplete);
         }
         var _loc3_:AudioData = this.getData(param1);
         _loc3_.channel = this.getSound(param1).play(this.crop,param2,this.makeTransform(param1));
         var _loc4_:SoundChannel;
         if(_loc4_ = this.getChannel(param1))
         {
            _loc4_.addEventListener(Event.SOUND_COMPLETE,this.soundComplete);
         }
      }
      
      private function getData(param1:String) : AudioData
      {
         return this.data[param1] as AudioData;
      }
      
      private function soundComplete(param1:Event) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in this.data)
         {
            if(this.getChannel(_loc2_) === param1.target)
            {
               this.stop(_loc2_);
            }
         }
      }
      
      private function updateRunningChannel(param1:String) : void
      {
         if(this.isRunning(param1))
         {
            this.getChannel(param1).soundTransform = this.makeTransform(param1);
         }
      }
      
      public function disposeSound(param1:String) : void
      {
         this.stop(param1);
         this.getData(param1).dispose();
         delete this.data[param1];
      }
      
      public function getFile(param1:String) : LoadFile
      {
         return this.getData(param1).file;
      }
      
      public function play(param1:String) : void
      {
         this.loop(param1,1);
      }
      
      public function isRunning(param1:String) : Boolean
      {
         return Boolean(this.getData(param1)) && this.getChannel(param1) !== null;
      }
      
      public function set masterVolume(param1:Number) : void
      {
         var _loc2_:String = null;
         this.master = param1;
         for(_loc2_ in this.data)
         {
            this.updateRunningChannel(_loc2_);
         }
      }
      
      public function gain(param1:String, param2:Number) : void
      {
         this.getData(param1).gain = param2;
         this.updateRunningChannel(param1);
      }
   }
}

import com.qb9.flashlib.net.LoadFile;
import flash.media.Sound;
import flash.media.SoundChannel;

class AudioData
{
    
   
   private var channel:SoundChannel;
   
   private var multiChannel:Boolean;
   
   private var file:LoadFile;
   
   private var pan:Number = 0;
   
   private var gain:Number = 1;
   
   public function AudioData(param1:LoadFile, param2:Boolean)
   {
      super();
      this.file = param1;
      this.multiChannel = param2;
   }
   
   public function dispose() : void
   {
      this.file.dispose();
      this.file = null;
      this.channel = null;
   }
   
   public function get sound() : Sound
   {
      return this.file.data as Sound;
   }
}
