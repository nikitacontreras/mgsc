package com.qb9.gaturro.socialnet.messages
{
   import flash.display.BitmapData;
   
   public class SceneImageMessage extends ImageMessage
   {
       
      
      private var sceneBitmap:BitmapData;
      
      private var caption:String;
      
      public function SceneImageMessage(param1:String, param2:String, param3:int, param4:BitmapData, param5:String)
      {
         super(param1,param2,param3);
         this.sceneBitmap = param4;
         this.caption = param5;
      }
      
      override public function get feedbackErrorText() : String
      {
         return "feedbackErrorMailScene";
      }
      
      override protected function getBitmap() : BitmapData
      {
         return this.sceneBitmap;
      }
      
      override public function setParams(param1:Array) : void
      {
         super.setParams(param1);
         var _loc2_:Object = getStringKeyValue(this.caption);
         param1.push(_loc2_);
      }
      
      override public function get feedbackSuccessText() : String
      {
         return "feedbackSuccessMailScene";
      }
   }
}
