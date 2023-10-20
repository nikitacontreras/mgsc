package com.qb9.gaturro.util.giftcodes
{
   import com.qb9.gaturro.globals.settings;
   
   public class CampaignFactory
   {
       
      
      public function CampaignFactory()
      {
         super();
      }
      
      public static function codeCampaignJumbo() : Campaign
      {
         var _loc1_:Object = settings.giftCodes.campaigns.jumbo;
         return new JumboCampaign(_loc1_);
      }
      
      public static function createCampaign(param1:String) : Campaign
      {
         var _loc2_:Object = settings.giftCodes.campaigns[param1];
         if(!_loc2_)
         {
            return null;
         }
         switch(_loc2_.type)
         {
            case "classic":
               return new Campaign(_loc2_);
            case "cards":
               return new CardsCampaign(_loc2_);
            case "virtualGoods":
               return new VirtualGoodsCampaign(_loc2_);
            case "uniqueCodes":
               return new UniqueCodesCampaign(_loc2_);
            case "giftCatcher":
               return new Panini3Campaign(_loc2_);
            case "mostaza":
               return new MostazaCampaign(_loc2_);
            case "gatuCraft":
               return new GatuCraftCampaign(_loc2_);
            case "boca3Días":
               return new Boca3Passport(_loc2_);
            case "river3Días":
               return new River3Passport(_loc2_);
            default:
               return null;
         }
      }
   }
}
