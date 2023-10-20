package com.qb9.gaturro.view.gui.info
{
   import assets.pasaporteAlerta;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.util.TimeSpan;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public final class PassportWarningModal extends BaseGuiModal
   {
      
      public static const EXPIRED_PASSPORT:String = "userHadPassport";
      
      private static const POS:Array = [47,359];
      
      public static const VALID_PASSPORT:String = "userHasAValidPassport";
      
      public static const NULL_PASSPORT:String = "userNeverHadPassport";
      
      public static const EXPIRING_PASSPORT:String = "userHasExpiringPassport";
       
      
      private var preTexts:Object;
      
      private var line2:TextField;
      
      private var _timer:Timer;
      
      private var shown:Boolean = false;
      
      private var preLimit:int;
      
      private var timeout:int;
      
      private var postTexts:Object;
      
      private var asset:pasaporteAlerta;
      
      private var postLimit:int;
      
      private var line1:TextField;
      
      private var daysLeft:int = 10000;
      
      public function PassportWarningModal(param1:int = 0)
      {
         this.preLimit = settings.info.passport_warning.pre.limit;
         this.preTexts = settings.info.passport_warning.pre.texts;
         this.postLimit = settings.info.passport_warning.post.limit;
         this.postTexts = settings.info.passport_warning.post.texts;
         super();
         this.showWarning(this.checkLastPassport());
         this.timeout = param1;
      }
      
      override public function dispose() : void
      {
         if(this.shown)
         {
            this.removeChild(this.asset);
            this.asset = null;
         }
         super.dispose();
      }
      
      private function init() : void
      {
         this.asset = new pasaporteAlerta();
         this.asset.x = POS[0];
         this.asset.y = POS[1];
         this.line1 = this.asset.line1;
         this.line2 = this.asset.line2;
         this.addChild(this.asset);
         this.asset.addEventListener(MouseEvent.MOUSE_UP,this.onClick);
         if(this.timeout > 0)
         {
            this._timer = new Timer(this.timeout,1);
            this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,_close);
         }
         this.shown = true;
      }
      
      private function showGoBuyPassport() : void
      {
         trace(this,"showGoBuyPassport()");
      }
      
      private function showWarning(param1:String) : void
      {
         switch(param1)
         {
            case NULL_PASSPORT:
               Telemetry.getInstance().trackEvent(TrackCategories.PASSPORT,TrackActions.PASS_NULL);
               api.setSession("warningShown",true);
               break;
            case VALID_PASSPORT:
               Telemetry.getInstance().trackEvent(TrackCategories.PASSPORT,TrackActions.PASS_VALID);
               api.setSession("warningShown",true);
               break;
            case EXPIRING_PASSPORT:
               this.init();
               this.showValidate();
               Telemetry.getInstance().trackEvent(TrackCategories.PASSPORT,TrackActions.PASS_EXPIRING);
               break;
            case EXPIRED_PASSPORT:
               this.init();
               this.showExpired();
               Telemetry.getInstance().trackEvent(TrackCategories.PASSPORT,TrackActions.PASS_EXPIRED);
         }
      }
      
      private function showExpired() : void
      {
         this.line1.text = api.getText(this.postTexts.string1);
         this.line2.text = api.getText(this.postTexts.string2);
      }
      
      private function onClick(param1:Event) : void
      {
         navigateToURL(new URLRequest(settings.info.url_pasaporte),"_blank");
         api.setSession("warningShown",true);
      }
      
      private function showValidate() : void
      {
         var _loc1_:String = String(api.getText(this.preTexts.string1[0]));
         _loc1_ += " " + (this.daysLeft + 1).toString() + " ";
         _loc1_ += this.daysLeft == 0 ? api.getText(this.preTexts.string1[1].replace("S","")) : api.getText(this.preTexts.string1[1]);
         _loc1_ += " " + api.getText(this.preTexts.string1[2]);
         this.line1.text = _loc1_;
         this.line2.text = api.getText(this.preTexts.string2);
      }
      
      override protected function keyboardSubmit() : void
      {
         close();
      }
      
      private function checkLastPassport() : String
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(api.user.passport == 0)
         {
            return NULL_PASSPORT;
         }
         _loc1_ = Number(api.user.passport);
         _loc2_ = Number(api.serverTime);
         this.daysLeft = TimeSpan.fromMilliseconds(_loc1_ - _loc2_).days;
         if(this.daysLeft > this.preLimit)
         {
            return VALID_PASSPORT;
         }
         if(this.daysLeft <= this.preLimit && this.daysLeft >= 0)
         {
            return EXPIRING_PASSPORT;
         }
         if(this.daysLeft < 0 && this.daysLeft > -this.postLimit)
         {
            return EXPIRED_PASSPORT;
         }
         return NULL_PASSPORT;
      }
   }
}
