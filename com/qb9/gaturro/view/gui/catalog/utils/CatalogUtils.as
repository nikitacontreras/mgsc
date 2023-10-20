package com.qb9.gaturro.view.gui.catalog.utils
{
   import assets.CatalogMC;
   import com.qb9.flashlib.math.Random;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.region;
   import flash.utils.Dictionary;
   
   public class CatalogUtils
   {
      
      public static const SLIDE_TIME:uint = 700;
      
      public static var catalogMap:Dictionary;
      
      public static const COINS_ANIMATION_TIME:uint = 1200;
      
      public static const ROWS:uint = 2;
      
      public static const BAR_WIDTH:uint = 301;
      
      public static const COINS_ANIMATION_EASING:String = "easeout";
      
      public static const MARGIN:uint = 10;
      
      public static const COLS:uint = 3;
      
      public static const ITEM_WIDTH:uint = 128 + MARGIN;
       
      
      public function CatalogUtils()
      {
         super();
      }
      
      public static function substractCoins(param1:String, param2:uint) : void
      {
         switch(param1)
         {
            case "pepiones":
               api.setProfileAttribute("pepionesCoins",getCoins(param1) - param2);
               break;
            case "tapitas":
               api.setProfileAttribute("tapitas",getCoins(param1) - param2);
               break;
            case "navidad":
               api.setProfileAttribute("navidadCoins",getCoins(param1) - param2);
               break;
            case "feria":
               api.setProfileAttribute("feria",getCoins(param1) - param2);
               break;
            case "reyes":
               api.setProfileAttribute("coronitas",getCoins(param1) - param2);
               break;
            case "asteroids":
               api.setSession("asteroids",getCoins(param1) - param2);
               break;
            case "chocomonedas":
               api.setProfileAttribute("chocomonedas",getCoins(param1) - param2);
               break;
            case "figumonedas":
               api.setProfileAttribute("figumonedas",getCoins(param1) - param2);
         }
      }
      
      public static function catalogByCurrency(param1:String) : Class
      {
         if(!catalogMap)
         {
            loadMap();
         }
         if(catalogMap[param1])
         {
            return catalogMap[param1];
         }
         return null;
      }
      
      public static function getCoins(param1:String) : uint
      {
         switch(param1)
         {
            case "pepiones":
               return api.getProfileAttribute("pepionesCoins") as uint;
            case "tapitas":
               return api.getProfileAttribute("tapitas") as uint;
            case "navidad":
               return api.getProfileAttribute("navidadCoins") as uint;
            case "feria":
               return api.getProfileAttribute("feria") as uint;
            case "reyes":
               return api.getProfileAttribute("coronitas") as uint;
            case "asteroids":
               return api.getSession("asteroids") as uint;
            case "chocomonedas":
               return api.getProfileAttribute("chocomonedas") as uint;
            case "figumonedas":
               return api.getProfileAttribute("figumonedas") as uint;
            default:
               return api.user.profile.attributes.coins as uint;
         }
      }
      
      private static function loadMap() : void
      {
         catalogMap = new Dictionary();
         catalogMap["pepiones"] = CatalogPepionesMC;
         catalogMap["tapitas"] = CatalogSerenito2017MC;
         catalogMap["navidad"] = CatalogNavidadMC;
         catalogMap["monedas"] = CatalogMC;
         catalogMap["boca"] = CatalogBocaMC;
         catalogMap["river"] = CatalogRiverMC;
         catalogMap["feria"] = CatalogFeriaMC;
         catalogMap["reyes"] = CatalogReyesMC;
         catalogMap["asteroids"] = CatalogAsteroidsMC;
         catalogMap["chocomonedas"] = CatalogPascuasMC;
         catalogMap["figumonedas"] = CatalogRusiaMC;
         catalogMap["newVip"] = CatalogPasaporteActivoMC;
      }
      
      public static function errorSub(param1:String) : String
      {
         switch(param1)
         {
            case "pepiones":
               return api.getText("¡CONSIGUELOS EN EL HOTEL EMBRUJADO!");
            case "tapitas":
               return api.getText("¡CONSIGUELOS JUGANDO AQUÍ!");
            case "navidad":
               return api.getText("¡VISITA EL POLO NORTE!");
            case "feria":
               return api.getText("¡JUEGA EN LA FERIA!");
            case "reyes":
               return api.getText("¡CONSIGUELOS REGALANDO A OTROS USUARIOS!");
            case "asteroids":
               return api.getText("¡DEFIENDE AL PLANETA CIRKUIT!");
            case "chocomonedas":
               return api.getText("¡CONSIGUE RECUPERANDO LOS HUEVOS!");
            case "figumonedas":
               return api.getText("¡CONSIGUE RECUPERANDO TRITURANDO FIGUS REPETIDAS!");
            default:
               return region.key("not_enough_money_sub");
         }
      }
      
      public static function currencyText(param1:String) : String
      {
         switch(param1)
         {
            case "pepiones":
               return api.getText("TUS PEPIONES");
            case "tapitas":
               return api.getText("SERETICKETS");
            case "navidad":
               return api.getText("TUS MUÉRDAGOS");
            case "feria":
               return api.getText("TUS TICKETS");
            case "reyes":
               return api.getText("TUS CORONITAS");
            case "asteroids":
               return api.getText("DIAMANTES");
            case "chocomonedas":
               return api.getText("CHOCOMONEDAS");
            case "figumonedas":
               return api.getText("FIGUMONEDAS");
            default:
               return api.getText("TUS MONEDAS");
         }
      }
      
      public static function errorMessage(param1:String) : String
      {
         switch(param1)
         {
            case "pepiones":
               return api.getText("AYUDA A ROMPER TODOS LOS HECHIZOS PARA CONSEGUIR PEPIONES ");
            case "tapitas":
               return api.getText("JUEGA PARA GANAR SERETICKETS ");
            case "navidad":
               return api.getText("AYUDA A COMETA CON LA NAVIDAD ");
            case "feria":
               return api.getText("CONSIGUE TICKETS JUGANDO EN LA FERIA ");
            case "reyes":
               return api.getText("CONSIGUE CORONITAS REGALANDO A OTROS USUARIOS ");
            case "asteroids":
               return api.getText("CONSIGUE DIAMANTES EXPLOTANDO ASTEROIDES ");
            case "chocomonedas":
               return api.getText("CONSIGUE CHOCOMONEDAS BUSCANDO LOS HUEVOS");
            case "figumonedas":
               return api.getText("CONSIGUE FIGUMONEDAS TRITURANDO FIGUS REPETIDAS");
            default:
               return randomNotEnoughMoneyKey();
         }
      }
      
      public static function errorTitle(param1:String) : String
      {
         switch(param1)
         {
            case "pepiones":
               return api.getText("NO TIENES SUFICIENTES PEPIONES");
            case "tapitas":
               return api.getText("NO TIENES SUFICIENTES SERETICKETS");
            case "navidad":
               return api.getText("NO TIENES SUFICIENTES MUÉRDAGOS");
            case "feria":
               return api.getText("NO TIENES SUFICIENTES TICKETS");
            case "reyes":
               return api.getText("NO TIENES SUFICIENTES CORONITAS");
            case "asteroids":
               return api.getText("NO TIENES SUFICIENTES DIAMANTES");
            case "chocomonedas":
               return api.getText("NO TIENES SUFICIENTES CHOCOMONEDAS");
            case "chocomonedas":
               return api.getText("NO TIENES SUFICIENTES FIGUMONEDAS");
            default:
               return region.key("not_enough_money_title");
         }
      }
      
      public static function giveCoins(param1:String, param2:int) : void
      {
         switch(param1)
         {
            case "pepiones":
               api.setProfileAttribute("pepionesCoins",getCoins(param1) + param2);
               return;
            case "tapitas":
               api.setProfileAttribute("tapitas",getCoins(param1) + param2);
               return;
            case "navidad":
               api.setProfileAttribute("navidadCoins",getCoins(param1) + param2);
               return;
            case "feria":
               api.setProfileAttribute("feria",getCoins(param1) + param2);
               return;
            case "reyes":
               api.setProfileAttribute("coronitas",getCoins(param1) + param2);
               return;
            case "asteroids":
               api.setSession("asteroids",getCoins(param1) + param2);
               return;
            case "chocomonedas":
               api.setProfileAttribute("chocomonedas",getCoins(param1) + param2);
               return;
            case "figumonedas":
               api.setProfileAttribute("figumonedas",getCoins(param1) + param2);
               return;
            default:
               return;
         }
      }
      
      private static function randomNotEnoughMoneyKey() : String
      {
         var _loc2_:int = 1;
         while(region.keyExists("not_enough_money_" + _loc2_.toString()))
         {
            _loc2_++;
         }
         _loc2_--;
         var _loc3_:int = Random.randint(1,_loc2_);
         return String(region.key("not_enough_money_" + _loc3_));
      }
   }
}
