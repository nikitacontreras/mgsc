package com.qb9.mambo.net.requests.report
{
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public final class ReportErrorActionRequest extends BaseMamboRequest
   {
       
      
      private var clientData:String;
      
      private var message:String;
      
      private var title:String;
      
      public function ReportErrorActionRequest(param1:String, param2:String = "Error", param3:String = "")
      {
         super();
         this.title = param2;
         this.message = param1;
         this.clientData = param3;
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setString("title",this.title);
         param1.setString("description",this.message);
         param1.setString("clientData",this.clientData);
      }
   }
}
