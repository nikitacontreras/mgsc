package com.qb9.gaturro.user.inventory
{
   import com.qb9.mambo.core.attributes.CustomAttributes;
   
   public class PetCareSceneObject extends PetInventorySceneObject
   {
       
      
      public function PetCareSceneObject(param1:CustomAttributes)
      {
         super(param1);
      }
      
      public function get cleanliness() : uint
      {
         return attributes.petCleanliness;
      }
   }
}
