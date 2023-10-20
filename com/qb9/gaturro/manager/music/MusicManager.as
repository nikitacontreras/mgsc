package com.qb9.gaturro.manager.music
{
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.manager.music.enum.MusicManagerStatusEnum;
   import com.qb9.gaturro.manager.music.enum.MusicNoteEnum;
   
   public class MusicManager implements ICheckableDisposable
   {
       
      
      private var _disposed:Boolean;
      
      private var soundMap:com.qb9.gaturro.manager.music.MusicSoundMap;
      
      private var _status:int;
      
      private var deserializer:com.qb9.gaturro.manager.music.MusicNoteSequenceDeserializer;
      
      private var onCompleteCallback:Function;
      
      private var player:com.qb9.gaturro.manager.music.MusicSoundPlayer;
      
      private var _recorder:com.qb9.gaturro.manager.music.MusicRecorder;
      
      private var metronomeCounter:int;
      
      private var interpreter:com.qb9.gaturro.manager.music.MusicItenrpreter;
      
      public function MusicManager()
      {
         super();
         this.setup();
      }
      
      public function getSoundFromMap(param1:String) : String
      {
         return this.soundMap.getSound(param1);
      }
      
      private function onPlayComplete() : void
      {
         this._status = MusicManagerStatusEnum.IDLE;
         if(this.onCompleteCallback != null)
         {
            this.onCompleteCallback();
            this.onCompleteCallback = null;
         }
      }
      
      public function playGivenSequence(param1:Array, param2:Function = null) : void
      {
         this.onCompleteCallback = param2;
         this._status = MusicManagerStatusEnum.PLAYING;
         var _loc3_:Array = this.deserializer.deserialize(param1);
         this.interpreter.start(_loc3_,this.player,this.onPlayComplete);
      }
      
      public function stopRecord() : void
      {
         this.registerRecord();
      }
      
      private function setup() : void
      {
         this.setupDeserializer();
         this.setupMusicManager();
         this.setupPlayer();
         this.setupInterpreter();
         this.setupRecorder();
         api.registerSound("piano/tick",null);
         this._status = MusicManagerStatusEnum.IDLE;
      }
      
      public function playMappedSound(param1:String) : void
      {
         this.addToRecord(param1);
         this.player.play(param1);
      }
      
      private function setupInterpreter() : void
      {
         this.interpreter = new com.qb9.gaturro.manager.music.MusicItenrpreter();
      }
      
      public function playCurrentRecordedSequence(param1:Function = null) : void
      {
         this.onCompleteCallback = param1;
         this._status = MusicManagerStatusEnum.PLAYING;
         this.recorder.register();
         var _loc2_:Array = this.recorder.sequence;
         this.interpreter.start(_loc2_,this.player,this.onPlayComplete);
      }
      
      private function metronomeDelegate() : void
      {
         ++this.metronomeCounter;
         if(this.metronomeCounter == 4)
         {
            api.stopSound("piano/tick");
            api.playSound("piano/tick");
            this.metronomeCounter = 0;
         }
      }
      
      public function startRecord(param1:Boolean = false) : void
      {
         this._status = MusicManagerStatusEnum.RECORDING;
         var _loc2_:Function = param1 ? this.metronomeDelegate : null;
         this.recorder.start(_loc2_);
      }
      
      public function registerRecord() : void
      {
         this._recorder.register();
         this._status = MusicManagerStatusEnum.IDLE;
      }
      
      public function printRecord() : void
      {
         this._recorder.endCurrent();
      }
      
      public function get recorder() : com.qb9.gaturro.manager.music.MusicRecorder
      {
         return this._recorder;
      }
      
      public function stopSequence() : void
      {
         this.onCompleteCallback = null;
         this.interpreter.stop();
      }
      
      private function setupMusicManager() : void
      {
         var _loc2_:String = null;
         this.soundMap = new com.qb9.gaturro.manager.music.MusicSoundMap();
         var _loc1_:int = 1;
         for each(_loc2_ in MusicNoteEnum.orderedSet)
         {
            if(MusicNoteEnum.SILENCIO != _loc2_)
            {
               this.soundMap.registerNote(_loc2_,"piano/piano_" + _loc1_);
               _loc1_++;
            }
         }
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function addToRecord(param1:String) : void
      {
         this._recorder.add(param1);
      }
      
      public function dispose() : void
      {
         this.interpreter.dispose();
         this.interpreter = null;
         this.soundMap = null;
         this.deserializer = null;
         this.player.dispose();
         this.player = null;
         this.onCompleteCallback = null;
         this._disposed = true;
      }
      
      private function setupRecorder() : void
      {
         this._recorder = new com.qb9.gaturro.manager.music.MusicRecorder();
      }
      
      private function setupDeserializer() : void
      {
         this.deserializer = new com.qb9.gaturro.manager.music.MusicNoteSequenceDeserializer();
      }
      
      public function get status() : int
      {
         return this._status;
      }
      
      public function getSequence() : Array
      {
         return this._recorder.sequence;
      }
      
      public function playSerializedSequence(param1:String, param2:Function = null) : void
      {
         this.onCompleteCallback = param2;
         var _loc3_:Array = param1.split("");
         this.playGivenSequence(_loc3_,param2);
      }
      
      public function stopSound(param1:String = null) : void
      {
         this.player.stopSound(param1);
      }
      
      public function getSerializedSequence() : String
      {
         var _loc1_:Array = this.recorder.sequence;
         return this.deserializer.serialize(_loc1_);
      }
      
      private function setupPlayer() : void
      {
         this.player = new com.qb9.gaturro.manager.music.MusicSoundPlayer(this.soundMap);
      }
   }
}
