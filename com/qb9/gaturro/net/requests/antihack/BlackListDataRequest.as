package com.qb9.gaturro.net.requests.antihack
{
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public class BlackListDataRequest extends BaseMamboRequest
   {
       
      
      private var name:String;
      
      public function BlackListDataRequest(param1:Boolean)
      {
         super("BlackListDataRequest");
         if(param1)
         {
            this.name = "invalid.avatar_objects";
         }
         else
         {
            this.name = "invalid.avatar_objects.attribute";
         }
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setString("name",this.name);
      }
   }
}
