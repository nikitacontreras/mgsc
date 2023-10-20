package com.qb9.gaturro.user.cellPhone
{
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.user.cellPhone.apps.CellPhoneAppDefinition;
   
   public class CellPhoneAppsManager
   {
       
      
      private const NEW_PREFIX:String = "_";
      
      private var _defaultApps:String = "_1,_2,_3,_4,_10";
      
      private var _apps:Array;
      
      public function CellPhoneAppsManager()
      {
         this._apps = new Array();
         super();
         this.buildApps();
      }
      
      public function buildApps() : void
      {
         var _loc4_:uint = 0;
         var _loc5_:ICellPhoneApp = null;
         this._apps.length = 0;
         var _loc1_:Array = this.getInstalledApps();
         trace("cellApps" + _loc1_);
         var _loc2_:Boolean = false;
         if(_loc1_ == null || _loc1_.length < this._defaultApps.split(",").length)
         {
            _loc2_ = true;
            _loc1_ = this._defaultApps.split(",");
         }
         var _loc3_:uint = 0;
         while(_loc3_ < _loc1_.length)
         {
            _loc4_ = uint(String(_loc1_[_loc3_]).replace("_",""));
            (_loc5_ = CellPhoneAppDefinition.generateAppbyId(_loc4_) as ICellPhoneApp).nuevo = String(_loc1_[_loc3_]).indexOf(this.NEW_PREFIX) != -1 ? true : false;
            _loc5_.id = _loc4_;
            this._apps.push(_loc5_);
            _loc3_++;
         }
         if(_loc2_)
         {
            this.saveApps();
         }
      }
      
      public function add(param1:String) : String
      {
         if(this.getAppByAppkey(param1) != null)
         {
            return "No se pudo instalar la aplicación \"" + param1 + "\" ya esta instalada";
         }
         var _loc2_:ICellPhoneApp = CellPhoneAppDefinition.generateAppbyAppKey(param1);
         if(_loc2_ != null)
         {
            _loc2_.nuevo = true;
            this._apps.push(_loc2_);
            this.saveApps();
            return "La app se agrego con éxito al celular.";
         }
         return "la appKey \"" + param1 + "\" no corresponde a ninguna aplicación válida";
      }
      
      public function remove(param1:String) : String
      {
         var _loc2_:ICellPhoneApp = this.getAppByAppkey(param1);
         if(_loc2_ == null)
         {
            return "No hay ninguna app instalada en el celular con la appKey \"" + param1 + "\"";
         }
         var _loc3_:uint = uint(this._apps.indexOf(_loc2_));
         this._apps.splice(_loc3_,1);
         this.saveApps();
         return "La aplicación " + param1 + " ha sido eliminada del celular.";
      }
      
      private function getAppByAppkey(param1:String) : ICellPhoneApp
      {
         var _loc2_:ICellPhoneApp = null;
         var _loc3_:uint = 0;
         while(_loc3_ < this._apps.length)
         {
            if(ICellPhoneApp(this._apps[_loc3_]).appkey == param1)
            {
               _loc2_ = this._apps[_loc3_] as ICellPhoneApp;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function appIsnoLongerNew(param1:ICellPhoneApp) : void
      {
         trace("Se esta llamando appIsnoLongerNew");
         param1.nuevo = false;
         AppShortCut(param1.shortCut)._notificationIcon.visible = false;
         this.saveApps();
      }
      
      public function saveApps() : void
      {
         var _loc3_:* = null;
         var _loc4_:ICellPhoneApp = null;
         var _loc1_:String = "";
         var _loc2_:int = 0;
         while(_loc2_ < this._apps.length)
         {
            _loc3_ = "";
            _loc4_ = this._apps[_loc2_];
            if(_loc2_ != 0)
            {
               _loc3_ += ",";
            }
            if(_loc4_.nuevo)
            {
               _loc3_ += "_";
            }
            _loc3_ += _loc4_.id;
            _loc1_ += _loc3_;
            _loc2_++;
         }
         user.profile.attributes.cellApps = _loc1_;
      }
      
      public function getApp(param1:uint) : ICellPhoneApp
      {
         return this._apps[param1] as ICellPhoneApp;
      }
      
      private function getInstalledApps() : Array
      {
         var _loc2_:Array = null;
         var _loc1_:String = String(user.profile.attributes.cellApps);
         if(this.validateAppAttr(_loc1_))
         {
            return String(_loc1_).split(",");
         }
         return null;
      }
      
      public function get apps() : Array
      {
         return this._apps;
      }
      
      private function validateAppAttr(param1:String) : Boolean
      {
         if(param1 == null || param1 == "" || param1 == "null")
         {
            return false;
         }
         return true;
      }
      
      public function getAppById(param1:uint) : ICellPhoneApp
      {
         var _loc2_:ICellPhoneApp = null;
         var _loc3_:int = 0;
         while(_loc3_ < this._apps.length)
         {
            _loc2_ = this._apps[_loc3_] as ICellPhoneApp;
            if(_loc2_.id == param1)
            {
               _loc2_ = this._apps[_loc3_];
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function get count() : int
      {
         return this._apps.length;
      }
   }
}
