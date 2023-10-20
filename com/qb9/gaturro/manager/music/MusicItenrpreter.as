package com.qb9.gaturro.manager.music
{
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.iterator.Iterator;
   import com.qb9.gaturro.manager.music.enum.MusicNoteEnum;
   import com.qb9.gaturro.manager.music.enum.MusicRhythmicEnum;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class MusicItenrpreter implements ICheckableDisposable
   {
       
      
      private var _disposed:Boolean;
      
      private var timer:Timer;
      
      private var sequenceIterator:IIterator;
      
      private var currentSoundPlayer:com.qb9.gaturro.manager.music.MusicSoundPlayer;
      
      private var durationCountdown:int;
      
      private var completeCallback:Function;
      
      public function MusicItenrpreter()
      {
         super();
         this.setupTimer();
      }
      
      private function setupTimer() : void
      {
         this.timer = new Timer(MusicRhythmicEnum.DELAY,MusicRhythmicEnum.TOTAL);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onComplete);
      }
      
      public function start(param1:Array, param2:com.qb9.gaturro.manager.music.MusicSoundPlayer, param3:Function = null) : void
      {
         this.completeCallback = param3;
         this.sequenceIterator = new Iterator();
         this.sequenceIterator.setupIterable(param1);
         this.currentSoundPlayer = param2;
         this.durationCountdown = 1;
         this.timer.stop();
         this.timer.reset();
         this.timer.start();
      }
      
      public function stop() : void
      {
         this.timer.stop();
         if(this.sequenceIterator)
         {
            this.sequenceIterator.dispose();
         }
         this.sequenceIterator = null;
         this.completeCallback = null;
         this.currentSoundPlayer = null;
         this.durationCountdown = 0;
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         var _loc2_:MusicNote = null;
         if(this.durationCountdown <= 1)
         {
            if(this.sequenceIterator.current())
            {
               _loc2_ = this.sequenceIterator.current() as MusicNote;
               if(_loc2_.note != MusicNoteEnum.SILENCIO)
               {
                  this.currentSoundPlayer.stop(_loc2_.note);
               }
            }
            if(this.sequenceIterator.next())
            {
               _loc2_ = this.sequenceIterator.current() as MusicNote;
               this.durationCountdown = _loc2_.rhythmic;
               if(_loc2_.note != MusicNoteEnum.SILENCIO)
               {
                  this.currentSoundPlayer.play(_loc2_.note);
               }
            }
            else
            {
               this.timer.dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
               this.timer.stop();
            }
         }
         else
         {
            --this.durationCountdown;
         }
      }
      
      private function onComplete(param1:TimerEvent) : void
      {
         if(this.completeCallback != null)
         {
            this.completeCallback();
         }
      }
      
      public function dispose() : void
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onComplete);
         this.timer = null;
         this.sequenceIterator.dispose();
         this.sequenceIterator = null;
         this._disposed = true;
      }
   }
}
