package com.qb9.gaturro.net.requests.ranking
{
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public class RankingDataRequest extends BaseMamboRequest
   {
       
      
      private var game:String;
      
      private var onlyFriends:Boolean;
      
      private var range:String;
      
      private var n:int;
      
      public function RankingDataRequest(param1:String, param2:String, param3:Boolean, param4:int)
      {
         super("RankingDataRequest");
         this.game = param1;
         this.range = param2;
         this.onlyFriends = param3;
         this.n = param4;
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setString("gameId",this.game);
         param1.setString("timeRangeId",this.range);
         param1.setBoolean("friends",this.onlyFriends);
         param1.setInteger("nRegs",this.n);
      }
   }
}
