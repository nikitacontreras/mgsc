package com.qb9.gaturro.user.cellPhone
{
   import com.qb9.gaturro.view.gui.iphone2.screens.IPhone2MenuScreen;
   import flash.display.MovieClip;
   
   public interface ICellPhoneApp
   {
       
      
      function get enabled() : Boolean;
      
      function get appDescription() : String;
      
      function get appkey() : String;
      
      function get shortCut() : MovieClip;
      
      function get marketView() : MovieClip;
      
      function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void;
      
      function get appName() : String;
      
      function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void;
      
      function set nuevo(param1:Boolean) : void;
      
      function get value() : int;
      
      function set id(param1:uint) : void;
      
      function get nuevo() : Boolean;
      
      function get id() : uint;
      
      function set appkey(param1:String) : void;
      
      function set menu(param1:IPhone2MenuScreen) : void;
      
      function get menu() : IPhone2MenuScreen;
   }
}
