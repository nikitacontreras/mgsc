package com.qb9.mambo.view.world.util
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import flash.utils.Dictionary;
   
   public class TwoWayLink implements IDisposable
   {
       
      
      private var dict:Dictionary;
      
      public function TwoWayLink()
      {
         this.dict = new Dictionary(true);
         super();
      }
      
      public function add(param1:Object, param2:Object) : void
      {
         this.dict[param1] = param2;
         this.dict[param2] = param1;
      }
      
      public function remove(param1:Object) : void
      {
         var _loc2_:Object = this.dict[param1];
         if(_loc2_)
         {
            delete this.dict[_loc2_];
         }
         delete this.dict[param1];
      }
      
      public function getItem(param1:Object) : Object
      {
         return this.dict[param1];
      }
      
      public function dispose() : void
      {
         this.dict = null;
      }
   }
}
