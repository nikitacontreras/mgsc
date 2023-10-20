package com.qb9.gaturro.net.requests
{
   import com.qb9.gaturro.globals.settings;
   
   public class DirectoryFactory
   {
      
      private static const NPC:String = "npc";
      
      private static const CONFIG:String = "startup";
      
      private static const ASSETS:String = "assets";
      
      private static const SFX:String = "sfx";
      
      private static const BANNERS:String = "banners";
      
      private static const BACKGROUNDS:String = "backgrounds";
      
      private static const NEWS:String = "news";
      
      private static const UI:String = "ui";
      
      private static const CONTENT:String = "content";
      
      private static const MAP:String = "map";
      
      private static const STARTUP:String = "cfgs";
       
      
      public function DirectoryFactory()
      {
         super();
      }
      
      public static function getUrl(param1:String) : String
      {
         switch(param1)
         {
            case CONFIG:
            case SFX:
            case ASSETS:
            case UI:
            case BANNERS:
            case BACKGROUNDS:
            case MAP:
            case NEWS:
            case NPC:
            case CONTENT:
            case STARTUP:
               if(!settings.resources[param1])
               {
                  return "";
               }
               return settings.resources[param1];
               break;
            default:
               return "";
         }
      }
   }
}
