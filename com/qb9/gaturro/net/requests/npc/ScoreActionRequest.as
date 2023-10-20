package com.qb9.gaturro.net.requests.npc
{
   import com.qb9.gaturro.net.requests.SecureMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public final class ScoreActionRequest extends SecureMamboRequest
   {
       
      
      private var game:String;
      
      private var score:int;
      
      private var sessionScore:int;
      
      public function ScoreActionRequest(param1:int, param2:Number, param3:String)
      {
         super("ScoreActionRequest");
         this.score = param1;
         this.sessionScore = int(param2);
         this.game = param3;
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setInteger("score",this.score);
         param1.setInteger("sessionScore",this.sessionScore);
         param1.setString("game",this.game);
         applyValidationDigest(param1);
      }
   }
}
