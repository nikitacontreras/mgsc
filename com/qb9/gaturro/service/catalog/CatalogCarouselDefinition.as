package com.qb9.gaturro.service.catalog
{
   public class CatalogCarouselDefinition
   {
       
      
      private var _message:String;
      
      private var _name:String;
      
      private var _icon:String;
      
      private var source:Object;
      
      public function CatalogCarouselDefinition(param1:Object)
      {
         super();
         this.source = param1;
         this.setup();
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function toString() : String
      {
         return "CatalogCarouselDefinition: [ name: " + this._name + " - message: " + this._message + " - icon: " + this._icon + " ]";
      }
      
      public function get icon() : String
      {
         return this._icon;
      }
      
      private function setup() : void
      {
         this._name = this.source.name;
         this._icon = this.source.icon;
         this._message = this.source.message;
      }
   }
}
