package com.qb9.gaturro.socialnet.messages
{
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.util.ImageTool;
   import flash.display.BitmapData;
   
   public class ImageMessage extends SocialNetMessage
   {
       
      
      protected var imageType:String;
      
      protected var jpegQuality:int;
      
      public function ImageMessage(param1:String, param2:String, param3:int)
      {
         super(param1);
         this.imageType = param2;
         this.jpegQuality = param3;
      }
      
      protected function getBitmap() : BitmapData
      {
         return null;
      }
      
      override public function setParams(param1:Array) : void
      {
         var _loc2_:Object = getStringKeyValue(user.username);
         param1.push(_loc2_);
         super.setParams(param1);
         var _loc3_:String = this.imageString();
         var _loc4_:Object = getStringKeyValue(_loc3_);
         param1.push(_loc4_);
      }
      
      public function imageString() : String
      {
         var _loc1_:BitmapData = this.getBitmap();
         return this.captureBytes(_loc1_);
      }
      
      protected function captureBytes(param1:BitmapData) : String
      {
         return ImageTool.bitmapToBase64(param1,this.imageType,this.jpegQuality);
      }
   }
}
