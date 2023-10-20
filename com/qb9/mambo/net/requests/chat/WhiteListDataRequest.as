package com.qb9.mambo.net.requests.chat
{
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public final class WhiteListDataRequest extends BaseMamboRequest
   {
       
      
      private var name:String;
      
      public function WhiteListDataRequest(param1:String = null)
      {
         super();
         this.name = param1;
      }
      
      override protected function build(param1:Mobject) : void
      {
         if(this.name)
         {
            param1.setString("name",this.name);
         }
      }
   }
}
