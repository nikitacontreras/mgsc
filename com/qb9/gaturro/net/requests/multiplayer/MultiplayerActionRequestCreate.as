package com.qb9.gaturro.net.requests.multiplayer
{
   import com.qb9.mines.mobject.Mobject;
   
   public final class MultiplayerActionRequestCreate extends MultiplayerActionRequestBase
   {
       
      
      private const _method:String = "creation";
      
      private var promoter:String;
      
      private var maxUsers:int;
      
      private var game:String;
      
      public function MultiplayerActionRequestCreate(param1:String, param2:String = null, param3:int = 2)
      {
         super(this._method);
         this.game = param1;
         this.promoter = param2;
         this.maxUsers = param3;
      }
      
      override protected function build(param1:Mobject) : void
      {
         super.build(param1);
         param1.setString("game",this.game);
         if(this.promoter)
         {
            param1.setString("promoter",this.promoter);
         }
         param1.setInteger("maxUsers",this.maxUsers);
      }
   }
}
