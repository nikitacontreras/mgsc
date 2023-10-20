package com.qb9.gaturro.view.components.banner.piano
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.manager.music.MusicManager;
   import com.qb9.gaturro.manager.music.MusicRecorder;
   import com.qb9.gaturro.manager.music.enum.MusicRhythmicEnum;
   import com.qb9.gaturro.view.gui.banner.properties.IHasOptions;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.banner.properties.IHasSceneAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class PianoBanner extends InstantiableGuiModal implements IHasSceneAPI, IHasRoomAPI, IHasOptions
   {
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var started:Boolean;
      
      private var keySet:Dictionary;
      
      private var _musicRecorder:MusicRecorder;
      
      private var playButton:Sprite;
      
      private var _band:Boolean;
      
      private var _kickTimer:Timer;
      
      private var _readyToPlay:Boolean = false;
      
      private var pianoAsset:Sprite;
      
      private var _counter:MovieClip;
      
      private var _bandSwitchPopUp:MovieClip;
      
      private var _timer:Timer;
      
      private var musicManager:MusicManager;
      
      private var _sceneAPI:GaturroSceneObjectAPI;
      
      private var _show:Boolean;
      
      private var _progressBar:MovieClip;
      
      public function PianoBanner()
      {
         super("pianoBanner","PianoBannerAsset");
         this.setup();
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
      
      private function bandChosen(param1:MouseEvent) : void
      {
         this._bandSwitchPopUp.visible = false;
         this._counter.gotoAndPlay(0);
      }
      
      override public function dispose() : void
      {
         this.musicManager.recorder.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onFinishedRec);
         if(this._kickTimer)
         {
            this._kickTimer.stop();
            this._kickTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.kickPlayer);
         }
         super.dispose();
      }
      
      private function showBandPopUp() : void
      {
         this.view.addEventListener(Event.ENTER_FRAME,this.update);
         this._progressBar = view.getChildByName("progressBar") as MovieClip;
         this._progressBar.gotoAndStop(0);
         this._counter = view.getChildByName("counter") as MovieClip;
         this._counter.gotoAndStop(0);
         this.musicManager.recorder.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onFinishedRec);
         this._bandSwitchPopUp = view.getChildByName("bandSelectorPopUp") as MovieClip;
         this._bandSwitchPopUp.visible = true;
         this._band = false;
         this._bandSwitchPopUp.btnBandCheckBox.buttonMode = true;
         this._bandSwitchPopUp.btnBandCheckBox.addEventListener(MouseEvent.CLICK,this.turnBackTrack);
         this._bandSwitchPopUp.startPlaying.addEventListener(MouseEvent.CLICK,this.bandChosen);
      }
      
      override protected function ready() : void
      {
         var _loc1_:Sprite = null;
         super.ready();
         this.showBandPopUp();
         this.pianoAsset = view.getChildByName("piano") as Sprite;
         var _loc3_:int = 0;
         while(_loc3_ < this.pianoAsset.numChildren)
         {
            _loc1_ = this.pianoAsset.getChildAt(_loc3_) as MovieClip;
            _loc1_.mouseChildren = false;
            _loc1_.buttonMode = true;
            this.keySet[_loc1_] = _loc1_.name;
            _loc1_.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            _loc1_.addEventListener(MouseEvent.ROLL_OUT,this.onMouseUp);
            _loc1_.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            _loc3_++;
         }
      }
      
      private function turnBackTrack(param1:MouseEvent) : void
      {
         if(!this._band)
         {
            this._bandSwitchPopUp.btnBandCheckBox.switchBtn.gotoAndStop("on");
            this._band = true;
         }
         else
         {
            this._bandSwitchPopUp.btnBandCheckBox.switchBtn.gotoAndStop("off");
            this._band = false;
         }
      }
      
      private function onPlay() : void
      {
         this.musicManager.playCurrentRecordedSequence();
         if(this._band)
         {
            api.stopSound("antro2017/backtrack");
            api.playSound("antro2017/backtrack");
         }
         else
         {
            api.stopSound("antro2017/backtrack");
         }
      }
      
      public function set options(param1:String) : void
      {
         if(param1 == "show")
         {
            this._show = true;
         }
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         if(!this._readyToPlay)
         {
            return;
         }
         (param1.currentTarget as MovieClip).gotoAndStop(0);
         var _loc2_:String = String(this.keySet[param1.currentTarget]);
         _loc2_ = _loc2_.toLowerCase();
         this.musicManager.stopSound(_loc2_);
         this.musicManager.printRecord();
      }
      
      private function kickPlayer(param1:TimerEvent) : void
      {
         this._readyToPlay = false;
         this._kickTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.kickPlayer);
      }
      
      private function update(param1:Event) : void
      {
         if(this.musicManager && this.musicManager.recorder && Boolean(this.musicManager.recorder.timer))
         {
            this._progressBar.gotoAndStop(int(this.musicManager.recorder.timer.currentCount * this._progressBar.totalFrames / MusicRhythmicEnum.TOTAL));
         }
         if(this._counter && !this._readyToPlay && this._counter.totalFrames == this._counter.currentFrame)
         {
            this.timeToPlay();
         }
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         if(!this._readyToPlay)
         {
            return;
         }
         if(Boolean(this._kickTimer) && this._show)
         {
            this._kickTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.kickPlayer);
            this._kickTimer.stop();
         }
         (param1.currentTarget as MovieClip).gotoAndStop(2);
         var _loc2_:String = String(this.keySet[param1.currentTarget]);
         _loc2_ = _loc2_.toLowerCase();
         this.musicManager.playMappedSound(_loc2_);
      }
      
      private function onFinishedRec(param1:TimerEvent) : void
      {
         this.musicManager.recorder.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onFinishedRec);
         if(this._show)
         {
            this.close();
         }
         else
         {
            this.onPlay();
            this.close();
         }
      }
      
      public function set sceneAPI(param1:GaturroSceneObjectAPI) : void
      {
         this._sceneAPI = param1;
      }
      
      override public function close() : void
      {
         var _loc1_:String = null;
         var _loc2_:MovieClip = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         this.musicManager.registerRecord();
         if(this._band)
         {
            api.stopSound("antro2017/backtrack");
         }
         if(this._show)
         {
            if(this.musicManager.recorder && this.musicManager.recorder.sequence && this.musicManager.recorder.sequence.length > 30)
            {
               _loc4_ = this._band ? "0:" : "1:";
               trace("ESCRIBIENDO CANCION SOBRE EL PIANO");
               _loc5_ = this.musicManager.getSerializedSequence();
               this._sceneAPI.setAttribute("song",_loc4_ + _loc5_);
               api.trackEvent("FEATURES:LIVEMUSIC:PIANOBANNER:SONG",_loc5_);
               this._roomAPI.setAvatarAttribute("message","finished");
               if(this._band)
               {
                  api.stopSound("antro2017/backtrack");
                  api.playSound("antro2017/backtrack");
               }
               _loc1_ = "song_completed;" + "band_" + this._band.toString();
            }
            else
            {
               this._roomAPI.setAvatarAttribute("message","leaving");
               _loc1_ = "song_incompleted;" + "band_" + this._band.toString();
            }
         }
         this._bandSwitchPopUp.btnBandCheckBox.removeEventListener(MouseEvent.CLICK,this.turnBackTrack);
         this._bandSwitchPopUp.startPlaying.removeEventListener(MouseEvent.CLICK,this.bandChosen);
         if(this._show)
         {
            api.trackEvent("FEATURES:LIVEMUSIC:PIANOBANNER:SHOW",_loc1_);
         }
         else
         {
            api.trackEvent("FEATURES:LIVEMUSIC:PIANOBANNER:PRACTICE",_loc1_);
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.pianoAsset.numChildren)
         {
            _loc2_ = this.pianoAsset.getChildAt(_loc3_) as MovieClip;
            _loc2_.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            _loc2_.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseUp);
            _loc2_.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            _loc3_++;
         }
         super.close();
      }
      
      private function timeToPlay() : void
      {
         this._readyToPlay = true;
         if(this._show)
         {
            this._kickTimer = new Timer(0,MusicRhythmicEnum.KICK_IF_DONT_PLAY_PENALTY_TIME);
            this._kickTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.kickPlayer);
            this._kickTimer.start();
         }
         if(!this.started)
         {
            this.musicManager.startRecord(!this._band);
            this.started = true;
         }
         if(this._band)
         {
            api.stopSound("antro2017/backtrack");
            api.playSound("antro2017/backtrack");
         }
      }
      
      private function setup() : void
      {
         if(Context.instance.hasByType(MusicManager))
         {
            this.musicManager = Context.instance.getByType(MusicManager) as MusicManager;
         }
         else
         {
            this.musicManager = new MusicManager();
            Context.instance.addByType(this.musicManager,MusicManager);
         }
         this.keySet = new Dictionary();
      }
   }
}
