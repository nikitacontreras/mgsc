package com.qb9.gaturro.net.requests.objects
{
   import com.qb9.flashlib.lang.map;
   import com.qb9.gaturro.net.requests.SecureMamboRequest;
   import com.qb9.mambo.core.attributes.CustomAttribute;
   import com.qb9.mambo.user.inventory.Inventory;
   import com.qb9.mines.mobject.Mobject;
   
   public final class AcquireObjectActionRequest extends SecureMamboRequest
   {
       
      
      private var attrs:Array;
      
      private var inventory:String;
      
      private var blocks:Boolean;
      
      private var name:String;
      
      private var amount:uint;
      
      private var giverId:Number;
      
      private var giftCode:String;
      
      public function AcquireObjectActionRequest(param1:Number, param2:String, param3:Boolean = false, param4:Array = null, param5:String = null, param6:uint = 1, param7:String = "")
      {
         super("AcquireObjectActionRequest");
         this.giverId = param1;
         this.name = param2;
         this.blocks = param3;
         this.amount = param6;
         this.inventory = param5;
         this.attrs = param4;
         this.giftCode = param7;
      }
      
      private function attrToMobject(param1:CustomAttribute) : Mobject
      {
         return param1.toMobject();
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setString("giverId",String(this.giverId));
         param1.setString("name",this.name);
         param1.setInteger("amount",this.amount);
         param1.setBoolean("blockingHint",this.blocks);
         if(Boolean(this.inventory) && this.inventory !== Inventory.DEFAULT)
         {
            param1.setString("inventoryName",this.inventory);
         }
         if(this.attrs)
         {
            param1.setMobjectArray("customAttributes",map(this.attrs,this.attrToMobject));
         }
         if(this.giftCode != "")
         {
            param1.setString("giftCode",this.giftCode);
         }
         applyValidationDigest(param1);
      }
   }
}
