package com.qb9.gaturro.view.gui.chat
{
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.view.gui.base.BaseGuiButton;
   import com.qb9.mambo.net.chat.RoomChat;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   
   public final class GuiChat extends BaseGuiButton
   {
      
      private static const MAX_CHARS:uint = 300;
      
      private static var mem:String;
       
      
      private var widget:MovieClip;
      
      private var chat:RoomChat;
      
      public function GuiChat(param1:Gui, param2:RoomChat)
      {
         this.widget = param1.chat;
         this.chat = param2;
         super(param1,this.widget.submit);
         this.init();
      }
      
      override public function dispose() : void
      {
         mem = this.message;
         this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.captureTyping);
         this.field.removeEventListener(KeyboardEvent.KEY_DOWN,this.checkKey);
         this.field.removeEventListener(Event.CHANGE,this.keepUppercased);
         this.widget = null;
         this.chat = null;
         super.dispose();
      }
      
      private function get stage() : Stage
      {
         return asset.stage;
      }
      
      private function keepUppercased(param1:Event) : void
      {
         this.field.text = this.field.text.toUpperCase();
      }
      
      private function get message() : String
      {
         return this.field.text;
      }
      
      private function set message(param1:String) : void
      {
         this.field.text = param1;
      }
      
      override protected function action() : void
      {
         var _loc1_:String = StringUtil.trim(this.message);
         if(_loc1_)
         {
            this.chat.send(_loc1_);
            this.message = "";
         }
      }
      
      private function init() : void
      {
         this.field.maxChars = 300;
         this.field.addEventListener(KeyboardEvent.KEY_DOWN,this.checkKey);
         this.field.addEventListener(Event.CHANGE,this.keepUppercased);
         this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.captureTyping,false,-1);
         if(mem)
         {
            this.message = mem;
         }
      }
      
      private function get focus() : InteractiveObject
      {
         return !!this.stage ? this.stage.focus : null;
      }
      
      private function get field() : TextField
      {
         return this.widget.input;
      }
      
      private function captureTyping(param1:KeyboardEvent) : void
      {
         if(this.focus is TextField === false)
         {
            this.stage.focus = this.field;
         }
      }
      
      private function checkKey(param1:KeyboardEvent) : void
      {
         if(param1.keyCode === Keyboard.ENTER && this.focus === this.field)
         {
            this.action();
         }
      }
   }
}
