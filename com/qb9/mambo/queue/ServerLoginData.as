package com.qb9.mambo.queue
{
   import com.qb9.mambo.net.mobject.MobjectBuildable;
   import com.qb9.mines.mobject.Mobject;
   
   public final class ServerLoginData implements MobjectBuildable
   {
       
      
      private var _port:int;
      
      private var _host:String;
      
      private var _hash:String;
      
      private var _game:String;
      
      public function ServerLoginData(param1:String)
      {
         super();
         this._game = param1;
      }
      
      public function get port() : int
      {
         return this._port;
      }
      
      public function get host() : String
      {
         return this._host;
      }
      
      public function get game() : String
      {
         return this._game;
      }
      
      public function buildFromMobject(param1:Mobject) : void
      {
         this._host = param1.getString("host");
         this._port = param1.getInteger("port");
         this._hash = param1.getString("hash");
      }
      
      public function get hash() : String
      {
         return this._hash;
      }
   }
}
