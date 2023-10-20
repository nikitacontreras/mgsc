package com.qb9.gaturro.net.requests.multiplayer
{
   import com.qb9.mines.mobject.Mobject;
   
   public final class MultiplayerActionRequestListBySlot extends MultiplayerActionRequestBase
   {
       
      
      private const _method:String = "listBySlot";
      
      private var promoter:String;
      
      private var game:String;
      
      public function MultiplayerActionRequestListBySlot(param1:String, param2:String)
      {
         super(this._method);
         this.game = param1;
         this.promoter = param2;
      }
      
      override protected function build(param1:Mobject) : void
      {
         super.build(param1);
         param1.setString("game",this.game);
         param1.setString("promoter",this.promoter);
      }
   }
}
