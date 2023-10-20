package com.qb9.gaturro.commons.net.delegate
{
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import com.qb9.gaturro.commons.event.EventManager;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   
   public class AbstractRequestDelegate implements ICheckableDisposable
   {
       
      
      private var _delegate:Function;
      
      private var eventTarget:EventDispatcher;
      
      private var eventManager:EventManager;
      
      private var _disposed:Boolean;
      
      public function AbstractRequestDelegate(param1:Function, param2:EventManager, param3:EventDispatcher)
      {
         super();
         this.eventTarget = param3;
         this.eventManager = param2;
         this._delegate = param1;
         this.setup();
      }
      
      public function handleError(param1:ErrorEvent) : void
      {
         trace("[ERROR]  AbstractRequestDelegate > handleError > e.text: " + param1.text);
         this.dispose();
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function handleDelegate(param1:Event) : void
      {
         this.dispose();
      }
      
      protected function get delegate() : Function
      {
         return this._delegate;
      }
      
      private function setup() : void
      {
         this.eventManager.addEventListener(this.eventTarget,Event.COMPLETE,this.handleDelegate);
         this.eventManager.addEventListener(this.eventTarget,ErrorEvent.ERROR,this.handleError);
         this.eventManager.addEventListener(this.eventTarget,IOErrorEvent.IO_ERROR,this.handleError);
         this.eventManager.addEventListener(this.eventTarget,IOErrorEvent.NETWORK_ERROR,this.handleError);
      }
      
      public function dispose() : void
      {
         this.eventManager.removeAllFromTarget(this.eventTarget);
         this._delegate = null;
         this.eventManager = null;
         this._disposed = true;
      }
   }
}
