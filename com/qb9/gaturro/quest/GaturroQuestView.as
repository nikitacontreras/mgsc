package com.qb9.gaturro.quest
{
   import assets.QuestlogIcon;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.quest.model.QuestModel;
   import com.qb9.gaturro.commons.quest.view.AbstractSystemQuestView;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.view.gui.Gui;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class GaturroQuestView extends AbstractSystemQuestView
   {
       
      
      private var icon:QuestlogIcon;
      
      private var statusNewIcon:Boolean;
      
      private var iconContainer:Sprite;
      
      private var statusIcon:Boolean;
      
      public function GaturroQuestView()
      {
         super();
         this.setup();
         Context.instance.addByType(this,GaturroQuestView);
      }
      
      public function showIcon() : void
      {
         this.statusIcon = true;
         if(this.icon)
         {
            this.icon.visible = true;
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:IIterator = GaturroQuestController(_controller).getActiveList();
         var _loc3_:IIterator = GaturroQuestController(_controller).getNewsList();
         api.instantiateBannerModal("QuestBanner",null,null,{
            "actives":_loc2_,
            "news":_loc3_
         });
      }
      
      private function setupQuestIconHolder() : void
      {
         var _loc1_:Gui = null;
         if(!this.icon)
         {
            _loc1_ = Context.instance.getByType(Gui) as Gui;
            this.iconContainer = _loc1_.questlog_ph;
            this.icon = new QuestlogIcon();
            this.iconContainer.addChild(this.icon);
            this.iconContainer.addEventListener(MouseEvent.CLICK,this.onClick);
            this.iconContainer.buttonMode = true;
            this.icon.visible = this.statusIcon;
         }
      }
      
      private function onInstanceAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == Gui)
         {
            this.setupQuestIconHolder();
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onInstanceAdded);
         }
      }
      
      override public function complete(param1:QuestModel) : void
      {
         if(Boolean(param1.completionPopup) && Boolean(api))
         {
            api.instantiateBannerModal(param1.completionPopup,null,"",param1);
         }
      }
      
      override public function activate(param1:QuestModel) : void
      {
         this.setNewIconView(true);
         if(Boolean(param1.initializationPopup) && Boolean(api))
         {
            api.instantiateBannerModal(param1.initializationPopup.banner,null,"",param1);
         }
      }
      
      public function hideIcon() : void
      {
         this.statusIcon = false;
         if(this.icon)
         {
            this.icon.visible = false;
         }
      }
      
      private function setNewIconView(param1:Boolean) : void
      {
         this.statusNewIcon = param1;
         if(this.icon)
         {
            this.icon.newIcon.visble = param1;
         }
      }
      
      public function setup() : void
      {
         if(Context.instance.hasByType(Gui))
         {
            this.setupQuestIconHolder();
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onInstanceAdded);
         }
      }
   }
}
