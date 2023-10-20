package com.qb9.gaturro.manager.music
{
   public class MusicNote
   {
       
      
      private var _note:String;
      
      private var serialized:String;
      
      private var _rhythmic:int;
      
      public function MusicNote(param1:String, param2:int, param3:String = "")
      {
         super();
         this.serialized = param3;
         this._rhythmic = param2;
         this._note = param1;
         if(!this._note)
         {
            throw new "Can\'t build MusicNote instance providing a null note parameter"();
         }
         if(param2 <= 0)
         {
            throw new Error("A rhythmic can´t be equal or less than 0. In this cxase getted: " + param2);
         }
      }
      
      public function splitableToString() : String
      {
         return this.note + ";" + this.rhythmic;
      }
      
      public function get rhythmic() : int
      {
         return this._rhythmic;
      }
      
      public function get note() : String
      {
         return this._note;
      }
      
      public function toString() : String
      {
         return "MusicNote > note: " + this.note + " - rhythmic: " + this.rhythmic;
      }
   }
}
