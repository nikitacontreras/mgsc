package com.qb9.gaturro.view.gui.iphone2.screens.podometro
{
   import assets.PodometroMainMC;
   import com.qb9.gaturro.globals.audio;
   import com.qb9.gaturro.user.cellPhone.apps.AppPodometro;
   import com.qb9.gaturro.view.gui.iphone2.CellPhoneButton;
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import com.qb9.gaturro.view.gui.iphone2.screens.BaseIPhone2Screen;
   import com.qb9.gaturro.view.gui.iphone2.screens.IPhone2Screens;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class PodometroMainScreen extends BaseIPhone2Screen
   {
       
      
      private var _botonDetener:CellPhoneButton;
      
      private const BUTTON_SOUND:String = "celu1";
      
      private var _fieldPasos:TextField;
      
      private var _botonReset:CellPhoneButton;
      
      private var _botonIniciar:CellPhoneButton;
      
      public function PodometroMainScreen(param1:IPhone2Modal, param2:MovieClip, param3:Object)
      {
         super(param1,param2,{});
      }
      
      private function checkButtons() : void
      {
         if(AppPodometro.running)
         {
            this._botonDetener.visible = true;
            this._botonIniciar.visible = false;
         }
         else
         {
            this._botonDetener.visible = false;
            this._botonIniciar.visible = true;
         }
         if(AppPodometro.steps > 0)
         {
            this._botonReset.visible = true;
         }
         else
         {
            this._botonReset.visible = false;
         }
      }
      
      override protected function whenAdded() : void
      {
         super.whenAdded();
         this._fieldPasos = PodometroMainMC(asset).tf_pasos;
         this._botonIniciar = new CellPhoneButton(PodometroMainMC(asset).btn_iniciar,this.iniciarPodometro);
         this._botonDetener = new CellPhoneButton(PodometroMainMC(asset).btn_detener,this.detenerPodometro);
         this._botonReset = new CellPhoneButton(PodometroMainMC(asset).btn_reiniciar,this.resetPodometro);
         this._fieldPasos.text = String(AppPodometro.steps);
         audio.register(this.BUTTON_SOUND).start();
         this.checkButtons();
      }
      
      private function resetPodometro(param1:MouseEvent) : void
      {
         audio.play(this.BUTTON_SOUND);
         AppPodometro.steps = 0;
         this._fieldPasos.text = String(AppPodometro.steps);
         this.checkButtons();
      }
      
      private function detenerPodometro(param1:MouseEvent) : void
      {
         audio.play(this.BUTTON_SOUND);
         AppPodometro.running = false;
         this.checkButtons();
      }
      
      override protected function backButton() : void
      {
         back(IPhone2Screens.MENU);
      }
      
      private function iniciarPodometro(param1:MouseEvent) : void
      {
         audio.play(this.BUTTON_SOUND);
         AppPodometro.running = true;
         this.checkButtons();
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
