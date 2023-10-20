package com.qb9.mambo.net.requests.customAttributes
{
   import com.qb9.flashlib.lang.map;
   import com.qb9.mambo.core.attributes.CustomAttribute;
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public class BaseUpdateCustomAttributesRequest extends BaseMamboRequest
   {
       
      
      private var attributes:Array;
      
      private var id:Number;
      
      private var idName:String;
      
      public function BaseUpdateCustomAttributesRequest(param1:String, param2:Number, param3:Array)
      {
         super("UpdateCustomAttributeDataRequest");
         this.idName = param1;
         this.id = param2;
         this.attributes = param3;
      }
      
      private function attrToMobject(param1:CustomAttribute) : Mobject
      {
         return param1.toMobject();
      }
      
      override protected function build(param1:Mobject) : void
      {
         if(this.idName == "sceneObjectId")
         {
            param1.setString(this.idName,String(this.id));
         }
         else
         {
            param1.setInteger(this.idName,this.id);
         }
         param1.setMobjectArray("customAttributes",map(this.attributes,this.attrToMobject));
      }
   }
}
