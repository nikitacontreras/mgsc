package com.qb9.gaturro.view.gui.iphone2.screens
{
   import assets.Iphone2MenuMC;
   import com.qb9.flashlib.tasks.ITask;
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.user.cellPhone.ICellPhoneApp;
   import com.qb9.gaturro.user.cellPhone.ShortCutsHolder;
   import com.qb9.gaturro.view.gui.iphone2.*;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public final class IPhone2MenuScreen extends BaseIPhone2Screen
   {
      
      private static const TOOLTIPS:Object = {
         "news":region.getText("Conoce las novedades"),
         "socialnet":region.getText("????????????"),
         "messages":region.getText("Envía y recibe mensajes"),
         "friends":region.getText("Tu lista de amigos"),
         "podometro":region.getText("¿QUIÉN DIJO QUE TE EJERCITAS POCO?"),
         "bola8":region.getText("¿BUSCAS RESPUESTAS? ¡CONSÚLTALA!"),
         "alarmclock":region.getText("UNA PEQUEÑA AYUDA MEMORIA..."),
         "piano":region.getText("A VER... ¡UNA QUE SEPAMOS TODOS!"),
         "snakegame":region.getText("¡JUEGA, QUE NO MUERDE!"),
         "store":region.getText("¡CONSIGUE NUEVAS APLICACIONES!")
      };
       
      
      private var blinkTask:ITask;
      
      private var defaultTooltip:String = "inbox";
      
      private var tasks:TaskContainer;
      
      private var _shortCutsHolder:ShortCutsHolder;
      
      private var mailer:GaturroMailer;
      
      private var _dragging:Boolean;
      
      public function IPhone2MenuScreen(param1:IPhone2Modal, param2:GaturroMailer, param3:TaskContainer)
      {
         super(param1,new Iphone2MenuMC(),{
            "news":this.buttonClicked,
            "socialnet":this.buttonClicked,
            "messages":this.iphoneButtonClicked,
            "friends":this.iphoneButtonClicked,
            "podometro":this.buttonClicked,
            "bola8":this.buttonClicked,
            "alarmclock":this.buttonClicked,
            "piano":this.buttonClicked,
            "snakegame":this.buttonClicked,
            "store":this.buttonClicked
         });
         this.tasks = param3;
         user.cellPhone.mailer = param2;
         this.init();
      }
      
      private function tooltip(param1:String) : void
      {
         setText("title.field",TOOLTIPS[param1]);
      }
      
      private function init() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.changeTooltip);
         this.tooltip(this.defaultTooltip);
      }
      
      override protected function atOnce() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:Rectangle = null;
         var _loc3_:uint = 0;
         var _loc4_:ICellPhoneApp = null;
         super.atOnce();
         if(!this._shortCutsHolder)
         {
            _loc1_ = new Rectangle(asset.area_total.x,asset.area_total.y,asset.area_total.width,asset.area_total.height);
            _loc2_ = new Rectangle(asset.area_interior.x,asset.area_interior.y,asset.area_interior.width,asset.area_interior.height);
            asset.removeChild(asset.area_interior);
            asset.removeChild(asset.area_total);
            this._shortCutsHolder = new ShortCutsHolder(_loc1_,_loc2_);
            this._shortCutsHolder.addEventListener("DRAGING",this.dragStarted);
            this._shortCutsHolder.addEventListener("STARTDRAG",this.resetDrag);
            this._shortCutsHolder.reset();
            _loc3_ = 0;
            while(_loc3_ < user.cellPhone.apps.count)
            {
               (_loc4_ = user.cellPhone.apps.getApp(_loc3_) as ICellPhoneApp).menu = this;
               if(_loc4_.enabled)
               {
                  this._shortCutsHolder.add(_loc4_.shortCut);
               }
               _loc3_++;
            }
            asset.addChild(this._shortCutsHolder);
         }
      }
      
      private function buttonClicked(param1:DisplayObject) : void
      {
         if(this._dragging)
         {
            this._dragging = false;
            return;
         }
         var _loc2_:String = param1.name;
         var _loc3_:int = 0;
         while(_loc3_ < user.cellPhone.apps.count)
         {
            if(user.cellPhone.apps.getApp(_loc3_).shortCut.name == _loc2_ && Boolean(user.cellPhone.apps.getApp(_loc3_).nuevo))
            {
               user.cellPhone.apps.appIsnoLongerNew(user.cellPhone.apps.getApp(_loc3_));
               break;
            }
            _loc3_++;
         }
         goto(_loc2_);
      }
      
      public function rotateNews() : void
      {
      }
      
      override public function dispose() : void
      {
         this.disposeBlinkTask();
         this.mailer = null;
         this.tasks = null;
         this._shortCutsHolder.removeEventListener("DRAGING",this.dragStarted);
         this._shortCutsHolder.removeEventListener("STARTDRAG",this.resetDrag);
         removeEventListener(MouseEvent.MOUSE_OVER,this.changeTooltip);
         super.dispose();
      }
      
      private function disposeBlinkTask() : void
      {
         if(this.blinkTask)
         {
            this.tasks.remove(this.blinkTask);
            this.blinkTask = null;
         }
      }
      
      private function resetDrag(param1:Event) : void
      {
         this._dragging = false;
      }
      
      private function get menu() : Iphone2MenuMC
      {
         return asset as Iphone2MenuMC;
      }
      
      private function dragStarted(param1:Event) : void
      {
         logger.info("### IPHONE ### dragStarted");
         this._dragging = true;
      }
      
      private function iphoneButtonClicked(param1:DisplayObject) : void
      {
         if(user.community.isLoaded == false)
         {
            goto(IPhone2Screens.ERROR,new InternalErrorData(region.getText("Servicio de comunidad no disponible"),IPhone2Screens.MENU));
            return;
         }
         this.buttonClicked(param1);
      }
      
      private function changeTooltip(param1:Event) : void
      {
         var _loc2_:DisplayObject = getTarget(param1);
         if(_loc2_)
         {
            this.tooltip(_loc2_.name);
         }
      }
   }
}
