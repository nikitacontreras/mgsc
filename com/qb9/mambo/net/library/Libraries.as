package com.qb9.mambo.net.library
{
   import flash.utils.Dictionary;
   
   public class Libraries extends BaseLoadedItemCollection
   {
       
      
      protected var root:String;
      
      protected var shared:Boolean;
      
      private var names:Dictionary;
      
      public function Libraries(param1:String = ".", param2:Boolean = false)
      {
         this.names = new Dictionary();
         super(this.execute);
         if(Boolean(param1) && param1.slice(-1) !== "/")
         {
            param1 += "/";
         }
         this.root = param1;
         this.shared = param2;
      }
      
      override protected function load(param1:String) : void
      {
         var _loc2_:Library = this.getLibraryObject(param1);
         _loc2_.addEventListener(LibraryEvent.LOADED,this.libraryReady);
         _loc2_.addEventListener(LibraryEvent.LOAD_FAILED,this.libraryReady);
         this.names[_loc2_] = param1;
      }
      
      protected function getLibraryObject(param1:String) : Library
      {
         return new Library(this.root,this.shared,param1);
      }
      
      private function libraryReady(param1:LibraryEvent) : void
      {
         var _loc2_:Library = param1.target as Library;
         _loc2_.removeEventListener(LibraryEvent.LOADED,this.libraryReady);
         _loc2_.removeEventListener(LibraryEvent.LOAD_FAILED,this.libraryReady);
         loaded(this.names[_loc2_],_loc2_);
      }
      
      override protected function getItemName(param1:String) : String
      {
         if(param1 == null)
         {
            return "";
         }
         return param1.split(".")[1];
      }
      
      protected function execute(param1:Function, param2:Library, param3:String = null, param4:Object = null) : void
      {
         var _loc5_:Object = param2.loadFailed ? null : param2.getItem(param3);
         if(param4 === null)
         {
            param1(_loc5_);
         }
         else
         {
            param1(_loc5_,param4);
         }
      }
      
      override protected function getPackName(param1:String) : String
      {
         if(param1 == null)
         {
            return "";
         }
         return param1.split(".")[0];
      }
      
      override public function dispose() : void
      {
         this.names = null;
         super.dispose();
      }
   }
}
