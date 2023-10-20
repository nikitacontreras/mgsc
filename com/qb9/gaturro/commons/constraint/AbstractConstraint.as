package com.qb9.gaturro.commons.constraint
{
   import flash.errors.IllegalOperationError;
   
   public class AbstractConstraint implements IConstraint
   {
       
      
      private var _disposed:Boolean;
      
      protected var observer:Function;
      
      private var _invert:Boolean;
      
      protected var weak:Boolean;
      
      public function AbstractConstraint(param1:Boolean)
      {
         super();
         this.weak = param1;
      }
      
      protected function doInvert(param1:Boolean) : Boolean
      {
         return this._invert ? !param1 : param1;
      }
      
      public function accomplish(param1:* = null) : Boolean
      {
         throw new IllegalOperationError("This is an abstract method and couldn\'t be instatiated.");
      }
      
      public function set invert(param1:Boolean) : void
      {
         this._invert = param1;
      }
      
      public function unobserve() : void
      {
         this.observer = null;
      }
      
      public function dispose() : void
      {
         this._disposed = true;
      }
      
      public function observe(param1:Function) : void
      {
         this.observer = param1;
      }
      
      public function setData(param1:*) : void
      {
      }
      
      protected function changed() : void
      {
         if(this.observer != null)
         {
            this.observer();
         }
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
   }
}
