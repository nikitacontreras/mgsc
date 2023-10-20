package com.qb9.gaturro.net.requests.multiplayer
{
   import com.qb9.mines.mobject.Mobject;
   
   public final class MultiplayerActionRequestDisconnect extends MultiplayerActionRequestBase
   {
       
      
      private const _method:String = "out";
      
      private var promoter:String;
      
      private var game:String;
      
      public function MultiplayerActionRequestDisconnect(param1:String, param2:String = null)
      {
         super(this._method);
         this.game = param1;
         this.promoter = param2;
      }
      
      override protected function build(param1:Mobject) : void
      {
         super.build(param1);
         param1.setString("game",this.game);
         if(this.promoter)
         {
            param1.setString("promoter",this.promoter);
         }
      }
   }
}
