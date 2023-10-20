package com.qb9.gaturro.view.gui.iphone2.screens.alarmclock
{
   import assets.AlarmClockMainMC;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.audio;
   import com.qb9.gaturro.user.cellPhone.CellPhoneEvent;
   import com.qb9.gaturro.view.gui.iphone2.CellPhoneButton;
   import com.qb9.gaturro.view.gui.iphone2.GuiIPhone2Button;
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import com.qb9.gaturro.view.gui.iphone2.screens.BaseIPhone2Screen;
   import com.qb9.gaturro.view.gui.iphone2.screens.IPhone2Screens;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class AlarmClockMainScreen extends BaseIPhone2Screen
   {
      
      private static var alarm:Boolean;
      
      private static var celButton:GuiIPhone2Button;
      
      private static var alarmDate:Date;
       
      
      private var _btnAlarmSwitch:CellPhoneButton;
      
      private var _timeBuffer:Number;
      
      private var _date:Date;
      
      private var _minFieldMini:TextField;
      
      private var _actualTime:Number;
      
      private const BUTTON_SOUND:String = "celu1";
      
      private var _minField:TextField;
      
      private const ALARM_AUDIO_FILE:String = "celuSend";
      
      private var _minUPButton:CellPhoneButton;
      
      private var _hsDwnButton:CellPhoneButton;
      
      private var _timeCount:Number;
      
      private var _alarmAnimation:MovieClip;
      
      private var _alarmLed:MovieClip;
      
      private var _hsFieldMini:TextField;
      
      private var _hsField:TextField;
      
      private var _timeDisplay:MovieClip;
      
      private var _hsUpButton:CellPhoneButton;
      
      private var _minDwnButton:CellPhoneButton;
      
      private var _clockTimer:Timer;
      
      public function AlarmClockMainScreen(param1:IPhone2Modal, param2:MovieClip, param3:Object, param4:GuiIPhone2Button)
      {
         super(param1,param2,{});
         celButton = param4;
      }
      
      private static function openAlarmDevice() : void
      {
         api.user.cellPhone.dispatchEvent(new CellPhoneEvent(CellPhoneEvent.TRIGGER_ALARM));
      }
      
      private function hoursUp(param1:MouseEvent) : void
      {
         alarmDate.hours = (alarmDate.hours + 1) % 24;
         this._hsField.text = String(alarmDate.hours);
      }
      
      override protected function backButton() : void
      {
         back(IPhone2Screens.MENU);
      }
      
      private function checkZeroOnMinutes() : void
      {
         if(this._minField.text.length == 1)
         {
            this._minField.text = String(0) + this._minField.text;
         }
         if(this._minFieldMini.text.length != 2)
         {
            if(this._minFieldMini.text.length == 1)
            {
               this._minFieldMini.text = "0" + this._minFieldMini.text;
            }
         }
         trace(this._minField.text,this._minFieldMini.text);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(!alarm)
         {
            this._clockTimer.stop();
            this._clockTimer.removeEventListener(TimerEvent.TIMER,this.onClockTick);
         }
         if(audio.isRunning(this.ALARM_AUDIO_FILE))
         {
            audio.stop(this.ALARM_AUDIO_FILE);
         }
         audio.disposeSound(this.ALARM_AUDIO_FILE);
         this._alarmAnimation.removeEventListener(MouseEvent.CLICK,this.stopAlarm);
      }
      
      private function minutesDown(param1:MouseEvent) : void
      {
         alarmDate.minutes = (alarmDate.minutes - 1) % 60;
         this._minField.text = String(alarmDate.minutes);
         this.checkZeroOnMinutes();
      }
      
      private function onClockTick(param1:TimerEvent) : void
      {
         this._timeCount = getTimer() - this._timeBuffer;
         this._timeBuffer = getTimer();
         this._actualTime += this._timeCount;
         this._date = new Date(this._actualTime);
         this._minFieldMini.text = String(this._date.minutes);
         this._hsFieldMini.text = String(this._date.hours);
         if(alarm && alarmDate.minutes == this._date.minutes && alarmDate.hours == this._date.hours)
         {
            if(stage == null)
            {
               this._clockTimer.stop();
               this._clockTimer.removeEventListener(TimerEvent.TIMER,this.onClockTick);
               openAlarmDevice();
            }
            else
            {
               this.triggerAlarm();
            }
         }
         this.checkZeroOnMinutes();
      }
      
      private function hoursDown(param1:MouseEvent) : void
      {
         alarmDate.hours = (alarmDate.hours - 1) % 24;
         this._hsField.text = String(alarmDate.hours);
      }
      
      private function minutesUp(param1:MouseEvent) : void
      {
         alarmDate.minutes = (alarmDate.minutes + 1) % 60;
         this._minField.text = String(alarmDate.minutes);
         this.checkZeroOnMinutes();
      }
      
      private function toggleAlarm(param1:MouseEvent) : void
      {
         alarm = !alarm;
         if(alarm)
         {
            this._alarmLed.gotoAndStop("on");
         }
         else
         {
            this._alarmLed.gotoAndStop("off");
         }
      }
      
      override protected function whenAdded() : void
      {
         super.whenAdded();
         audio.register(this.ALARM_AUDIO_FILE).start();
         this._minField = AlarmClockMainMC(asset).min;
         this._minField.autoSize = TextFieldAutoSize.LEFT;
         this._minUPButton = new CellPhoneButton(AlarmClockMainMC(asset).min_up,this.minutesUp,this.BUTTON_SOUND);
         this._minDwnButton = new CellPhoneButton(AlarmClockMainMC(asset).min_dwn,this.minutesDown,this.BUTTON_SOUND);
         this._hsUpButton = new CellPhoneButton(AlarmClockMainMC(asset).hs_up,this.hoursUp,this.BUTTON_SOUND);
         this._hsDwnButton = new CellPhoneButton(AlarmClockMainMC(asset).hs_dwn,this.hoursDown,this.BUTTON_SOUND);
         this._hsField = AlarmClockMainMC(asset).hs;
         this._hsField.autoSize = TextFieldAutoSize.RIGHT;
         this._timeDisplay = AlarmClockMainMC(asset).min_display;
         this._hsFieldMini = AlarmClockMainMC(asset).min_display.hs;
         this._minFieldMini = AlarmClockMainMC(asset).min_display.min;
         this._alarmAnimation = AlarmClockMainMC(asset).alarm_anim;
         this._alarmLed = AlarmClockMainMC(asset).alarm_led;
         this._btnAlarmSwitch = new CellPhoneButton(AlarmClockMainMC(asset).btn_alarm,this.toggleAlarm,"celu1");
         this._timeBuffer = getTimer();
         this._actualTime = api.serverTime;
         this._date = new Date(this._actualTime);
         this._clockTimer = new Timer(1000,0);
         this._clockTimer.addEventListener(TimerEvent.TIMER,this.onClockTick);
         this._clockTimer.start();
         this._alarmAnimation.visible = false;
         this._alarmAnimation.stop();
         this._alarmAnimation.addEventListener(MouseEvent.CLICK,this.stopAlarm);
         this._alarmAnimation.buttonMode = true;
         if(alarmDate == null)
         {
            alarmDate = new Date(this._actualTime);
         }
         this._minField.text = String(alarmDate.minutes);
         this._hsField.text = String(alarmDate.hours);
         this.checkZeroOnMinutes();
      }
      
      private function stopAlarm(param1:MouseEvent) : void
      {
         this._alarmAnimation.gotoAndStop(1);
         this._alarmAnimation.visible = false;
         audio.stop(this.ALARM_AUDIO_FILE);
      }
      
      private function triggerAlarm() : void
      {
         this._alarmAnimation.visible = true;
         alarm = false;
         this._alarmLed.gotoAndStop("off");
         this._alarmAnimation.play();
         audio.loop(this.ALARM_AUDIO_FILE,50);
      }
   }
}
