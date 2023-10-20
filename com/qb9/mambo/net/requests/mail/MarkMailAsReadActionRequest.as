package com.qb9.mambo.net.requests.mail
{
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public final class MarkMailAsReadActionRequest extends BaseMamboRequest
   {
       
      
      private var id:Number;
      
      public function MarkMailAsReadActionRequest(param1:Number)
      {
         super();
         this.id = param1;
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setInteger("mailId",this.id);
      }
   }
}
