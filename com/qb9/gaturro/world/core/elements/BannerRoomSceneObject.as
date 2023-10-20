package com.qb9.gaturro.world.core.elements
{
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.tiling.TileGrid;
   
   public final class BannerRoomSceneObject extends RoomSceneObject
   {
       
      
      public function BannerRoomSceneObject(param1:CustomAttributes, param2:TileGrid)
      {
         super(param1,param2);
      }
      
      override public function get monitorAttributes() : Boolean
      {
         return true;
      }
      
      public function get hasThumbnail() : Boolean
      {
         return !("thumbnail" in attributes && attributes.thumbnail == "no");
      }
      
      public function get isExternalThumbnail() : String
      {
         var _loc1_:String = null;
         if("externalAsset" in attributes)
         {
            _loc1_ = String(attributes.externalAsset);
         }
         return _loc1_;
      }
      
      public function get tag() : String
      {
         var _loc1_:String = "";
         if("tag" in attributes)
         {
            _loc1_ = String(attributes.tag);
         }
         return _loc1_;
      }
      
      public function get banner() : String
      {
         return attributes.banner;
      }
      
      public function get bannerTag() : String
      {
         var _loc1_:String = "";
         if("bannerTag" in attributes)
         {
            _loc1_ = String(attributes.bannerTag);
         }
         return _loc1_;
      }
   }
}
