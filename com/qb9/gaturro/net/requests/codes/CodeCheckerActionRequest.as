package com.qb9.gaturro.net.requests.codes
{
   import com.qb9.gaturro.net.requests.SecureMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public final class CodeCheckerActionRequest extends SecureMamboRequest
   {
       
      
      private var campaign:Number;
      
      private var username:String;
      
      private var code:String;
      
      public function CodeCheckerActionRequest(param1:String, param2:String)
      {
         super("CodeCheckerActionRequest");
         this.code = param1;
         this.username = param2;
         this.campaign = 1;
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setString("code",this.code);
         param1.setString("username",this.username);
         param1.setInteger("campaign",this.campaign);
         applyValidationDigest(param1);
      }
   }
}
