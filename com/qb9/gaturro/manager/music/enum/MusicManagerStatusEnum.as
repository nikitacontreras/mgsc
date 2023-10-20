package com.qb9.gaturro.manager.music.enum
{
   public class MusicManagerStatusEnum
   {
      
      public static const RECORDING:int = 1;
      
      public static const IDLE:int = 0;
      
      public static const PLAYING:int = 2;
       
      
      public function MusicManagerStatusEnum()
      {
         super();
         throw new Error("This class shouldn\'t be instantiated");
      }
   }
}
