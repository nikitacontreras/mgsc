package com.qb9.gaturro.view.gui.emoticons
{
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.gui.base.BaseGuiModalOpener;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public final class GuiEmoticons extends BaseGuiModalOpener
   {
       
      
      private var avatar:UserAvatar;
      
      public function GuiEmoticons(param1:Gui, param2:UserAvatar)
      {
         super(param1,param1.chat.emoticons,196,429);
         this.avatar = param2;
         param2.addCustomAttributeListener("emote",this.updateSign);
         this.updateSign();
      }
      
      override protected function createModal() : BaseGuiModal
      {
         this.button.gotoAndStop("opened");
         gui.guiInteractionView.close();
         var _loc1_:EmoticonsGuiModal = new EmoticonsGuiModal(this.avatar);
         _loc1_.addEventListener(Event.CLOSE,this.whenClosed);
         return _loc1_;
      }
      
      public function whenClosed(param1:Event) : void
      {
         if(this.button.currentLabel != "closed")
         {
            modal.removeEventListener(Event.CLOSE,this.whenClosed);
            this.button.gotoAndStop("closed");
         }
      }
      
      private function get container() : MovieClip
      {
         return gui.chat.emoticonsContainer;
      }
      
      private function get button() : MovieClip
      {
         return asset as MovieClip;
      }
      
      private function updateSign(param1:Event = null) : void
      {
         DisplayUtil.empty(mc.ph);
         if(this.avatar.attributes.emote == null)
         {
            return;
         }
         var _loc2_:DisplayObject = EmoticonsGuiModal.makeIcon(this.avatar.attributes.emote);
         mc.ph.addChild(_loc2_);
      }
      
      override public function dispose() : void
      {
         this.avatar.removeCustomAttributeListener("emote",this.updateSign);
         this.avatar = null;
         super.dispose();
      }
   }
}
