package com.qb9.gaturro.editor.requests
{
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public final class ChangeObjectBlocksRequest extends BaseMamboRequest
   {
       
      
      private var id:Number;
      
      private var blocks:Boolean;
      
      public function ChangeObjectBlocksRequest(param1:Number, param2:Boolean)
      {
         super("ObjectCreateOrUpdateRequest");
         this.id = param1;
         this.blocks = param2;
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setInteger("id",this.id);
         param1.setBoolean("blockingHint",this.blocks);
      }
   }
}
