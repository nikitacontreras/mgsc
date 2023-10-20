package com.qb9.gaturro.net.requests.report
{
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public final class ReportIdeaActionRequest extends BaseMamboRequest
   {
       
      
      private var clientData:String;
      
      private var message:String;
      
      public function ReportIdeaActionRequest(param1:String, param2:String = "")
      {
         super("ReportErrorActionRequest");
         this.message = param1;
         this.clientData = param2;
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setString("title","Idea");
         param1.setString("description",this.message);
         param1.setString("clientData",this.clientData);
      }
   }
}
