package com.qb9.gaturro.user.inventory
{
   import com.qb9.mambo.core.attributes.CustomAttributes;
   
   public class PetToySceneObject extends PetInventorySceneObject
   {
       
      
      public function PetToySceneObject(param1:CustomAttributes)
      {
         super(param1);
      }
      
      public function get love() : uint
      {
         return attributes.petLove;
      }
   }
}
