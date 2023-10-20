package com.qb9.gaturro.view.gui.iphone2.screens.bola8
{
   import assets.Bola8MainMC;
   import com.qb9.flashlib.math.Random;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.audio;
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import com.qb9.gaturro.view.gui.iphone2.screens.BaseIPhone2Screen;
   import com.qb9.gaturro.view.gui.iphone2.screens.IPhone2Screens;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class Bola8MainScreen extends BaseIPhone2Screen
   {
       
      
      private var _bolaAnimation:MovieClip;
      
      private var _outputMessage:TextField;
      
      private var screen:Bola8MainMC;
      
      private var _answers:Array;
      
      public function Bola8MainScreen(param1:IPhone2Modal, param2:MovieClip, param3:Object)
      {
         this._answers = api.config.iphone.bola8Answers;
         super(param1,param2,{});
      }
      
      private function startBola(param1:MouseEvent) : void
      {
         this._bolaAnimation.removeEventListener(MouseEvent.CLICK,this.startBola);
         this.screen.subtitle.visible = false;
         this.screen.helpText.visible = false;
         this._bolaAnimation.gotoAndPlay("inicio");
         this._bolaAnimation.addEventListener(Event.COMPLETE,this.onComplete);
         audio.addLazyPlay("cosas2");
      }
      
      private function removeHelp(param1:MouseEvent) : void
      {
         this.screen.removeEventListener(MouseEvent.CLICK,this.removeHelp);
         this.startBola(new MouseEvent(MouseEvent.CLICK));
         this._bolaAnimation.addEventListener(MouseEvent.CLICK,this.startBola);
      }
      
      override protected function whenAdded() : void
      {
         super.whenAdded();
         this._bolaAnimation = Bola8MainMC(asset).bola8_animation;
         this._bolaAnimation.gotoAndStop("inicio");
         this._outputMessage = this._bolaAnimation.tf_outputMess.tf_outputMess;
         this.screen = Bola8MainMC(asset);
         this.screen.addEventListener(MouseEvent.CLICK,this.removeHelp);
         this._bolaAnimation.buttonMode = true;
      }
      
      private function resetBola(param1:MouseEvent) : void
      {
         this._bolaAnimation.removeEventListener(MouseEvent.CLICK,this.resetBola);
         this._outputMessage.text = "";
         this._bolaAnimation.gotoAndPlay("back");
         this._bolaAnimation.addEventListener(Event.COMPLETE,this.onComplete);
         audio.addLazyPlay("traje");
      }
      
      private function getAnswer() : String
      {
         var _loc1_:uint = uint(Random.randrange(0,this._answers.length));
         return api.getText(String(this._answers[_loc1_])).toUpperCase();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._bolaAnimation.removeEventListener(MouseEvent.CLICK,this.onComplete);
         this._bolaAnimation.removeEventListener(MouseEvent.CLICK,this.startBola);
         this._bolaAnimation.removeEventListener(MouseEvent.CLICK,this.resetBola);
      }
      
      override protected function backButton() : void
      {
         back(IPhone2Screens.MENU);
      }
      
      private function onComplete(param1:Event) : void
      {
         this._bolaAnimation.removeEventListener(Event.COMPLETE,this.onComplete);
         if(this._bolaAnimation.currentLabel == "respuesta")
         {
            this._outputMessage.text = this.getAnswer();
            this._bolaAnimation.addEventListener(MouseEvent.CLICK,this.resetBola);
            this.screen.bola8_animation.animacion.visible = true;
            audio.addLazyPlay("armado");
         }
         else if(this._bolaAnimation.currentLabel == "back")
         {
            this._bolaAnimation.addEventListener(MouseEvent.CLICK,this.startBola);
            this.screen.subtitle.visible = true;
            this.screen.helpText.visible = true;
            this.screen.bola8_animation.animacion.visible = false;
         }
         else if(this._bolaAnimation.currentLabel == "playShakeAudio")
         {
            audio.addLazyPlay("shake");
            this._bolaAnimation.addEventListener(Event.COMPLETE,this.onComplete);
         }
      }
   }
}
