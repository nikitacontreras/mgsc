package com.qb9.gaturro.commons.manager.notificator
{
   public class Notification
   {
       
      
      private var _type:String;
      
      private var _data:Object;
      
      public function Notification(param1:String, param2:Object)
      {
         super();
         this._data = param2;
         this._type = param1;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
   }
}
