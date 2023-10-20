package com.qb9.gaturro.view.world.interaction
{
   public class InteractionTypes
   {
      
      public static const MEDIC_CURE:String = "medicCure";
      
      public static const KICK_HOUSE:String = "kickHouse";
      
      public static const SALVAR:String = "salvar";
      
      public static const SAMURAI_GAME:String = "samurai";
      
      public static const FUTBOL_RUSIA_GAME:String = "futbolpenalrusia";
      
      public static const COPIAR_VESTIMENTA:String = "copiarvestimenta";
      
      public static const CARRERA_COHETE_GAME:String = "carreraCohete";
      
      public static const ROBAR:String = "robar";
      
      public static const PARTIDO_FUTBOL:String = "partidoFutbol";
      
      public static const REVIVIR:String = "revivir";
      
      public static const PARALIZAR:String = "paralizar";
      
      public static const ROBARSUCCESS:String = "robarSuccess";
      
      public static const FUTBOL_RIVER_GAME:String = "futbolpenalriver";
      
      public static const SAN_VALENTIN:String = "sanValentin";
      
      public static const ZOMBIE_BITE:String = "zombieBite";
      
      public static const NAVIDAD_PAN_DULCE_GAME:String = "pandulceCom";
      
      public static const FUTBOL_GAME:String = "futbolpenal";
      
      public static const PELEAMAGIA_GAME:String = "peleaMagia";
      
      public static const EXCHANGE:String = "exchange";
      
      public static const BOMBITAS:String = "bombitas";
       
      
      public function InteractionTypes()
      {
         super();
      }
      
      public static function twoLetterToFull(param1:String) : String
      {
         switch(param1)
         {
            case "EX":
               return EXCHANGE;
            case "BO":
               return BOMBITAS;
            case "FP":
               return FUTBOL_GAME;
            case "PM":
               return PELEAMAGIA_GAME;
            case "CC":
               return CARRERA_COHETE_GAME;
            case "CV":
               return COPIAR_VESTIMENTA;
            case "PR":
               return FUTBOL_RIVER_GAME;
            case "PT":
               return FUTBOL_RUSIA_GAME;
            case "PF":
               return PARTIDO_FUTBOL;
            case "SA":
               return SALVAR;
            case "PA":
               return PARALIZAR;
            case "RO":
               return ROBAR;
            case "RV":
               return REVIVIR;
            case "SS":
               return ROBARSUCCESS;
            default:
               return "null";
         }
      }
   }
}
