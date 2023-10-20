package com.qb9.mambo.net.requests.queue
{
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public final class ForceStartGameActionRequest extends BaseMamboRequest
   {
       
      
      private var name:String;
      
      private var id:Number;
      
      public function ForceStartGameActionRequest(param1:Number, param2:String)
      {
         super();
         this.id = param1;
         this.name = param2;
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setInteger("queueId",this.id);
         param1.setString("name",this.name);
      }
   }
}
