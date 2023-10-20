package com.qb9.gaturro.view.gui.base
{
   import com.qb9.flashlib.lang.AbstractMethodError;
   import com.qb9.gaturro.view.gui.Gui;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class BaseGuiModalOpener extends BaseGuiButton
   {
       
      
      private var modalX:Number;
      
      private var modalY:Number;
      
      protected var modal:com.qb9.gaturro.view.gui.base.BaseGuiModal;
      
      public function BaseGuiModalOpener(param1:Gui, param2:Sprite, param3:Number = 0, param4:Number = 390)
      {
         super(param1,param2);
         this.modalX = param3;
         this.modalY = param4;
      }
      
      protected function createModal() : com.qb9.gaturro.view.gui.base.BaseGuiModal
      {
         throw new AbstractMethodError();
      }
      
      protected function cleanModal(param1:Event = null) : void
      {
         if(!this.modal)
         {
            return;
         }
         this.modal.removeEventListener(Event.CLOSE,this.cleanModal);
         this.modal = null;
      }
      
      override protected function action() : void
      {
         if(Boolean(this.modal) && Boolean(this.modal.parent))
         {
            return this.modal.close();
         }
         this.modal = this.createModal();
         this.modal.addEventListener(Event.CLOSE,this.cleanModal);
         if(this.modalX)
         {
            this.modal.x = this.modalX;
         }
         if(this.modalY)
         {
            this.modal.y = this.modalY;
         }
         gui.addModal(this.modal);
      }
      
      override public function dispose() : void
      {
         this.cleanModal();
         super.dispose();
      }
   }
}
