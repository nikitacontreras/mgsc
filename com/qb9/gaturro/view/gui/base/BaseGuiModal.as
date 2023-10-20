package com.qb9.gaturro.view.gui.base
{
   import com.qb9.gaturro.globals.audio;
   import com.qb9.mambo.view.MamboView;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import flash.utils.getQualifiedClassName;
   
   public class BaseGuiModal extends MamboView
   {
       
      
      private var draggable:Boolean;
      
      public function BaseGuiModal()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.init);
      }
      
      public function get denomination() : String
      {
         var _loc1_:String = getQualifiedClassName(this);
         return String(_loc1_.split(":")[_loc1_.split(":").length - 1]);
      }
      
      private function disposeStageEvents(param1:Event = null) : void
      {
         if(!stage)
         {
            return;
         }
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.checkKeys);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.drop);
      }
      
      protected function get openSound() : String
      {
         return "popup";
      }
      
      protected function pressEscKey() : void
      {
         this.close();
      }
      
      override public function dispose() : void
      {
         this.disposeStageEvents();
         removeEventListener(Event.REMOVED_FROM_STAGE,this.disposeStageEvents);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.drag);
         removeEventListener(MouseEvent.MOUSE_UP,this.drop);
         super.dispose();
      }
      
      private function drop(param1:Event) : void
      {
         stopDrag();
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.drop);
      }
      
      private function init(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.init);
         addEventListener(Event.REMOVED_FROM_STAGE,this.disposeStageEvents);
         if(this.draggable)
         {
            addEventListener(MouseEvent.MOUSE_DOWN,this.drag);
         }
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.checkKeys);
         if(this.openSound)
         {
            audio.addLazyPlay(this.openSound);
         }
      }
      
      private function drag(param1:Event) : void
      {
         if(param1.target is TextField)
         {
            return;
         }
         startDrag();
         stage.addEventListener(MouseEvent.MOUSE_UP,this.drop);
      }
      
      public function get isDisposed() : Boolean
      {
         return disposed;
      }
      
      protected function get closeSound() : String
      {
         return "popup2";
      }
      
      public function close() : void
      {
         if(this.closeSound)
         {
            audio.addLazyPlay(this.closeSound);
         }
         dispatchEvent(new Event(Event.CLOSE,true));
      }
      
      protected function _close(param1:Event) : void
      {
         this.close();
      }
      
      private function checkKeys(param1:KeyboardEvent) : void
      {
         if(stage.focus is TextField && !contains(stage.focus))
         {
            return;
         }
         var _loc2_:uint = uint(param1.keyCode || param1.charCode);
         if(_loc2_ === Keyboard.ESCAPE)
         {
            this.pressEscKey();
         }
         else if(_loc2_ === Keyboard.ENTER)
         {
            this.keyboardSubmit();
         }
      }
      
      protected function keyboardSubmit() : void
      {
      }
   }
}
