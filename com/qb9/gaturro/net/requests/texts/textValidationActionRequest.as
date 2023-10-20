package com.qb9.gaturro.net.requests.texts
{
   import com.qb9.gaturro.net.requests.SecureMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public final class textValidationActionRequest extends SecureMamboRequest
   {
       
      
      private var text:String;
      
      public function textValidationActionRequest(param1:String)
      {
         super("TextValidationActionRequest");
         this.text = param1;
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setString("text",this.text);
         applyValidationDigest(param1);
      }
   }
}
