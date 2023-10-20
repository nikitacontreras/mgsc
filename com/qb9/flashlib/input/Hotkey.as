package com.qb9.flashlib.input
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   
   public class Hotkey implements IDisposable
   {
      
      public static const DEFAULT_EVENT:String = KeyboardEvent.KEY_DOWN;
       
      
      protected var context:DisplayObjectContainer;
      
      protected var registry:Object;
      
      public var on:Boolean = true;
      
      public function Hotkey(param1:DisplayObjectContainer)
      {
         this.registry = {};
         super();
         this.context = param1;
      }
      
      public function add(param1:String, param2:Function, param3:String = null) : void
      {
         var _loc4_:String = null;
         var _loc5_:Shortcut = null;
         param3 ||= DEFAULT_EVENT;
         if(!this.registry[param3])
         {
            if(this.needsStageBinding(param3))
            {
               this.stage.addEventListener(param3,this.checkFromStage);
            }
            else
            {
               this.context.addEventListener(param3,this.check);
            }
            this.registry[param3] = {};
         }
         for each(_loc4_ in param1.split(/\s*,\s*/))
         {
            _loc5_ = new Shortcut(_loc4_);
            this.registry[param3][_loc5_.uid] = param2;
         }
      }
      
      protected function needsStageBinding(param1:String) : Boolean
      {
         return param1 == KeyboardEvent.KEY_DOWN || param1 == KeyboardEvent.KEY_UP;
      }
      
      public function dispose() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in this.registry)
         {
            if(this.needsStageBinding(_loc1_))
            {
               this.stage.removeEventListener(_loc1_,this.checkFromStage);
            }
            else
            {
               this.context.removeEventListener(_loc1_,this.check);
            }
         }
         this.registry = null;
         this.context = null;
      }
      
      protected function check(param1:Event) : void
      {
         if(!this.on)
         {
            return;
         }
         var _loc2_:Shortcut = Shortcut.fromEvent(param1);
         var _loc3_:Function = (this.registry[param1.type] && this.registry[param1.type][_loc2_.uid]) as Function;
         if(_loc3_ === null)
         {
            return;
         }
         if(_loc3_.length)
         {
            _loc3_(param1);
         }
         else
         {
            _loc3_();
         }
      }
      
      public function remove(param1:String, param2:String = null) : void
      {
         var _loc3_:String = null;
         var _loc4_:Shortcut = null;
         param2 ||= DEFAULT_EVENT;
         if(this.registry[param2])
         {
            for each(_loc3_ in param1.split(/\s*,\s*/))
            {
               _loc4_ = new Shortcut(_loc3_);
               delete this.registry[param2][_loc4_.uid];
            }
         }
      }
      
      protected function checkFromStage(param1:Event) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         if(this.on && _loc2_ && (_loc2_ === this.stage || this.context.contains(_loc2_)))
         {
            this.check(param1);
         }
      }
      
      protected function get stage() : Stage
      {
         return this.context.stage;
      }
   }
}
