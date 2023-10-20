package com.qb9.gaturro.view.world.misc
{
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.tasks.Func;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.view.world.GaturroRoomView;
   import com.qb9.gaturro.view.world.avatars.GaturroUserAvatarView;
   import flash.display.DisplayObject;
   
   public class AntiGravityManager
   {
       
      
      private var roomView:GaturroRoomView;
      
      private var othersRotation:int;
      
      private var avatars:Array;
      
      private var tasks:TaskRunner;
      
      private var othersY:int;
      
      private var api:GaturroRoomAPI;
      
      public function AntiGravityManager(param1:GaturroRoomView, param2:Array, param3:GaturroRoomAPI)
      {
         super();
         this.roomView = param1;
         this.avatars = param2;
         this.api = param3;
         this.tasks = new TaskRunner(param1);
         this.triggerUserGravityHeight();
         this.triggerUserGravityRotation();
         this.triggerOthersGravityHeight();
         this.triggerOthersGravityRotation();
         this.tasks.start();
      }
      
      public function set rotation(param1:int) : void
      {
         var _loc3_:DisplayObject = null;
         this.othersRotation = param1;
         this.avatars = this.api.avatars;
         var _loc2_:int = 0;
         while(_loc2_ < this.avatars.length)
         {
            _loc3_ = this.api.getView(this.avatars[_loc2_]);
            if(!(_loc3_ is GaturroUserAvatarView))
            {
               _loc3_.rotation = param1;
            }
            _loc2_++;
         }
      }
      
      public function dispose() : void
      {
         this.tasks.stop();
         this.tasks = null;
      }
      
      private function checkDisposed() : Boolean
      {
         return this.api.disposed || !this.api.avatars;
      }
      
      private function triggerUserGravityRotation() : void
      {
         if(this.checkDisposed())
         {
            return;
         }
         var _loc1_:Sequence = new Sequence();
         if(this.api.swimmingUserView)
         {
            _loc1_.add(new Tween(this.api.swimmingUserView,1500 + Math.random() * 800,{"rotation":(this.rotation <= 0 ? 20 : -20)}));
         }
         else
         {
            _loc1_.add(new Tween(this.api.userView,1500 + Math.random() * 800,{"rotation":(this.rotation <= 0 ? 20 : -20)}));
         }
         _loc1_.add(new Func(this.triggerUserGravityRotation));
         this.tasks.add(_loc1_);
      }
      
      private function triggerOthersGravityRotation() : void
      {
         if(this.checkDisposed())
         {
            return;
         }
         this.avatars = this.api.avatars;
         var _loc1_:Sequence = new Sequence();
         _loc1_.add(new Tween(this,1500 + Math.random() * 800,{"rotation":(this.rotation <= 0 ? 20 : -20)}));
         _loc1_.add(new Func(this.triggerOthersGravityRotation));
         this.tasks.add(_loc1_);
      }
      
      private function triggerUserGravityHeight() : void
      {
         if(this.checkDisposed())
         {
            return;
         }
         var _loc1_:Sequence = new Sequence();
         if(this.api.swimmingUserView)
         {
            _loc1_.add(new Tween(this.api.swimmingUserView,2000 + Math.random() * 3200,{"y":(this.api.swimmingUserView.y == 0 ? 100 : 0)}));
         }
         else
         {
            _loc1_.add(new Tween(this.api.userView,2000 + Math.random() * 3200,{"y":(this.api.userView.y == 0 ? 100 : 0)}));
         }
         _loc1_.add(new Func(this.triggerUserGravityHeight));
         this.tasks.add(_loc1_);
      }
      
      public function set height(param1:int) : void
      {
         var _loc3_:DisplayObject = null;
         this.othersY = param1;
         this.avatars = this.api.avatars;
         var _loc2_:int = 0;
         while(_loc2_ < this.avatars.length)
         {
            _loc3_ = this.api.getView(this.avatars[_loc2_]);
            if(!(_loc3_ is GaturroUserAvatarView))
            {
               _loc3_.y = param1;
            }
            _loc2_++;
         }
      }
      
      private function triggerOthersGravityHeight() : void
      {
         if(this.checkDisposed())
         {
            return;
         }
         this.avatars = this.api.avatars;
         var _loc1_:Sequence = new Sequence();
         _loc1_.add(new Tween(this,4000,{"height":(this.height == 0 ? 100 : 0)}));
         _loc1_.add(new Func(this.triggerOthersGravityHeight));
         this.tasks.add(_loc1_);
      }
      
      public function get rotation() : int
      {
         return this.othersRotation;
      }
      
      public function get height() : int
      {
         return this.othersY;
      }
   }
}
