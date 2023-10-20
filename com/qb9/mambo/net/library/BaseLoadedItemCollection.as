package com.qb9.mambo.net.library
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.lang.AbstractMethodError;
   import com.qb9.flashlib.lang.foreach;
   import flash.utils.setTimeout;
   
   public class BaseLoadedItemCollection implements IDisposable
   {
       
      
      private var items:Object;
      
      private var queues:Object;
      
      private var execute:Function;
      
      private var loading:Object;
      
      public function BaseLoadedItemCollection(param1:Function)
      {
         this.items = {};
         this.loading = {};
         this.queues = {};
         super();
         this.execute = param1;
      }
      
      protected function getPackName(param1:String) : String
      {
         return param1;
      }
      
      protected function loaded(param1:String, param2:Object) : void
      {
         this.items[param1] = param2;
         foreach(this.queues[param1],this.executeItem);
         delete this.queues[param1];
         delete this.loading[param1];
      }
      
      protected function load(param1:String) : void
      {
         throw new AbstractMethodError();
      }
      
      private function executeItem(param1:Item) : void
      {
         var _loc2_:Array = [param1.callback,this.items[param1.pack]];
         if(param1.name !== null)
         {
            _loc2_.push(param1.name);
         }
         if(param1.data !== null)
         {
            _loc2_.push(param1.data);
         }
         this.execute.apply(this,_loc2_);
      }
      
      protected function getItemName(param1:String) : String
      {
         return null;
      }
      
      public function cleanCache() : void
      {
         this.items = {};
      }
      
      public function fetch(param1:String, param2:Function, param3:Object = null) : void
      {
         var _loc4_:String = this.getPackName(param1);
         var _loc5_:Item = new Item(param2,_loc4_,this.getItemName(param1),param3);
         if(!this.loading[_loc4_] && !this.items[_loc4_])
         {
            this.loading[_loc4_] = true;
            this.load(_loc4_);
         }
         if(!this.loading[_loc4_])
         {
            setTimeout(this.executeItem,1,_loc5_);
         }
         else if(_loc4_ in this.queues)
         {
            this.queues[_loc4_].push(_loc5_);
         }
         else
         {
            this.queues[_loc4_] = [_loc5_];
         }
      }
      
      private function disposeList(param1:Object) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in param1)
         {
            if(_loc2_ is IDisposable)
            {
               IDisposable(_loc2_).dispose();
            }
         }
      }
      
      public function dispose() : void
      {
         this.disposeList(this.items);
         this.disposeList(this.queues);
         this.queues = this.loading = this.items = null;
         this.execute = null;
      }
   }
}

import com.qb9.flashlib.interfaces.IDisposable;

final class Item implements IDisposable
{
    
   
   private var data:Object;
   
   private var callback:Function;
   
   private var pack:String;
   
   private var name:String;
   
   public function Item(param1:Function, param2:String, param3:String, param4:Object)
   {
      super();
      this.callback = param1;
      this.pack = param2;
      this.name = param3;
      this.data = param4;
   }
   
   public function dispose() : void
   {
      this.callback = null;
      this.data = null;
   }
}
