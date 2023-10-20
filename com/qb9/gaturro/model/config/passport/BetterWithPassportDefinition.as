package com.qb9.gaturro.model.config.passport
{
   import com.qb9.gaturro.commons.model.definition.IDefinition;
   
   public class BetterWithPassportDefinition implements IDefinition
   {
       
      
      private var _message:String;
      
      private var _dateObj:Date;
      
      private var _date:String;
      
      private var _type:String;
      
      private var _image:String;
      
      public function BetterWithPassportDefinition()
      {
         super();
      }
      
      public function get image() : String
      {
         return this._image;
      }
      
      public function set date(param1:String) : void
      {
         this._date = param1;
      }
      
      public function get dateObject() : Date
      {
         return this._dateObj;
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      public function set dateObject(param1:Date) : void
      {
         this._dateObj = param1;
      }
      
      public function get date() : String
      {
         return this._date;
      }
      
      public function set message(param1:String) : void
      {
         this._message = param1;
      }
      
      public function set image(param1:String) : void
      {
         this._image = param1;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function set type(param1:String) : void
      {
         this._type = param1;
      }
   }
}
