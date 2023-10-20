package com.qb9.mambo.view
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class MamboView extends Sprite implements IDisposable
   {
       
      
      protected var disposed:Boolean = false;
      
      public function MamboView()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this._added);
      }
      
      private function _added(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this._added);
         this.whenAddedToStage();
      }
      
      protected function whenAddedToStage() : void
      {
      }
      
      public function dispose() : void
      {
         this.disposed = true;
      }
   }
}
