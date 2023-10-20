package com.qb9.mambo.core.objects
{
   import com.qb9.flashlib.events.QEventDispatcher;
   import com.qb9.flashlib.lang.map;
   import com.qb9.flashlib.logs.Logger;
   import flash.utils.getQualifiedClassName;
   
   public class MamboObject extends QEventDispatcher
   {
      
      private static var logger:Logger;
       
      
      protected var disposed:Boolean = false;
      
      public function MamboObject()
      {
         super();
      }
      
      public static function get currentTime() : String
      {
         return new Date().toUTCString().split(" ")[3];
      }
      
      protected function get dumpVars() : Array
      {
         return [];
      }
      
      private function get className() : String
      {
         return getQualifiedClassName(this).split("::")[1];
      }
      
      private function log(param1:String, param2:Array) : void
      {
         param2.unshift(currentTime,">",this.className,">");
         logger = logger || Logger.getLogger("mambo");
         logger[param1].apply(null,param2);
      }
      
      private function readAttr(param1:String) : Object
      {
         var _loc2_:Object = this[param1];
         if(_loc2_ is String)
         {
            _loc2_ = "\"" + _loc2_ + "\"";
         }
         return " " + param1 + "=" + _loc2_;
      }
      
      protected function error(... rest) : void
      {
         this.log("error",rest);
      }
      
      override public function toString() : String
      {
         return "[" + this.className + map(this.dumpVars,this.readAttr).join("") + "]";
      }
      
      protected function info(... rest) : void
      {
         this.log("info",rest);
      }
      
      protected function debug(... rest) : void
      {
         this.log("debug",rest);
      }
      
      protected function warning(... rest) : void
      {
         this.log("warning",rest);
      }
      
      override public function dispose() : void
      {
         if(this.disposed)
         {
            return this.warning("Trying to dispose a disposed object:",this);
         }
         this.disposed = true;
         super.dispose();
      }
   }
}
