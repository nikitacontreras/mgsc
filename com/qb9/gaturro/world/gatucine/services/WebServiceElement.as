package com.qb9.gaturro.world.gatucine.services
{
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.world.gatucine.GatucineManager;
   import com.qb9.gaturro.world.gatucine.UIResponse;
   import com.qb9.gaturro.world.gatucine.elements.GatucineEpisode;
   import com.qb9.gaturro.world.gatucine.elements.GatucineSerieSeason;
   
   public class WebServiceElement extends WebService
   {
       
      
      private var serie:GatucineSerieSeason;
      
      public function WebServiceElement(param1:GatucineManager, param2:Function, param3:GatucineSerieSeason)
      {
         super(param1,param2);
         this.serie = param3;
      }
      
      override public function get json() : String
      {
         return "{" + "\"session_id\": \"" + manager.sessionId + "\"," + "\"element_id\": \"" + this.serie.id + "\"," + "\"device\": \"PC\", " + "\"operator\": \"gaturro\"" + "}";
      }
      
      override public function receive(param1:String) : void
      {
         var obj:Object = null;
         var episodeData:Object = null;
         var episode:GatucineEpisode = null;
         var data:String = param1;
         try
         {
            obj = decodeResponse(data);
            for each(episodeData in obj.response.children)
            {
               episode = new GatucineEpisode();
               episode.title = episodeData.title;
               episode.trackerId = episodeData.id;
               episode.playId = episodeData.uuid;
               episode.createThumbnail(episodeData.thumbnail.img_snapshot);
               this.serie.addEpisode(episode);
            }
            call(new UIResponse(true));
         }
         catch(e:Error)
         {
            receiveRequestError();
         }
      }
      
      override public function get url() : String
      {
         return settings.gatucine.WSElementURL;
      }
   }
}
