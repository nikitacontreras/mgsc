package com.qb9.gaturro.view.gui.iphone2.transitions
{
   public final class IPhone2Transition
   {
       
      
      private var _direction:uint;
      
      private var _data:Object;
      
      private var _screen:String;
      
      public function IPhone2Transition(param1:String, param2:uint, param3:Object = null)
      {
         super();
         this._screen = param1;
         this._direction = param2;
         this._data = param3;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function get screen() : String
      {
         return this._screen;
      }
      
      public function get direction() : uint
      {
         return this._direction;
      }
   }
}
