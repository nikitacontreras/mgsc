package com.qb9.gaturro.socialnet.messages
{
   import com.qb9.flashlib.geom.Vector2D;
   import com.qb9.gaturro.util.ImageTool;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   
   public class AvatarImageMessage extends ImageMessage
   {
       
      
      private var rect:Object;
      
      private var gaturro:Gaturro;
      
      private var background:DisplayObjectContainer;
      
      public function AvatarImageMessage(param1:String, param2:String, param3:int, param4:Gaturro, param5:DisplayObjectContainer, param6:Object)
      {
         super(param1,param2,param3);
         this.gaturro = param4;
         this.rect = param6;
         this.background = param5;
      }
      
      override public function get feedbackErrorText() : String
      {
         return "feedbackErrorMailAvatar";
      }
      
      override public function get feedbackSuccessText() : String
      {
         return "feedbackSuccessMailAvatar";
      }
      
      override protected function getBitmap() : BitmapData
      {
         return ImageTool.getAvatarBitmap(this.gaturro,this.background,"avatarPh",this.rect.width,this.rect.height,new Vector2D(this.rect.scaleX,this.rect.scaleY));
      }
   }
}
