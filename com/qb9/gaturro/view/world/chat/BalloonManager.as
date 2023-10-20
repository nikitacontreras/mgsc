package com.qb9.gaturro.view.world.chat
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public final class BalloonManager extends TaskContainer
   {
       
      
      private var container:Sprite;
      
      public function BalloonManager(param1:Sprite)
      {
         super(true);
         this.container = param1;
      }
      
      private function getBalloonByOwner(param1:DisplayObject) : IChatBallon
      {
         var _loc2_:IChatBallon = null;
         for each(_loc2_ in subtasks)
         {
            if(_loc2_.owner === param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function proposeInvite(param1:Number, param2:String, param3:DisplayObject) : InviteChatBalloon
      {
         this.removePrevious(param3);
         var _loc4_:InviteChatBalloon = new InviteChatBalloon(param1,param2,param3,this.container);
         add(_loc4_);
         return _loc4_;
      }
      
      public function say(param1:DisplayObject, param2:String, param3:Sprite = null) : void
      {
         this.removePrevious(param1);
         if(!param3)
         {
            param3 = this.container;
         }
         var _loc4_:ChatBalloon = new ChatBalloon(param1,param3,param2);
         add(_loc4_);
      }
      
      public function thinkImg(param1:DisplayObject, param2:int, param3:int, param4:Array) : void
      {
         this.removePrevious(param1);
         var _loc5_:ThinkBalloonImg = new ThinkBalloonImg(param1,this.container,param2,param3,param4);
         add(_loc5_);
      }
      
      public function visibility(param1:Boolean) : void
      {
         var _loc2_:ChatBalloon = null;
         for each(_loc2_ in subtasks)
         {
            _loc2_.chatAsset.visible = param1;
         }
      }
      
      public function proposeInteraction(param1:String, param2:DisplayObject) : InteractionBalloon
      {
         this.removePrevious(param2);
         var _loc3_:InteractionBalloon = new InteractionBalloon(param1,param2,this.container);
         add(_loc3_);
         return _loc3_;
      }
      
      public function sayImg(param1:DisplayObject, param2:int, param3:int, param4:Array) : void
      {
         this.removePrevious(param1);
         var _loc5_:BalloonImg = new BalloonImg(param1,this.container,param2,param3,param4);
         add(_loc5_);
      }
      
      public function sayWithImg(param1:DisplayObject, param2:String, param3:String, param4:Sprite = null) : void
      {
         this.removePrevious(param1);
         if(!param4)
         {
            param4 = this.container;
         }
         var _loc5_:ChatBalloonWithImg = new ChatBalloonWithImg(param1,param4,param2,param3);
         add(_loc5_);
      }
      
      private function removePrevious(param1:DisplayObject) : void
      {
         var _loc2_:IChatBallon = this.getBalloonByOwner(param1);
         if(_loc2_)
         {
            _loc2_.removeBalloon();
            remove(_loc2_);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
