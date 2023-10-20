package com.qb9.mambo.net.server
{
   import com.qb9.mambo.net.mobject.MobjectBuildable;
   import com.qb9.mines.mobject.Mobject;
   import flash.utils.getTimer;
   
   public class ServerData implements MobjectBuildable
   {
       
      
      private var _extensionVersion:String;
      
      private var _time:Number;
      
      private var _version:String;
      
      public function ServerData()
      {
         super();
      }
      
      public function get extensionVersion() : String
      {
         return this._extensionVersion;
      }
      
      public function get time() : Number
      {
         return this._time + getTimer();
      }
      
      public function get date() : Date
      {
         return new Date(this.time);
      }
      
      public function buildFromMobject(param1:Mobject) : void
      {
         this._time = Number(param1.getString("time")) - getTimer();
         this._version = param1.getString("version");
         this._extensionVersion = param1.getString("extensionVersion");
      }
      
      public function get version() : String
      {
         return this._version;
      }
   }
}
