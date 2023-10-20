package com.qb9.gaturro.commons.model.item
{
   import com.qb9.gaturro.commons.model.definition.IDefinition;
   
   public class ItemDefinition implements IDefinition
   {
       
      
      private var _path:String;
      
      private var _name:String;
      
      private var _code:int;
      
      private var _icon:String;
      
      public function ItemDefinition()
      {
         super();
      }
      
      public function get path() : String
      {
         return this._path;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get code() : int
      {
         return this._code;
      }
      
      public function set path(param1:String) : void
      {
         this._path = param1;
      }
      
      public function set icon(param1:String) : void
      {
         this._icon = param1;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get icon() : String
      {
         return this._icon;
      }
      
      public function set code(param1:int) : void
      {
         this._code = param1;
      }
   }
}
