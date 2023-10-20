package com.qb9.gaturro.view.gui.interaction.utils
{
   import com.qb9.gaturro.view.components.banner.boca.BocaPenales;
   
   public class FutbolScoreManager
   {
       
      
      public var team_b:int = 0;
      
      public var penalty_remaining_a:int = 5;
      
      public var penalty_remaining_b:int = 5;
      
      public var suddenDeath:Boolean;
      
      public var team_a:int = 0;
      
      public function FutbolScoreManager()
      {
         super();
      }
      
      public function isGG() : String
      {
         var _loc1_:int = Math.abs(this.team_a - this.team_b);
         if(this.team_a > this.team_b)
         {
            if(_loc1_ > this.penalty_remaining_b)
            {
               return BocaPenales.TEAM_A;
            }
         }
         else if(this.team_b > this.team_a)
         {
            if(_loc1_ > this.penalty_remaining_a)
            {
               return BocaPenales.TEAM_B;
            }
         }
         if(this.penalty_remaining_a == 0 && this.penalty_remaining_b == 0)
         {
            this.suddenDeath = true;
            this.penalty_remaining_a = 1;
            this.penalty_remaining_b = 1;
         }
         return null;
      }
      
      public function getTeamScore(param1:String) : int
      {
         if(param1 == BocaPenales.TEAM_A)
         {
            return this.team_a;
         }
         return this.team_b;
      }
   }
}
