package com.qb9.gaturro.net.requests.catalog
{
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public final class CatalogDataRequest extends BaseMamboRequest
   {
       
      
      private var name:String;
      
      public function CatalogDataRequest(param1:String)
      {
         super("CatalogDataRequest");
         this.name = param1;
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setString("name",this.name);
      }
   }
}
