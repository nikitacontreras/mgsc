package com.qb9.gaturro.world.houseInteractive.navidad
{
   import com.qb9.gaturro.world.houseInteractive.HomeBehavior;
   
   public class NavidadBehaviorVisitor extends HomeBehavior
   {
       
      
      public function NavidadBehaviorVisitor()
      {
         super();
      }
      
      override protected function atStart() : void
      {
         super.atStart();
         trace("AT START. VISITANTE");
      }
   }
}
