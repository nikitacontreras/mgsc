package com.qb9.gaturro.model.config.cinema
{
   import com.qb9.gaturro.commons.model.definition.IDefinition;
   import flash.utils.Dictionary;
   
   public class CinemaMovieDefinition implements IDefinition
   {
       
      
      private var _thumnail:String;
      
      private var _descrption:String;
      
      private var _decoPath:String;
      
      private var _hasLabel:Boolean;
      
      private var _title:String;
      
      private var _gate:String;
      
      private var _url:String;
      
      private var _countries:Dictionary;
      
      private var _id:String;
      
      public function CinemaMovieDefinition()
      {
         super();
      }
      
      public function set countries(param1:Dictionary) : void
      {
         this._countries = param1;
      }
      
      public function set hasLabel(param1:Boolean) : void
      {
         this._hasLabel = param1;
      }
      
      public function set descrption(param1:String) : void
      {
         this._descrption = param1;
      }
      
      public function get decoPath() : String
      {
         return this._decoPath;
      }
      
      public function set thumnail(param1:String) : void
      {
         this._thumnail = param1;
      }
      
      public function get gate() : String
      {
         return this._gate;
      }
      
      public function set gate(param1:String) : void
      {
         this._gate = param1;
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get hasLabel() : Boolean
      {
         return this._hasLabel;
      }
      
      public function set url(param1:String) : void
      {
         this._url = param1;
      }
      
      public function get thumnail() : String
      {
         return this._thumnail;
      }
      
      public function get descrption() : String
      {
         return this._descrption;
      }
      
      public function set decoPath(param1:String) : void
      {
         this._decoPath = param1;
      }
      
      public function toString() : String
      {
         return "[CinemaMovieDefinition :: id= " + this._id + " // gate= " + this._gate + " // url= " + this._url + " ]";
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function set id(param1:String) : void
      {
         this._id = param1;
      }
      
      public function set title(param1:String) : void
      {
         this._title = param1;
      }
      
      public function get countries() : Dictionary
      {
         return this._countries;
      }
   }
}
