package com.qb9.gaturro.commons.manager.counter
{
   import flash.errors.IllegalOperationError;
   
   public class AbstractCounterManager
   {
       
      
      public function AbstractCounterManager()
      {
         super();
      }
      
      public function reached(param1:String, param2:int) : Boolean
      {
         throw new IllegalOperationError("This is an abstractad method and should be instatiated by subclass.");
      }
      
      public function start(param1:String, param2:String) : void
      {
         throw new IllegalOperationError("This is an abstractad method and should be instatiated by subclass.");
      }
      
      public function register(param1:String, param2:String) : void
      {
         throw new IllegalOperationError("This is an abstractad method and should be instatiated by subclass.");
      }
      
      public function reachedMax(param1:String) : Boolean
      {
         throw new IllegalOperationError("This is an abstractad method and should be instatiated by subclass.");
      }
      
      public function getAmount(param1:String) : int
      {
         throw new IllegalOperationError("This is an abstractad method and should be instatiated by subclass.");
      }
      
      public function exist(param1:String) : Boolean
      {
         throw new IllegalOperationError("This is an abstractad method and should be instatiated by subclass.");
      }
      
      public function increase(param1:String, param2:int = 1) : void
      {
         throw new IllegalOperationError("This is an abstractad method and should be instatiated by subclass.");
      }
      
      public function equal(param1:String, param2:int) : Boolean
      {
         throw new IllegalOperationError("This is an abstractad method and should be instatiated by subclass.");
      }
      
      public function unregister(param1:String, param2:String) : void
      {
         throw new IllegalOperationError("This is an abstractad method and should be instatiated by subclass.");
      }
      
      public function decrease(param1:String, param2:int = 1) : void
      {
         throw new IllegalOperationError("This is an abstractad method and should be instatiated by subclass.");
      }
   }
}
