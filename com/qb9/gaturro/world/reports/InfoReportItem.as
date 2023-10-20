package com.qb9.gaturro.world.reports
{
   public final class InfoReportItem
   {
       
      
      private var _data:Object;
      
      private var _message:String;
      
      private var _type:String;
      
      public function InfoReportItem(param1:String, param2:String, param3:Object = null)
      {
         super();
         this._type = param1;
         this._message = param2;
         this._data = param3;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function get message() : String
      {
         return this._message;
      }
   }
}
