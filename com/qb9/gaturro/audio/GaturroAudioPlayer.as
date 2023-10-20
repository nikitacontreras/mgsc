package com.qb9.gaturro.audio
{
   import com.qb9.flashlib.audio.player.AudioPlayer;
   import com.qb9.flashlib.audio.player.AudioTask;
   import com.qb9.flashlib.net.LoadFile;
   import com.qb9.flashlib.net.LoadFileFormat;
   import com.qb9.flashlib.tasks.Func;
   import com.qb9.flashlib.tasks.ITask;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.gaturro.net.load.GaturroLoadFile;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public final class GaturroAudioPlayer extends AudioPlayer
   {
      
      private static const SILENCE:String = "silence";
      
      private static const AMBIENCE_BASE:String = "ambience/";
      
      private static const SOUNDS_BASE:String = "sfx/";
      
      private static const SILENCE_DURATION:uint = 29000;
       
      
      private var musicTrackTask:ITask;
      
      private var musicTracks:Array;
      
      private var tasks:TaskContainer;
      
      private var ambiencePlayer:AudioTask;
      
      private var musicEnabled:Boolean;
      
      private var musicPlayer:AudioTask;
      
      private var ambienceEnabled:Boolean;
      
      private var timeoutId:int;
      
      private var lastAmbience:String;
      
      public function GaturroAudioPlayer()
      {
         this.musicTracks = [];
         super(SOUNDS_BASE,60);
         SoundMixer.soundTransform = new SoundTransform(1);
      }
      
      public function addRoomSounds(param1:String, param2:Array) : void
      {
         this.addRoomMusic(param2);
         this.addRoomAmbience(param1);
      }
      
      public function get ambience() : Boolean
      {
         return this.ambienceEnabled;
      }
      
      public function addLazyPlay(param1:String, param2:uint = 1) : void
      {
         if(!has(param1))
         {
            this.register(param1).start();
         }
         loop(param1,param2);
      }
      
      public function set music(param1:Boolean) : void
      {
         this.musicEnabled = param1;
         if(this.musicPlayer)
         {
            this.musicPlayer.volume = this.musicEnabled ? masterVolume : 0;
         }
      }
      
      private function playAmbience(param1:String) : void
      {
         this.ambiencePlayer = makeTask(param1,true);
         this.ambiencePlayer.volume = this.ambienceEnabled ? masterVolume : 0;
         this.tasks.add(this.ambiencePlayer);
      }
      
      public function setTasks(param1:TaskContainer) : void
      {
         this.tasks = param1;
      }
      
      public function pauseRoomSounds() : void
      {
         this.stopAmbience();
         this.stopTrack();
      }
      
      private function nextTrack() : void
      {
         this.musicTracks.push(this.musicTracks.shift());
         this.playTrack();
      }
      
      private function get currentTrack() : String
      {
         return this.musicTracks[0] as String;
      }
      
      override public function dispose() : void
      {
         this.stopAll();
         this.tasks = null;
         super.dispose();
      }
      
      private function stopAmbience() : void
      {
         if(this.lastAmbience)
         {
            this.ambiencePlayer.stop();
         }
         this.lastAmbience = null;
      }
      
      private function stopAll() : void
      {
         this.stopAmbience();
         this.stopTrack();
         this.musicTracks = [];
      }
      
      public function get music() : Boolean
      {
         return this.musicEnabled;
      }
      
      private function addRoomMusic(param1:Array) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         param1 = ArrayUtil.shuffle(param1);
         for each(_loc2_ in param1)
         {
            if(_loc2_ !== SILENCE)
            {
               this.ensureIsRegistered(_loc2_);
            }
         }
         _loc3_ = param1.indexOf(this.currentTrack);
         this.musicTracks = param1;
         if(_loc3_ === -1)
         {
            this.stopTrack();
            if(this.currentTrack)
            {
               this.playTrack();
            }
         }
      }
      
      public function resume() : void
      {
         while(this.musicTracks[0] as String == SILENCE)
         {
            this.musicTracks.push(this.musicTracks.shift());
         }
         this.addRoomSounds(this.musicTracks[0] as String,this.musicTracks);
      }
      
      private function stopTrack() : void
      {
         if(this.musicTrackTask)
         {
            this.tasks.remove(this.musicTrackTask);
         }
         this.musicTrackTask = null;
         clearTimeout(this.timeoutId);
      }
      
      private function ensureIsRegistered(param1:String) : void
      {
         if(!has(param1))
         {
            this.register(param1,AMBIENCE_BASE + param1).start();
            gain(param1,1);
         }
      }
      
      override public function register(param1:String, param2:String = null, param3:Boolean = false) : LoadFile
      {
         return registerFile(new GaturroLoadFile(makeURL(param2 || param1),LoadFileFormat.SOUND,param1),param3);
      }
      
      private function playTrack() : void
      {
         this.musicPlayer = null;
         if(this.currentTrack === SILENCE)
         {
            this.timeoutId = setTimeout(this.nextTrack,SILENCE_DURATION);
         }
         else
         {
            this.musicPlayer = makeTask(this.currentTrack);
            this.musicPlayer.volume = this.musicEnabled ? masterVolume : 0;
            this.musicTrackTask = new Sequence(this.musicPlayer,new Func(this.nextTrack));
            this.tasks.add(this.musicTrackTask);
         }
      }
      
      override public function set masterVolume(param1:Number) : void
      {
         var _loc2_:SoundTransform = new SoundTransform(param1);
         SoundMixer.soundTransform = _loc2_;
         super.masterVolume = param1;
         if(Boolean(this.ambiencePlayer) && this.ambienceEnabled)
         {
            this.ambiencePlayer.volume = param1;
         }
         if(Boolean(this.musicPlayer) && this.musicEnabled)
         {
            this.musicPlayer.volume = param1;
         }
      }
      
      private function addRoomAmbience(param1:String) : void
      {
         if(this.lastAmbience === param1)
         {
            return;
         }
         this.stopAmbience();
         if(param1)
         {
            this.ensureIsRegistered(param1);
            this.playAmbience(param1);
         }
         this.lastAmbience = param1;
      }
      
      public function set ambience(param1:Boolean) : void
      {
         this.ambienceEnabled = param1;
         if(this.ambiencePlayer)
         {
            this.ambiencePlayer.volume = this.ambienceEnabled ? masterVolume : 0;
         }
      }
   }
}
