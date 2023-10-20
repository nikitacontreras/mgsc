package com.qb9.gaturro.net.requests.multiplayer
{
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public class MultiplayerActionRequestBase extends BaseMamboRequest
   {
       
      
      private var method:String = "";
      
      public function MultiplayerActionRequestBase(param1:String)
      {
         super("MultiplayerActionRequest");
         this.method = param1;
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setString("method",this.method);
      }
   }
}
