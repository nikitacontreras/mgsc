package com.qb9.gaturro.net.requests.multiplayer
{
   import com.qb9.mines.mobject.Mobject;
   
   public final class MultiplayerActionRequestList extends MultiplayerActionRequestBase
   {
       
      
      private const _method:String = "list";
      
      private var game:String;
      
      public function MultiplayerActionRequestList(param1:String)
      {
         super(this._method);
         this.game = param1;
      }
      
      override protected function build(param1:Mobject) : void
      {
         super.build(param1);
         param1.setString("game",this.game);
      }
   }
}
