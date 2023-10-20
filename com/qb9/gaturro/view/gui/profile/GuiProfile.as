package com.qb9.gaturro.view.gui.profile
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.user.profile.GaturroProfile;
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.gui.base.inventory.BaseGuiInventoryButton;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.geom.Matrix;
   
   public final class GuiProfile extends BaseGuiInventoryButton
   {
      
      private static const EXTRA_SCALE:Number = 1.5;
      
      private static const SCALE:Number = 0.75 * EXTRA_SCALE;
      
      private static const DX:uint = 30 * EXTRA_SCALE;
      
      private static const BITMAP_BG:uint = 6723942;
      
      private static const BITMAP_WIDTH:uint = 60 * EXTRA_SCALE;
      
      private static const BITMAP_HEIGHT:uint = 50 * EXTRA_SCALE;
      
      private static const DY:uint = 60 * EXTRA_SCALE;
       
      
      private var bd:BitmapData;
      
      private var character:Gaturro;
      
      private var profile:GaturroProfile;
      
      private var avatar:UserAvatar;
      
      public function GuiProfile(param1:Gui, param2:UserAvatar, param3:GaturroProfile, param4:Gaturro, param5:TaskContainer)
      {
         super(param1,param1.profile,param5,user.visualizer,35,380);
         this.avatar = param2;
         this.profile = param3;
         this.character = param4;
         this.setupSnapshot();
      }
      
      private function setupSnapshot() : void
      {
         this.bd = new BitmapData(BITMAP_WIDTH,BITMAP_HEIGHT,false,BITMAP_BG);
         var _loc1_:Bitmap = new Bitmap(this.bd,"auto",true);
         _loc1_.scaleX = _loc1_.scaleY = 1 / EXTRA_SCALE;
         mc.ph.addChild(_loc1_);
         if(this.character.loaded)
         {
            this.avatarReady();
         }
         this.character.addEventListener(Event.COMPLETE,this.avatarLoaded);
      }
      
      private function avatarReady() : void
      {
         var _loc1_:Matrix = new Matrix();
         _loc1_.scale(SCALE,SCALE);
         _loc1_.translate(DX,DY);
         this.bd.fillRect(this.bd.rect,BITMAP_BG);
         this.bd.draw(this.character,_loc1_,null,null,this.bd.rect,true);
      }
      
      override protected function createModal() : BaseGuiModal
      {
         api.roomView.loadingGuiFor(9999999);
         return new ProfileModal(this.avatar,this.profile);
      }
      
      private function avatarLoaded(param1:Event) : void
      {
         if(this.bd)
         {
            this.avatarReady();
         }
      }
      
      override public function dispose() : void
      {
         this.bd.dispose();
         this.bd = null;
         this.avatar = null;
         this.profile = null;
         this.character.removeEventListener(Event.COMPLETE,this.avatarLoaded);
         this.character = null;
         super.dispose();
      }
   }
}
