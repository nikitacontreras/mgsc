package com.qb9.gaturro.editor.requests
{
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public final class RenameObjectRequest extends BaseMamboRequest
   {
       
      
      private var name:String;
      
      private var id:Number;
      
      public function RenameObjectRequest(param1:Number, param2:String)
      {
         super("ObjectCreateOrUpdateRequest");
         this.id = param1;
         this.name = param2;
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setInteger("id",this.id);
         param1.setString("name",this.name);
      }
   }
}
