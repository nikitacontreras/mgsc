package com.qb9.gaturro.net
{
   import com.qb9.gaturro.net.library.GaturroLibrary;
   import com.qb9.mambo.net.library.Libraries;
   import com.qb9.mambo.net.library.Library;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.system.Security;
   
   public final class GaturroLibraries extends Libraries
   {
       
      
      private var queue:Array;
      
      private var source:Sprite;
      
      public function GaturroLibraries(param1:Sprite)
      {
         this.queue = [];
         super("assets",true);
         this.source = param1;
         this.init();
      }
      
      private function init() : void
      {
         this.source.addEventListener(Event.ENTER_FRAME,this.step);
      }
      
      override protected function getLibraryObject(param1:String) : Library
      {
         return new GaturroLibrary(root,shared,param1);
      }
      
      override protected function execute(param1:Function, param2:Library, param3:String = null, param4:Object = null) : void
      {
      }
      
      private function step(param1:Event) : void
      {
         var _loc3_:Item = null;
         var _loc2_:int = int(this.queue.length);
         while(_loc2_--)
         {
            _loc3_ = this.queue[_loc2_] as Item;
            if(_loc3_.step())
            {
               this.queue.splice(_loc2_,1);
               _loc3_.dispose();
            }
         }
      }
      
      override protected function load(param1:String) : void
      {
         Security.allowDomain("*");
         Security.allowInsecureDomain("*");
         super.load(param1);
      }
      
      override public function dispose() : void
      {
         this.source.removeEventListener(Event.ENTER_FRAME,this.step);
         this.source = null;
         super.dispose();
      }
   }
}

import com.qb9.gaturro.view.gui.catalog.items.CatalogModalItemView;
import com.qb9.mambo.net.library.Library;
import com.qb9.mambo.user.inventory.InventorySceneObject;
import flash.display.DisplayObject;

class Item
{
   
   private static const WAIT_FRAMES:uint = 2;
    
   
   private var data:Object;
   
   private var callback:Function;
   
   private var missing:int = 2;
   
   private var obj:DisplayObject;
   
   public function Item(param1:Function, param2:DisplayObject, param3:Object, param4:Library)
   {
      super();
      this.callback = param1;
      this.obj = param2;
      this.data = param3;
      if(this.data && !(param3 is InventorySceneObject) && !(param3 is CatalogModalItemView))
      {
         this.data.lib = param4;
      }
   }
   
   public function step() : Boolean
   {
      if("process" in this.obj && Boolean(this.missing--))
      {
         return false;
      }
      this.execute();
      return true;
   }
   
   private function execute() : void
   {
      if(this.data === null)
      {
         this.callback(this.obj);
      }
      else
      {
         this.callback(this.obj,this.data);
      }
   }
   
   public function dispose() : void
   {
      this.obj = null;
      this.callback = null;
      this.data = null;
   }
}
