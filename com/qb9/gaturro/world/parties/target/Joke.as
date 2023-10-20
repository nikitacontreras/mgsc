package com.qb9.gaturro.world.parties.target
{
   public class Joke extends Target
   {
       
      
      public function Joke(param1:Object)
      {
         super(param1);
      }
      
      override public function check(param1:Object) : void
      {
         if(!targetDone && checkAttr(param1,"action","joke"))
         {
            confirm();
         }
      }
   }
}
