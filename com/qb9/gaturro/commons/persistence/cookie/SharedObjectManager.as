package com.qb9.gaturro.commons.persistence.cookie
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import flash.errors.IllegalOperationError;
   import flash.utils.Dictionary;
   
   public class SharedObjectManager implements ICheckableDisposable
   {
      
      private static var _instance:com.qb9.gaturro.commons.persistence.cookie.SharedObjectManager;
       
      
      private var _disposed:Boolean;
      
      private var cookies:Dictionary;
      
      public function SharedObjectManager()
      {
         super();
         if(_instance)
         {
            throw new IllegalOperationError("This is a singleton implementation and shouldn\'t instantiate statically. use: SharedObjectManager.instance");
         }
         _instance = this;
         Context.instance.addByType(this,com.qb9.gaturro.commons.persistence.cookie.SharedObjectManager);
         this.cookies = new Dictionary();
      }
      
      public static function get instance() : com.qb9.gaturro.commons.persistence.cookie.SharedObjectManager
      {
         if(_instance)
         {
         }
         return _instance;
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function write(param1:String, param2:String, param3:*) : void
      {
         if(this.hasCookie(param1))
         {
            (this.cookies[param1] as Cookie).write(param2,param3);
         }
      }
      
      public function read(param1:String, param2:String) : *
      {
         var _loc3_:* = undefined;
         if(this.hasCookie(param1))
         {
            return (this.cookies[param1] as Cookie).read(param2);
         }
         return null;
      }
      
      public function create(param1:String) : void
      {
         this.cookies[param1] = new Cookie(param1);
      }
      
      public function hasCookie(param1:String) : Boolean
      {
         return this.cookies[param1] != null ? true : false;
      }
      
      public function dispose() : void
      {
         var _loc1_:Cookie = null;
         for each(_loc1_ in this.cookies)
         {
            _loc1_.dispose();
         }
         this.cookies = null;
         this._disposed = true;
      }
   }
}

import com.qb9.gaturro.globals.api;
import com.qb9.gaturro.globals.logger;
import flash.net.SharedObject;

class Cookie
{
   
   private static const PATH:String = "com/qb9/gaturro/";
    
   
   private var data:Object;
   
   public var name:String;
   
   private var so:SharedObject;
   
   public function Cookie(param1:String)
   {
      var rex:RegExp = null;
      var fixedName:String = null;
      var name:String = param1;
      super();
      this.name = name;
      try
      {
         rex = /[\s\r\n]+/gim;
         fixedName = String(api.user.username.replace(rex,"_"));
         logger.debug(this,fixedName);
         this.so = SharedObject.getLocal(PATH + fixedName,"/");
      }
      catch(error:Error)
      {
         logger.debug(this,"cant create cookie: ",PATH + name);
      }
   }
   
   public function read(param1:String) : *
   {
      return !!this.so.data.hasOwnProperty(param1) ? this.so.data[param1] : null;
   }
   
   public function dispose() : void
   {
      this.so = null;
   }
   
   public function write(param1:String, param2:*) : void
   {
      this.so.setProperty(param1,param2);
      this.so.flush();
   }
}
