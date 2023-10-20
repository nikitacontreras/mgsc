package com.qb9.gaturro.view.gui.base.components
{
   public final class DropDownItem
   {
       
      
      private var _label:String;
      
      private var _data:String;
      
      public function DropDownItem(param1:String, param2:String = null)
      {
         super();
         this._label = param1;
         this._data = param2 || param1;
      }
      
      public function get icon() : String
      {
         return "";
      }
      
      public function get data() : String
      {
         return this._data;
      }
      
      public function get label() : String
      {
         return this._label;
      }
   }
}
