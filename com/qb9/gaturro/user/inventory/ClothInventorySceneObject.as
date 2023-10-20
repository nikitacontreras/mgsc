package com.qb9.gaturro.user.inventory
{
   import com.qb9.mambo.core.attributes.CustomAttributes;
   
   public class ClothInventorySceneObject extends GaturroInventorySceneObject implements WearableInventorySceneObject
   {
      
      public static const PREFIX:String = "wear_";
       
      
      public function ClothInventorySceneObject(param1:CustomAttributes)
      {
         super(param1);
      }
      
      public function get providedAttributes() : Object
      {
         return getAttributesWithPreffix(PREFIX);
      }
      
      override protected function parsePreffixAttribute(param1:Object, param2:String) : Object
      {
         var _loc3_:String = param1 as String;
         if(Boolean(_loc3_) && _loc3_.indexOf(".") === -1)
         {
            _loc3_ = this.ns + "." + _loc3_;
         }
         return _loc3_;
      }
      
      protected function get ns() : String
      {
         return name.split(".")[0];
      }
   }
}
