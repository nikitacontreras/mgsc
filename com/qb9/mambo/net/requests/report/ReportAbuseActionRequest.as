package com.qb9.mambo.net.requests.report
{
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public final class ReportAbuseActionRequest extends BaseMamboRequest
   {
       
      
      private var user:String;
      
      private var message:String;
      
      public function ReportAbuseActionRequest(param1:String, param2:String = null)
      {
         super();
         this.message = param1;
         this.user = param2;
      }
      
      override protected function build(param1:Mobject) : void
      {
         if(this.user)
         {
            param1.setString("bully",this.user);
         }
         param1.setString("description",this.message);
      }
   }
}
