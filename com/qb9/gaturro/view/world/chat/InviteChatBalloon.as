package com.qb9.gaturro.view.world.chat
{
   import assets.InviteRequestMC;
   import com.qb9.gaturro.globals.api;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class InviteChatBalloon extends ChatBalloon
   {
       
      
      private var roomId:Number;
      
      public function InviteChatBalloon(param1:Number, param2:String, param3:DisplayObject, param4:Sprite)
      {
         this.roomId = param1;
         this.text = param2;
         super(param3,param4,param2);
      }
      
      override public function removeBalloon() : void
      {
         this.removeListeners();
      }
      
      override protected function createAsset() : void
      {
         asset = new InviteRequestMC();
         MovieClip(asset).field.text = text;
         var _loc1_:DisplayObject = asset.getChildByName("go");
         if(_loc1_)
         {
            _loc1_.addEventListener(MouseEvent.MOUSE_UP,this.pressGo);
         }
      }
      
      override protected function calculateTime(param1:String) : uint
      {
         return super.calculateTime(param1) * 4;
      }
      
      protected function pressGo(param1:Event) : void
      {
         param1.stopPropagation();
         this.removeListeners();
         this.asset.visible = false;
         api.changeRoomXY(this.roomId,10,10);
      }
      
      protected function removeListeners() : void
      {
         var _loc1_:DisplayObject = asset.getChildByName("go");
         if(_loc1_)
         {
            _loc1_.removeEventListener(MouseEvent.MOUSE_UP,this.pressGo);
         }
      }
      
      override public function dispose() : void
      {
         this.removeListeners();
         super.dispose();
      }
   }
}
