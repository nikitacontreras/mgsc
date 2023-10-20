package com.qb9.gaturro.view.gui.iphone2.screens
{
   internal final class InternalErrorData
   {
       
      
      private var _state:String;
      
      private var _message:String;
      
      public function InternalErrorData(param1:String, param2:String)
      {
         super();
         this._message = param1;
         this._state = param2;
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function get message() : String
      {
         return this._message;
      }
   }
}
