package com.qb9.gaturro.view.gui.contextual
{
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import com.qb9.gaturro.view.world.cursor.Cursor;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class ContextualMenuManager implements ICheckableDisposable
   {
       
      
      private var _container:DisplayObjectContainer;
      
      private var _disposed:Boolean;
      
      private var _factory:com.qb9.gaturro.view.gui.contextual.ContextualMenuFactory;
      
      private var map:Dictionary;
      
      private var menuHolder:Sprite;
      
      private var modalHolder:Sprite;
      
      private var _cursor:Cursor;
      
      public function ContextualMenuManager()
      {
         super();
         this.map = new Dictionary();
      }
      
      public function removeMenu(param1:DisplayObject) : void
      {
         this.doRemoving(param1);
         this.modalHolder.visible = false;
         if(this.modalHolder.hasEventListener(MouseEvent.ROLL_OVER))
         {
            this.modalHolder.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         }
         if(this.modalHolder.hasEventListener(MouseEvent.ROLL_OUT))
         {
            this.modalHolder.removeEventListener(MouseEvent.ROLL_OUT,this.onRoolOut);
         }
      }
      
      private function getGuide(param1:DisplayObject) : DisplayObject
      {
         var _loc2_:DisplayObject = param1;
         if(param1 is Sprite)
         {
            _loc2_ = DisplayUtil.getByName(param1 as Sprite,"chat_ph") || _loc2_;
         }
         return _loc2_;
      }
      
      private function place(param1:DisplayObject, param2:DisplayObject) : void
      {
         var _loc3_:DisplayObject = this.getGuide(param1);
         param2.x = DisplayUtil.offsetX(_loc3_,this.menuHolder);
         param2.y = DisplayUtil.offsetY(_loc3_,this.menuHolder);
      }
      
      private function clean() : void
      {
         var _loc1_:Object = null;
         for(_loc1_ in this.map)
         {
            this.doRemoving(_loc1_ as DisplayObject);
         }
         if(this.modalHolder)
         {
            if(this.modalHolder.hasEventListener(MouseEvent.ROLL_OVER))
            {
               this.modalHolder.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
            }
            if(this.modalHolder.hasEventListener(MouseEvent.ROLL_OUT))
            {
               this.modalHolder.removeEventListener(MouseEvent.ROLL_OUT,this.onRoolOut);
            }
            this.modalHolder.visible = false;
         }
      }
      
      private function setupHolders() : void
      {
         this.setupModalHolder();
         this.setupMenuHolder();
      }
      
      public function reset() : void
      {
         this.clean();
         if(this.modalHolder)
         {
            this.modalHolder.removeEventListener(MouseEvent.CLICK,this.onClick);
         }
         this._container = null;
         this.modalHolder = null;
         this.menuHolder = null;
      }
      
      public function set container(param1:DisplayObjectContainer) : void
      {
         this._container = param1;
         this.setupHolders();
      }
      
      private function setupModalHolder() : void
      {
         if(this._container.stage)
         {
            this.setModalHolder();
         }
         else
         {
            this._container.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         }
      }
      
      private function setupMenuHolder() : void
      {
         this.menuHolder = new Sprite();
         this._container.addChild(this.menuHolder);
      }
      
      public function hasMenu(param1:DisplayObject) : Boolean
      {
         return this.map[param1];
      }
      
      public function set factory(param1:com.qb9.gaturro.view.gui.contextual.ContextualMenuFactory) : void
      {
         this._factory = param1;
      }
      
      public function addMenu(param1:String, param2:DisplayObject, param3:Object = null) : void
      {
         var _loc4_:AbstractContextualMenu = this._factory.build(param1,param2,param3);
         this.menuHolder.addChild(_loc4_);
         this.place(param2,_loc4_);
         this.map[param2] = _loc4_;
         this.modalHolder.visible = true;
         if(!this.modalHolder.hasEventListener(MouseEvent.ROLL_OVER))
         {
            this.modalHolder.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         }
         if(!this.modalHolder.hasEventListener(MouseEvent.ROLL_OUT))
         {
            this.modalHolder.addEventListener(MouseEvent.ROLL_OUT,this.onRoolOut);
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this._container.removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.setModalHolder();
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function dispose() : void
      {
         this.reset();
         this.map = null;
         this._disposed = true;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         this.clean();
      }
      
      private function doRemoving(param1:DisplayObject) : void
      {
         var _loc2_:AbstractContextualMenu = this.map[param1];
         _loc2_.dispose();
         delete this.map[param1];
         this.menuHolder.removeChild(_loc2_);
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         this._cursor.pointer = Cursor.HAND;
      }
      
      private function onRoolOut(param1:MouseEvent) : void
      {
         this._cursor.pointer = Cursor.ARROW;
      }
      
      private function setModalHolder() : void
      {
         this.modalHolder = new Sprite();
         this.modalHolder.visible = false;
         this.modalHolder.addEventListener(MouseEvent.CLICK,this.onClick);
         this.modalHolder.graphics.beginFill(0,0);
         this.modalHolder.graphics.drawRect(0,0,this._container.stage.stageWidth,this._container.stage.stageHeight);
         this._container.addChild(this.modalHolder);
      }
      
      public function set cursor(param1:Cursor) : void
      {
         this._cursor = param1;
      }
   }
}
