package com.qb9.gaturro.view.world.chat
{
   import flash.display.MovieClip;
   
   public class InteractionUtils
   {
       
      
      public function InteractionUtils()
      {
         super();
      }
      
      public function hasSpecialAsset(param1:String) : MovieClip
      {
         switch(param1)
         {
            case "PA":
               return new InteractionRequestPandulceMC();
            case "PM":
               return new InteractionRequestPeleaMagiaMC();
            case "FP":
               return new InteractionRequestFutbolMC();
            case "PR":
               return new InteractionRequestFutbolMC();
            case "PT":
               return new InteractionRequestFutbolMC();
            case "CC":
               return new InteractionRequestCarrerasEspaciales();
            case "SV":
               return new InteractionRequestSanValentinMC();
            case "CV":
               return new InteractionRequestCopiarRopa();
            case "PF":
               return new InteractionRequestFutbol2MC();
            default:
               return new InteractionRequestMC();
         }
      }
   }
}
