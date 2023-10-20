package fl.video
{
   import flash.net.NetConnection;
   
   public class ConnectClient
   {
       
      
      public var owner:fl.video.NCManager;
      
      public var nc:NetConnection;
      
      public var connIndex:uint;
      
      public var pending:Boolean;
      
      public function ConnectClient(param1:fl.video.NCManager, param2:NetConnection, param3:uint = 0)
      {
         super();
         this.owner = param1;
         this.nc = param2;
         this.connIndex = param3;
         this.pending = false;
      }
      
      public function close() : void
      {
      }
      
      public function onBWDone(... rest) : void
      {
         var _loc2_:Number = NaN;
         if(rest.length > 0)
         {
            _loc2_ = Number(rest[0]);
         }
         this.owner.flvplayback_internal::onConnected(this.nc,_loc2_);
      }
      
      public function onBWCheck(... rest) : Number
      {
         return ++this.owner.flvplayback_internal::_payload;
      }
   }
}
