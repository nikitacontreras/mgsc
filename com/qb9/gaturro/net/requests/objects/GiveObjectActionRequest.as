package com.qb9.gaturro.net.requests.objects
{
   import com.qb9.flashlib.lang.map;
   import com.qb9.gaturro.net.requests.SecureMamboRequest;
   import com.qb9.mambo.core.attributes.CustomAttribute;
   import com.qb9.mambo.user.inventory.Inventory;
   import com.qb9.mines.mobject.Mobject;
   
   public final class GiveObjectActionRequest extends SecureMamboRequest
   {
       
      
      private var attrs:Array;
      
      private var catalogName:String;
      
      private var blocks:Boolean;
      
      private var price:Number;
      
      private var name:String;
      
      private var receiver:String;
      
      private var inventory:String;
      
      public function GiveObjectActionRequest(param1:String, param2:String, param3:Number, param4:String, param5:Boolean, param6:Array = null, param7:String = null)
      {
         super();
         this.receiver = param1;
         this.name = param2;
         this.price = param3;
         this.catalogName = param4;
         this.blocks = param5;
         this.inventory = param7;
         this.attrs = param6;
      }
      
      private function attrToMobject(param1:CustomAttribute) : Mobject
      {
         return param1.toMobject();
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setString("receiver",this.receiver);
         param1.setString("name",this.name);
         param1.setFloat("price",this.price);
         param1.setString("catalogName",this.catalogName);
         param1.setBoolean("blockingHint",this.blocks);
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
