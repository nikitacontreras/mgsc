package fl.video
{
   public class ReconnectClient
   {
       
      
      public var owner:fl.video.NCManager;
      
      public function ReconnectClient(param1:fl.video.NCManager)
      {
         super();
         this.owner = param1;
      }
      
      public function close() : void
      {
      }
      
      public function onBWDone(... rest) : void
      {
         this.owner.flvplayback_internal::onReconnected();
      }
   }
}
