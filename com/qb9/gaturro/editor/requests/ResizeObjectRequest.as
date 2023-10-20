package com.qb9.gaturro.editor.requests
{
   import com.qb9.flashlib.geom.Size;
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public final class ResizeObjectRequest extends BaseMamboRequest
   {
       
      
      private var size:Size;
      
      private var id:Number;
      
      public function ResizeObjectRequest(param1:Number, param2:Size)
      {
         super("ObjectCreateOrUpdateRequest");
         this.id = param1;
         this.size = param2;
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setInteger("id",this.id);
         param1.setIntegerArray("size",this.size.toArray());
      }
   }
}
