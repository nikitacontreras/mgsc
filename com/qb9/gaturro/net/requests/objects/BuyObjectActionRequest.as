package com.qb9.gaturro.net.requests.objects
{
   import com.qb9.flashlib.lang.map;
   import com.qb9.gaturro.net.requests.SecureMamboRequest;
   import com.qb9.mambo.core.attributes.CustomAttribute;
   import com.qb9.mambo.user.inventory.Inventory;
   import com.qb9.mines.mobject.Mobject;
   
   public final class BuyObjectActionRequest extends SecureMamboRequest
   {
       
      
      private var attrs:Array;
      
      private var inventory:String;
      
      private var blocks:Boolean;
      
      private var name:String;
      
      private var catalog:String;
      
      private var giverId:Number;
      
      public function BuyObjectActionRequest(param1:Number, param2:String, param3:String, param4:Boolean = false, param5:Array = null, param6:String = null)
      {
         super("AcquireObjectActionRequest");
         this.giverId = param1;
         this.name = param2;
         this.blocks = param4;
         this.inventory = param6;
         this.attrs = param5;
         this.catalog = param3;
      }
      
      private function attrToMobject(param1:CustomAttribute) : Mobject
      {
         return param1.toMobject();
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setString("giverId",String(this.giverId));
         param1.setString("name",this.name);
         param1.setString("catalogName",this.catalog);
         param1.setBoolean("blockingHint",this.blocks);
         param1.setInteger("amount",1);
         if(Boolean(this.inventory) && this.inventory !== Inventory.DEFAULT)
         {
            param1.setString("inventoryName",this.inventory);
         }
         if(this.attrs)
         {
            param1.setMobjectArray("customAttributes",map(this.attrs,this.attrToMobject));
         }
         applyValidationDigest(param1);
      }
   }
}
