package com.qb9.mambo.net.requests.mail
{
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public final class DeleteMailActionRequest extends BaseMamboRequest
   {
       
      
      private var ids:Array;
      
      public function DeleteMailActionRequest(param1:Object)
      {
         super();
         if(param1 is Number)
         {
            this.ids = [param1];
         }
         if(param1 is Array)
         {
            this.ids = param1 as Array;
         }
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setIntegerArray("mails",this.ids);
      }
   }
}
