package com.qb9.gaturro.view.gui.report
{
   import assets.AbuseScreenMC;
   import com.qb9.flashlib.lang.foreach;
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.globals.*;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.net.requests.report.ReportIdeaActionRequest;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.gui.base.components.DropDown;
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.net.requests.report.ReportAbuseActionRequest;
   import com.qb9.mambo.net.requests.report.ReportErrorActionRequest;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   
   public final class ReportModal extends BaseGuiModal
   {
      
      private static const START:uint = 1;
      
      private static const EMPTY_FIELD:String = region.key("empty_abuse_report").toUpperCase();
      
      private static const END_PROBLEM:uint = 5;
      
      private static const REPORT_ABUSE_2:uint = 9;
      
      private static const CONFIRM_2:uint = 8;
      
      private static const REPORT_ABUSE:uint = 2;
      
      private static const REPORT_ERROR:uint = 3;
      
      private static const CONFIRM:uint = 7;
      
      private static const REPORT_IDEA:uint = 4;
      
      private static const EMPTY_USER:String = region.getText("¿QUIÉN?");
      
      private static const INTRO_FIELD:String = region.key("intro_abuse_report").toUpperCase();
      
      private static const SELECT_USER:String = region.getText("SELECCIONAR USUARIO...");
      
      private static const CONFIRM_LABEL:String = "confirmation";
      
      private static const END_IDEA:uint = 6;
       
      
      private var abuseCause:String;
      
      private var dropdown:DropDown;
      
      private var MSG_LENGUAJE_INAPROPIADO:String;
      
      private var minCharacters:int = 40;
      
      private var net:NetworkManager;
      
      private var MSG_MAL_COMPORTAMIENTO:String;
      
      private var usernames:Array;
      
      private var asset:AbuseScreenMC;
      
      public function ReportModal(param1:NetworkManager, param2:Array)
      {
         this.MSG_LENGUAJE_INAPROPIADO = region.getText("LENGUAJE INAPROPIADO");
         this.MSG_MAL_COMPORTAMIENTO = region.getText("MAL COMPORTAMIENTO");
         super();
         this.net = param1;
         this.usernames = param2.sort();
         this.init();
      }
      
      private function handleClicks(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         while(Boolean(_loc2_) && _loc2_ !== this)
         {
            if(_loc2_.name)
            {
               this.handleButton(_loc2_.name);
            }
            _loc2_ = _loc2_.parent;
         }
      }
      
      private function ensureDropdownIsClosed() : void
      {
         if(this.dropdown)
         {
            this.dropdown.dispose();
         }
      }
      
      private function get submitEnabled() : Boolean
      {
         if(this.state === REPORT_ABUSE_2)
         {
            return this.asset.inputFieldMC.inputField.text != EMPTY_FIELD && StringUtil.trim(this.asset.inputFieldMC.inputField.text) != "";
         }
         return true;
      }
      
      override public function dispose() : void
      {
         this.ensureDropdownIsClosed();
         removeEventListener(MouseEvent.CLICK,this.handleClicks);
         this.disposeAbuse();
         this.dropdown = null;
         this.net = null;
         this.asset = null;
         this.usernames = null;
         super.dispose();
      }
      
      private function onInputUserUnfocused(param1:FocusEvent) : void
      {
         if(StringUtil.trim(this.asset.inputUserMC.inputField.text) == "")
         {
            this.asset.inputUserMC.inputField.text = EMPTY_FIELD;
         }
      }
      
      private function init() : void
      {
         this.asset = new AbuseScreenMC();
         addChild(this.asset);
         addEventListener(MouseEvent.CLICK,this.handleClicks);
         with(this.asset)
         {
            region.setText(title.text,"¡HOLA!");
            region.setText(field.text,INTRO_FIELD);
            region.setText(option1.field,"ME MOLESTARON");
            region.setText(send.text,"ENVIAR");
            limitedCharacters.field.text = region.getText("*USAR POR LO MENOS") + " " + String(minCharacters) + " " + region.getText("LETRAS");
            limitedCharacters.mouseEnabled = false;
            limitedCharacters.mouseChildren = false;
         }
      }
      
      private function handleButton(param1:String) : void
      {
         loop0:
         switch(param1)
         {
            case "option1":
               switch(this.state)
               {
                  case CONFIRM:
                     this.goto(CONFIRM_2);
                     this.setupConfirm_2Buttons();
                     break loop0;
                  case CONFIRM_2:
                     this.goto(REPORT_ABUSE);
                     this.setupReportAbuse();
                     this.setupAbuseButtons();
                     break loop0;
                  case REPORT_ABUSE:
                     this.goto(REPORT_ABUSE_2);
                     this.abuseCause = this.MSG_LENGUAJE_INAPROPIADO;
                     this.setupReportAbuse_2();
                     break loop0;
                  default:
                     this.goto(CONFIRM);
                     this.setupConfirmButtons();
               }
               break;
            case "option2":
               if(this.state == CONFIRM)
               {
                  close();
                  break;
               }
               if(this.state == REPORT_ABUSE)
               {
                  this.goto(REPORT_ABUSE_2);
                  this.abuseCause = this.MSG_MAL_COMPORTAMIENTO;
                  this.setupReportAbuse_2();
                  break;
               }
               this.goto(REPORT_ERROR);
               break;
            case "option3":
               this.goto(REPORT_IDEA);
               break;
            case "send":
               if(this.submitEnabled)
               {
                  this.submit();
                  break;
               }
               break;
            case "close":
            case "cancel":
               close();
         }
      }
      
      private function submit() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(this.asset.inputFieldMC.inputField.text.length < 40)
         {
            return;
         }
         var _loc1_:String = String(this.asset.inputFieldMC.inputField.text);
         if(!_loc1_)
         {
            return;
         }
         this.ensureDropdownIsClosed();
         switch(this.state)
         {
            case REPORT_ABUSE_2:
               _loc3_ = String(this.asset.inputUserMC.inputField.text);
               this.disposeAbuse();
               _loc1_ = this.abuseCause.concat(": ",_loc1_);
               this.net.sendAction(new ReportAbuseActionRequest(_loc1_,_loc3_));
               _loc2_ = TrackActions.REPORT_ABUSE;
               this.goto(END_PROBLEM);
               break;
            case REPORT_ERROR:
               this.net.sendAction(new ReportErrorActionRequest(_loc1_,"Error",logs.joined()));
               _loc2_ = TrackActions.REPORT_ERROR;
               this.goto(END_PROBLEM);
               break;
            case REPORT_IDEA:
               this.net.sendAction(new ReportIdeaActionRequest(_loc1_,logs.joined()));
               _loc2_ = TrackActions.REPORT_IDEA;
               this.goto(END_IDEA);
         }
         if(_loc2_)
         {
            tracker.event(TrackCategories.MMO,_loc2_);
         }
      }
      
      private function onInputUserFocused(param1:FocusEvent) : void
      {
         if(this.asset.inputUserMC.inputField.text == EMPTY_USER)
         {
            this.asset.inputUserMC.inputField.text = "";
         }
      }
      
      override protected function keyboardSubmit() : void
      {
         if(this.submitEnabled)
         {
            this.submit();
         }
      }
      
      private function goto(param1:uint) : void
      {
         this.asset.gotoAndStop(param1 == CONFIRM ? CONFIRM_LABEL : "state" + param1);
         audio.addLazyPlay("click");
      }
      
      private function onInputUserChange(param1:Event) : void
      {
         this.asset.option1.enabled = this.submitEnabled;
         this.asset.option1.mouseEnabled = this.submitEnabled;
         this.asset.option1.mouseChildren = this.submitEnabled;
         this.asset.option2.enabled = this.submitEnabled;
         this.asset.option2.mouseEnabled = this.submitEnabled;
         this.asset.option2.mouseChildren = this.submitEnabled;
      }
      
      private function disposeAbuse() : void
      {
         if(this.asset.inputFieldMC)
         {
            this.asset.inputFieldMC.inputField.removeEventListener(FocusEvent.FOCUS_IN,this.onInputFieldFocused);
            this.asset.inputFieldMC.inputField.removeEventListener(FocusEvent.FOCUS_OUT,this.onInputFieldUnfocused);
            this.asset.inputFieldMC.inputField.removeEventListener(Event.CHANGE,this.onInputFieldChange);
         }
         if(this.asset.inputUserMC)
         {
            this.asset.inputUserMC.inputField.removeEventListener(FocusEvent.FOCUS_IN,this.onInputUserFocused);
            this.asset.inputUserMC.inputField.removeEventListener(FocusEvent.FOCUS_OUT,this.onInputUserUnfocused);
            this.asset.inputUserMC.inputField.removeEventListener(Event.CHANGE,this.onInputUserChange);
         }
         if(this.dropdown)
         {
            this.dropdown.removeEventListener(Event.CHANGE,this.onInputUserChange);
         }
      }
      
      private function setupReportAbuse_2() : void
      {
         this.hide(this.asset.inputUserMC);
         this.asset.send.enabled = false;
         this.asset.send.mouseEnabled = false;
         this.asset.send.mouseChildren = false;
         this.asset.inputFieldMC.inputField.addEventListener(FocusEvent.FOCUS_IN,this.onInputFieldFocused);
         this.asset.inputFieldMC.inputField.addEventListener(FocusEvent.FOCUS_OUT,this.onInputFieldUnfocused);
         this.asset.inputFieldMC.inputField.addEventListener(Event.CHANGE,this.onInputFieldChange);
         this.asset.inputFieldMC.inputField.text = EMPTY_FIELD;
      }
      
      private function get state() : uint
      {
         if(this.asset.currentLabel == CONFIRM_LABEL)
         {
            return CONFIRM;
         }
         return parseInt(this.asset.currentLabel.slice(-1));
      }
      
      protected function onUserDropDownChange(param1:Event) : void
      {
         this.asset.inputUserMC.inputField.text = param1.currentTarget.selectedLabel;
         this.onInputUserChange(param1);
      }
      
      private function addCombo() : void
      {
         this.dropdown = new DropDown();
         this.dropdown.width = 200;
         this.dropdown.prompt = SELECT_USER;
         foreach(this.usernames,this.dropdown.add);
         this.asset.ph.addChild(this.dropdown);
      }
      
      private function onInputFieldChange(param1:Event) : void
      {
         this.asset.send.enabled = this.submitEnabled;
         this.asset.send.mouseEnabled = this.submitEnabled;
         this.asset.send.mouseChildren = this.submitEnabled;
      }
      
      private function hide(param1:MovieClip) : void
      {
         param1.alpha = 0;
         param1.enabled = false;
         param1.visible = false;
         param1.mouseChildren = false;
         param1.mouseEnabled = false;
      }
      
      private function setupConfirm_2Buttons() : void
      {
         region.setText(this.asset.option1.field,"ENVIAR REPORTE");
         region.setText(this.asset.option2.field,"CANCELAR");
         region.setText(this.asset.title2.text,"¡ENTRE TODOS HAGAMOS UN MUNDO GATURRO MEJOR!");
         this.asset.field.text.text = region.key("abuse_report_confirm_text_2").toUpperCase();
      }
      
      private function setupReportAbuse() : void
      {
         this.addCombo();
         this.asset.option1.enabled = false;
         this.asset.option1.mouseEnabled = false;
         this.asset.option1.mouseChildren = false;
         this.asset.option2.enabled = false;
         this.asset.option2.mouseEnabled = false;
         this.asset.option2.mouseChildren = false;
         this.asset.inputUserMC.inputField.addEventListener(FocusEvent.FOCUS_IN,this.onInputUserFocused);
         this.asset.inputUserMC.inputField.addEventListener(FocusEvent.FOCUS_OUT,this.onInputUserUnfocused);
         this.asset.inputUserMC.inputField.addEventListener(Event.CHANGE,this.onInputUserChange);
         this.dropdown.addEventListener(Event.CHANGE,this.onUserDropDownChange);
         this.asset.inputUserMC.inputField.text = EMPTY_USER;
      }
      
      private function onInputFieldUnfocused(param1:FocusEvent) : void
      {
         if(StringUtil.trim(this.asset.inputFieldMC.inputField.text) == "")
         {
            this.asset.inputFieldMC.inputField.text = EMPTY_FIELD;
         }
      }
      
      private function onInputFieldFocused(param1:FocusEvent) : void
      {
         if(this.asset.inputFieldMC.inputField.text == EMPTY_FIELD)
         {
            this.asset.inputFieldMC.inputField.text = "";
         }
      }
      
      private function show(param1:MovieClip) : void
      {
         param1.alpha = 1;
         param1.enabled = true;
         param1.visible = true;
         param1.mouseChildren = true;
         param1.mouseEnabled = true;
      }
      
      private function setupConfirmButtons() : void
      {
         region.setText(this.asset.option1.field,"ACEPTAR");
         region.setText(this.asset.cancel.field,"CANCELAR");
         region.setText(this.asset.title.text,"ATENCIÓN");
         this.asset.field.text.text = region.key("abuse_report_confirm_text").toUpperCase();
      }
      
      private function setupAbuseButtons() : void
      {
         region.setText(this.asset.option1.field,"LENGUAJE INAPROPIADO");
         region.setText(this.asset.option2.field,"MAL COMPORTAMIENTO");
         region.setText(this.asset.cancel.field,"CANCELAR");
      }
   }
}
