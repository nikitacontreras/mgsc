package com.qb9.mambo.net.requests.room
{
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   internal class ChangeAvatarStatusActionRequest extends BaseMamboRequest
   {
       
      
      private var status:Boolean;
      
      private var silent:Boolean;
      
      public function ChangeAvatarStatusActionRequest(param1:Boolean, param2:Boolean)
      {
         super("ChangeAvatarStatusActionRequest");
         this.status = param1;
         this.silent = param2;
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setBoolean("inactive",!this.status);
         param1.setBoolean("silent",this.silent);
      }
   }
}
