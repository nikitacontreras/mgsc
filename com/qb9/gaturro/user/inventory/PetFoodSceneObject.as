package com.qb9.gaturro.user.inventory
{
   import com.qb9.mambo.core.attributes.CustomAttributes;
   
   public class PetFoodSceneObject extends PetInventorySceneObject
   {
       
      
      public function PetFoodSceneObject(param1:CustomAttributes)
      {
         super(param1);
      }
      
      public function get energy() : uint
      {
         return attributes.petEnergy;
      }
      
      public function get superCookies() : Boolean
      {
         return attributes.superCookies;
      }
      
      public function get superCookiesType() : String
      {
         return attributes.superCookiesType;
      }
      
      public function get forPetType() : String
      {
         return attributes.forPetType;
      }
   }
}
