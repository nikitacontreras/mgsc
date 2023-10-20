package com.qb9.gaturro.user.cellPhone
{
   import com.qb9.gaturro.view.gui.iphone2.screens.IPhone2MenuScreen;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class CellPhoneApp extends Sprite implements ICellPhoneApp
   {
       
      
      protected var _value:int = 0;
      
      protected var _enabled:Boolean = true;
      
      protected var _appName:String;
      
      protected var _tooltipDescription:String;
      
      protected var _marketView:MovieClip;
      
      protected var _scView:MovieClip;
      
      protected var _nuevo:Boolean;
      
      protected var _scActionName:String;
      
      protected var _guiView:Sprite;
      
      protected var _appkey:String;
      
      protected var _appDescription:String;
      
      protected var _id:uint;
      
      protected var _definition:String;
      
      protected var _menu:IPhone2MenuScreen;
      
      public function CellPhoneApp()
      {
         super();
      }
      
      public function get marketView() : MovieClip
      {
         return this._marketView;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get appkey() : String
      {
         return this._appkey;
      }
      
      public function dispose(param1:Event) : void
      {
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.dispose);
      }
      
      public function get shortCut() : MovieClip
      {
         return this._scView;
      }
      
      public function get appDescription() : String
      {
         return this._appDescription;
      }
      
      public function get nuevo() : Boolean
      {
         return this._nuevo;
      }
      
      final private function _shortCutOnstage(param1:Event) : void
      {
         this._scView.removeEventListener(Event.ADDED_TO_STAGE,this._shortCutOnstage);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.dispose);
         this.shortCutOnstage();
         this.setNotification();
      }
      
      public function set appkey(param1:String) : void
      {
         this._appkey = param1;
      }
      
      public function set id(param1:uint) : void
      {
         this._id = param1;
         this.buildApp();
      }
      
      public function set menu(param1:IPhone2MenuScreen) : void
      {
         this._menu = param1;
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function get appName() : String
      {
         return this._appName;
      }
      
      private function buildApp() : void
      {
         this._definition = getQualifiedClassName(this);
         this._definition = this._definition.replace(this._definition.substr(0,this._definition.indexOf("::") + 2),"");
         var _loc1_:Class = getDefinitionByName(this._definition + "SC") as Class;
         this._scView = new _loc1_();
         this._scView.stop();
         this._scView.mouseChildren = false;
         this._scView.buttonMode = true;
         this._scView.name = this._scActionName;
         this._scView.addEventListener(Event.ADDED_TO_STAGE,this._shortCutOnstage);
      }
      
      public function get menu() : IPhone2MenuScreen
      {
         return this._menu;
      }
      
      protected function setNotification() : void
      {
         if(this._nuevo)
         {
            AppShortCut(this._scView).notificationStatus = NotificationStatus.NEW;
         }
         else
         {
            AppShortCut(this._scView).notificationStatus = NotificationStatus.NONE;
         }
      }
      
      public function set nuevo(param1:Boolean) : void
      {
         this._nuevo = param1;
      }
      
      public function get value() : int
      {
         return this._value;
      }
      
      protected function shortCutOnstage() : void
      {
      }
   }
}
