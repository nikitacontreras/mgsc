package com.qb9.mambo.net.requests.buddies
{
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public final class UnblockBuddyActionRequest extends BaseMamboRequest
   {
       
      
      private var username:String;
      
      public function UnblockBuddyActionRequest(param1:String)
      {
         super();
         this.username = param1;
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setString("username",this.username);
      }
   }
}
