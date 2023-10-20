package com.qb9.gaturro.user.inventory
{
   import com.qb9.mambo.core.attributes.CustomAttributes;
   
   public class UsableInventorySceneObject extends GaturroInventorySceneObject
   {
      
      public static const PREFIX:String = "attr_";
       
      
      public function UsableInventorySceneObject(param1:CustomAttributes)
      {
         super(param1);
      }
      
      public function get providedAttributes() : Object
      {
         return getAttributesWithPreffix(PREFIX);
      }
   }
}
