package com.qb9.gaturro.manager.music
{
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import com.qb9.gaturro.manager.music.enum.MusicNoteEnum;
   import com.qb9.gaturro.manager.music.enum.MusicRhythmicEnum;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class MusicRecorder implements ICheckableDisposable
   {
      
      private static const RECORDING:int = 1;
      
      private static const IDLE:int = 0;
       
      
      private var tickCallback:Function;
      
      private var _disposed:Boolean;
      
      private var _timer:Timer;
      
      private var rhythmicSortedList:Array;
      
      private var currentNoteLength:int = 1;
      
      private var currentNote:String;
      
      private var _sequence:Array;
      
      private var completeCallback:Function;
      
      private var status:int;
      
      public function MusicRecorder()
      {
         super();
         this.setup();
         this.status = IDLE;
         this.currentNote = MusicNoteEnum.SILENCIO;
      }
      
      public function get sequence() : Array
      {
         return this._sequence;
      }
      
      public function get timer() : Timer
      {
         return this._timer;
      }
      
      private function addSilence() : void
      {
         var _loc2_:MusicNote = null;
         var _loc1_:int = this.currentNoteLength;
         while(_loc1_ > 0)
         {
            _loc2_ = new MusicNote(MusicNoteEnum.SILENCIO,MusicRhythmicEnum.SEMICORCHEA);
            this._sequence.push(_loc2_);
            _loc1_--;
         }
      }
      
      private function setupRhythmicList() : void
      {
         var _loc2_:int = 0;
         this.rhythmicSortedList = new Array();
         var _loc1_:Dictionary = MusicRhythmicEnum.map;
         for each(_loc2_ in _loc1_)
         {
            this.rhythmicSortedList.push(_loc2_);
         }
         this.rhythmicSortedList.sort(Array.NUMERIC);
      }
      
      public function endCurrent() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MusicNote = null;
         if(this.currentNote == MusicNoteEnum.SILENCIO)
         {
            this.addSilence();
         }
         else
         {
            _loc1_ = this.getRhythmic();
            if(_loc1_ <= 0)
            {
               _loc1_ = 1;
            }
            _loc2_ = new MusicNote(this.currentNote,_loc1_);
            this._sequence.push(_loc2_);
         }
         this.currentNote = MusicNoteEnum.SILENCIO;
         this.currentNoteLength = 0;
      }
      
      public function add(param1:String) : void
      {
         if(this.status == IDLE)
         {
            throw new Error("Can\'t add note to the system when this is on idle status.");
         }
         if(!param1)
         {
            throw new Error("Can\'t provide a null note");
         }
         if(this._sequence.length >= 255)
         {
            throw new Error("The given note exceeds the limit and couldn\'t adds");
         }
         if(this.currentNote == MusicNoteEnum.SILENCIO && this.currentNoteLength >= 1)
         {
            this.addSilence();
         }
         if(MusicNoteEnum.map[param1])
         {
            this.currentNote = param1;
            this.currentNoteLength = 1;
            return;
         }
         throw new Error("Is an invalid note --> " + param1);
      }
      
      public function register() : void
      {
         this._timer.stop();
         this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.status = IDLE;
         if(this.completeCallback != null)
         {
            this.completeCallback();
         }
      }
      
      public function dispose() : void
      {
         this._timer.stop();
         this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this._timer = null;
         this.status = IDLE;
         this._disposed = true;
      }
      
      public function start(param1:Function = null, param2:Function = null) : void
      {
         this.completeCallback = param2;
         this.tickCallback = param1;
         this._sequence = new Array();
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onComplete);
         this._timer.stop();
         this._timer.reset();
         this._timer.start();
         this.status = RECORDING;
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         if(this.tickCallback != null)
         {
            this.tickCallback();
         }
         ++this.currentNoteLength;
         if(this.currentNoteLength >= MusicRhythmicEnum.REDONDA)
         {
            this.currentNoteLength = MusicRhythmicEnum.REDONDA;
            this.endCurrent();
         }
      }
      
      private function getRhythmic() : int
      {
         var _loc3_:int = 0;
         var _loc1_:int = -1;
         var _loc2_:int = 0;
         while(_loc2_ < this.rhythmicSortedList.length)
         {
            _loc3_ = int(this.rhythmicSortedList[_loc2_]);
            if(this.currentNoteLength <= _loc3_)
            {
               if(_loc3_ == this.currentNoteLength)
               {
                  _loc1_ = this.currentNoteLength;
                  break;
               }
               if(this.currentNoteLength < _loc3_)
               {
                  _loc1_ = int(this.rhythmicSortedList[_loc2_ - 1]);
                  break;
               }
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function onComplete(param1:TimerEvent) : void
      {
         this.register();
      }
      
      private function setup() : void
      {
         this._timer = new Timer(MusicRhythmicEnum.DELAY,MusicRhythmicEnum.TOTAL);
         this.setupRhythmicList();
      }
   }
}
