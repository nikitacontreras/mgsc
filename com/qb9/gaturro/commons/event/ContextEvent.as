package com.qb9.gaturro.commons.event
{
   import flash.events.Event;
   
   public class ContextEvent extends Event
   {
      
      public static const ADDED:String = "added";
       
      
      private var _instance:Object;
      
      private var _instanceType:Class;
      
      private var _id:String;
      
      public function ContextEvent(param1:String, param2:Object, param3:Class, param4:String = "")
      {
         super(param1);
         this._id = param4;
         this._instanceType = param3;
         this._instance = param2;
      }
      
      override public function toString() : String
      {
         return formatToString("ContextEvent","type","bubbles","cancelable","eventPhase");
      }
      
      public function get instanceType() : Class
      {
         return this._instanceType;
      }
      
      public function get instance() : Object
      {
         return this._instance;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      override public function clone() : Event
      {
         return new ContextEvent(type,this._instance,this._instanceType,this._id);
      }
   }
}
