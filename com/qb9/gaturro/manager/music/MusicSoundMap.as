package com.qb9.gaturro.manager.music
{
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.iterator.Iterator;
   import com.qb9.gaturro.manager.music.enum.MusicNoteEnum;
   import flash.utils.Dictionary;
   
   public class MusicSoundMap
   {
       
      
      private var map:Dictionary;
      
      private var _iterator:IIterator;
      
      public function MusicSoundMap()
      {
         super();
         this.map = new Dictionary();
      }
      
      public function registerNote(param1:String, param2:String) : void
      {
         if(MusicNoteEnum.map[param1])
         {
            this.map[param1] = param2;
            return;
         }
         throw new Error("The given note is not regitred as a valid one. [ " + param1 + "]");
      }
      
      public function getSound(param1:String) : String
      {
         var _loc2_:String = null;
         if(this.map[param1])
         {
            return String(this.map[param1]);
         }
         throw new Error("The given note is not mapped. [ " + param1 + "]");
      }
      
      public function get iterator() : IIterator
      {
         if(!this._iterator)
         {
            this._iterator = new Iterator();
            this._iterator.setupIterable(this.map);
         }
         return this._iterator;
      }
   }
}
