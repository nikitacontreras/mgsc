package com.qb9.gaturro.view.gui.image
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public final class ImageModalEvent extends Event
   {
      
      public static const OPEN:String = "beOpenImage";
       
      
      private var _image:DisplayObject;
      
      public function ImageModalEvent(param1:String, param2:DisplayObject)
      {
         super(param1,true);
         this._image = param2;
      }
      
      public function get image() : DisplayObject
      {
         return this._image;
      }
      
      override public function clone() : Event
      {
         return new ImageModalEvent(type,this.image);
      }
   }
}
