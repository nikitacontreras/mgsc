package com.qb9.flashlib.audio.player
{
   import com.qb9.flashlib.events.QEventDispatcher;
   import com.qb9.flashlib.tasks.ITask;
   import com.qb9.flashlib.tasks.TaskEvent;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   
   public class AudioTask extends QEventDispatcher implements ITask
   {
       
      
      private var channel:SoundChannel;
      
      private var sound:Sound;
      
      private var loop:Boolean;
      
      private var lastPos:Number;
      
      private var transform:SoundTransform;
      
      public function AudioTask(param1:Sound, param2:Number = 60, param3:Boolean = false)
      {
         this.transform = new SoundTransform();
         super();
         this.sound = param1;
         this.loop = param3;
         this.lastPos = param2;
      }
      
      public function stop() : void
      {
         if(!this.running)
         {
            return;
         }
         this.lastPos = this.channel.position;
         this.channel.removeEventListener(Event.SOUND_COMPLETE,this.onComplete);
         this.channel.stop();
         this.channel = null;
      }
      
      private function onComplete(param1:Event) : void
      {
         dispatchEvent(new TaskEvent(TaskEvent.COMPLETE));
      }
      
      public function get running() : Boolean
      {
         return this.channel !== null;
      }
      
      public function update(param1:uint) : void
      {
      }
      
      public function get volume() : Number
      {
         return this.transform.volume;
      }
      
      public function get pan() : Number
      {
         return this.transform.pan;
      }
      
      override public function dispose() : void
      {
         this.stop();
         this.sound = null;
         this.transform = null;
         super.dispose();
      }
      
      public function start() : void
      {
         if(this.running)
         {
            return;
         }
         this.channel = this.sound.play(this.lastPos,this.loop ? int.MAX_VALUE : 0,this.transform);
         if(this.channel)
         {
            this.channel.addEventListener(Event.SOUND_COMPLETE,this.onComplete);
         }
      }
      
      public function set volume(param1:Number) : void
      {
         if(!this.transform)
         {
            return;
         }
         this.transform.volume = param1;
         if(this.channel)
         {
            this.channel.soundTransform = this.transform;
         }
      }
      
      public function clone() : ITask
      {
         var _loc1_:AudioTask = new AudioTask(this.sound);
         _loc1_.volume = this.volume;
         return _loc1_;
      }
      
      public function set elapsed(param1:uint) : void
      {
         var _loc2_:Boolean = this.running;
         this.stop();
         this.lastPos = param1;
         if(_loc2_)
         {
            this.start();
         }
      }
      
      public function set pan(param1:Number) : void
      {
         this.transform.pan = param1;
         if(this.channel)
         {
            this.channel.soundTransform = this.transform;
         }
      }
      
      public function get elapsed() : uint
      {
         return this.running ? uint(this.channel.position) : uint(this.lastPos);
      }
   }
}
