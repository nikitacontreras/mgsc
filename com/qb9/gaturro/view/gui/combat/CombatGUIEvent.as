package com.qb9.gaturro.view.gui.combat
{
   import flash.events.Event;
   
   public class CombatGUIEvent extends Event
   {
      
      public static const TYPE_ICE:String = "ICE";
      
      public static const TYPE_PLASMA:String = "PLASMA";
      
      public static const TYPE_LASER:String = "LASER";
      
      public static const TYPE_BUBBLE:String = "BUBBLE";
      
      public static const TYPE_FIRE:String = "FIRE";
      
      public static const GUI_PRESSED:String = "combatGuiPressed";
      
      public static const GUI_READY:String = "combatGuiReady";
       
      
      private var _element:String;
      
      public function CombatGUIEvent(param1:String, param2:String = null)
      {
         super(param1);
         this._element = param2;
      }
      
      public function get element() : String
      {
         return this._element;
      }
   }
}
