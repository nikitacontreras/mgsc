package com.qb9.flashlib.input
{
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class Shortcut
   {
      
      public static const ALT:int = 4;
      
      public static const CTRL:int = 2;
      
      public static const SHIFT:int = 1;
      
      private static const FIX:Object = {
         "control":"ctrl",
         "pageup":"page_up",
         "pagedown":"page_down",
         "esc":"escape",
         "`":"À"
      };
      
      public static const NO_CODE:int = -1;
       
      
      private var flags:int;
      
      private var code:int;
      
      public function Shortcut(param1:String = "")
      {
         super();
         this.digest(param1);
      }
      
      public static function fromEvent(param1:Object) : Shortcut
      {
         var _loc2_:Shortcut = new Shortcut();
         if(param1.shiftKey)
         {
            _loc2_.flags |= SHIFT;
         }
         if(param1.ctrlKey)
         {
            _loc2_.flags |= CTRL;
         }
         if(param1.altKey)
         {
            _loc2_.flags |= ALT;
         }
         if(param1 is KeyboardEvent)
         {
            _loc2_.code = param1.keyCode;
         }
         return _loc2_;
      }
      
      public static function toKeyCode(param1:String) : int
      {
         param1 = fix(param1);
         if(param1 in Keyboard)
         {
            return Keyboard[param1];
         }
         if(param1.length === 1)
         {
            return param1.charCodeAt(0);
         }
         return -1;
      }
      
      public static function fix(param1:String) : String
      {
         var _loc2_:String = param1.toLowerCase();
         return (_loc2_ in FIX ? String(FIX[_loc2_]) : param1).toUpperCase();
      }
      
      public function get uid() : String
      {
         return this.code + "|" + this.flags;
      }
      
      public function digest(param1:String) : void
      {
         var _loc2_:String = null;
         this.code = NO_CODE;
         this.flags = 0;
         for each(_loc2_ in param1.split(/[ +]+/))
         {
            if(_loc2_)
            {
               _loc2_ = fix(_loc2_);
               if(_loc2_ in Shortcut)
               {
                  this.flags |= Shortcut[_loc2_];
               }
               else
               {
                  this.code = toKeyCode(_loc2_);
               }
            }
         }
      }
   }
}
