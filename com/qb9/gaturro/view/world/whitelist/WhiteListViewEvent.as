package com.qb9.gaturro.view.world.whitelist
{
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import flash.events.Event;
   
   public final class WhiteListViewEvent extends Event
   {
      
      public static const CROP:String = "wlvCrop";
      
      public static const MESSAGE_SELECTED:String = "wlvMessageSelected";
      
      public static const CATEGORY_SELECTED:String = "wlvCategorySelected";
       
      
      private var _node:WhiteListNode;
      
      private var _pos:int;
      
      public function WhiteListViewEvent(param1:String, param2:WhiteListNode = null, param3:int = 0)
      {
         super(param1,true);
         this._node = param2;
         this._pos = param3;
      }
      
      public function get pos() : int
      {
         return this._pos;
      }
      
      public function get node() : WhiteListNode
      {
         return this._node;
      }
      
      override public function clone() : Event
      {
         return new WhiteListViewEvent(type,this.node);
      }
   }
}
