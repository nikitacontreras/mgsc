package com.qb9.gaturro.commons.quest.model
{
   public class QuestPopUpDefinition
   {
       
      
      public var description:String;
      
      public var image:String;
      
      public var banner:String;
      
      public var title:String;
      
      public function QuestPopUpDefinition(param1:Object)
      {
         super();
         this.banner = param1.banner;
         this.image = param1.image;
         this.title = param1.title;
         this.description = param1.description;
      }
   }
}
