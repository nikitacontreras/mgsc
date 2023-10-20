package com.qb9.gaturro.commons.view.component.canvas.display
{
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public class Canvas implements ICheckableDisposable
   {
       
      
      protected var _view:DisplayObjectContainer;
      
      protected var _disposed:Boolean;
      
      protected var _owner:BaseGuiModal;
      
      protected var _id:String;
      
      public function Canvas(param1:String)
      {
         super();
         logger.debug(this,"id = [" + param1 + "]");
         this._id = param1;
         this.setupView();
      }
      
      final protected function getChildByName(param1:String) : DisplayObject
      {
         return this._view.getChildByName(param1);
      }
      
      public function hide() : void
      {
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function get view() : DisplayObjectContainer
      {
         return this._view;
      }
      
      protected function setupView() : void
      {
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get owner() : BaseGuiModal
      {
         return this._owner;
      }
      
      final protected function getChildAt(param1:int) : DisplayObject
      {
         return this._view.getChildAt(param1);
      }
      
      public function show(param1:Object = null) : void
      {
      }
      
      public function dispose() : void
      {
         this._disposed = true;
      }
   }
}
