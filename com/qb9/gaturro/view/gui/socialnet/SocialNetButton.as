package com.qb9.gaturro.view.gui.socialnet
{
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.server;
   import com.qb9.gaturro.globals.settings;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.net.SharedObject;
   import flash.utils.setTimeout;
   
   public class SocialNetButton
   {
       
      
      private var buttonMC:MovieClip;
      
      private var onClick:Function;
      
      private var text:String;
      
      private var cookieName:String = "";
      
      private var blockedByTime:Boolean = false;
      
      public function SocialNetButton(param1:String, param2:MovieClip, param3:Function, param4:String = "")
      {
         super();
         this.onClick = param3;
         this.buttonMC = param2;
         this.text = param1;
         this.cookieName = param4;
         this.buttonMC.gotoAndStop("testingService");
         this.buttonMC.text.text = "";
         this.verifyTimestamp();
      }
      
      public function activate() : void
      {
         setTimeout(this._activate,300);
      }
      
      private function click(param1:MouseEvent) : void
      {
         var _loc2_:SharedObject = null;
         if(this.cookieName != "")
         {
            _loc2_ = SharedObject.getLocal("gaturro");
            _loc2_.data[this.cookieName] = server.time;
            _loc2_.flush();
         }
         this.onClick();
      }
      
      public function deactivate() : void
      {
         if(this.blockedByTime)
         {
            return;
         }
         this.buttonMC.gotoAndStop("noService");
         this.buttonMC.text.text = region.getText("SIN SERVICIO");
         this.buttonMC.buttonMode = false;
      }
      
      private function getPrevTime() : Number
      {
         if(this.cookieName == "")
         {
            return 0;
         }
         var _loc1_:String = String(SharedObject.getLocal("gaturro").data[this.cookieName]);
         if(_loc1_ == null || _loc1_ == "")
         {
            return 0;
         }
         return Number(_loc1_);
      }
      
      private function _activate() : void
      {
         if(this.blockedByTime)
         {
            return;
         }
         this.buttonMC.gotoAndStop("active");
         this.buttonMC.addEventListener(MouseEvent.CLICK,this.click);
         this.buttonMC.text.text = this.text;
         this.buttonMC.buttonMode = true;
      }
      
      private function verifyTimestamp() : void
      {
         var _loc1_:Number = this.getPrevTime();
         if(_loc1_ <= 0)
         {
            return;
         }
         var _loc2_:Number = Number(server.time);
         var _loc3_:Number = Number(settings.socialNet[this.cookieName]);
         if(_loc1_ + _loc3_ > _loc2_)
         {
            this.blockedByTime = true;
            this.buttonMC.gotoAndStop("blocked");
            this.buttonMC.text.text = region.getText("ESPERE UNOS MINUTOS");
         }
      }
      
      public function dispose() : void
      {
         this.buttonMC.removeEventListener(MouseEvent.CLICK,this.click);
      }
   }
}
