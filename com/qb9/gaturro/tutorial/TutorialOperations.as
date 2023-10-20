package com.qb9.gaturro.tutorial
{
   import assets.InterfazArrowsMC;
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.view.world.elements.GaturroPortalView;
   import com.qb9.gaturro.view.world.elements.NpcRoomSceneObjectView;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TutorialOperations
   {
       
      
      private var gui:Gui;
      
      private var modelViews:TwoWayLink;
      
      private var arrows:InterfazArrowsMC;
      
      private var tasks:TaskRunner;
      
      private var _lastTrack:String;
      
      private var sceneObjects:Array;
      
      public function TutorialOperations()
      {
         super();
      }
      
      public function setUiArrows(param1:InterfazArrowsMC) : void
      {
         this.arrows = param1;
         var _loc2_:DisplayObject = this.arrows.btnSkip;
         _loc2_.addEventListener(MouseEvent.CLICK,this.clickOnSkip);
         this.arrows.confirmQuestion.visible = false;
      }
      
      private function getNpcMC(param1:String) : MovieClip
      {
         var _loc2_:Object = null;
         var _loc3_:NpcRoomSceneObjectView = null;
         if(!this.sceneObjects)
         {
            return null;
         }
         for each(_loc2_ in this.sceneObjects)
         {
            if(param1 == _loc2_.name)
            {
               _loc3_ = NpcRoomSceneObjectView(this.modelViews.getItem(_loc2_));
               if(Boolean(_loc3_) && _loc3_.numChildren > 0)
               {
                  return MovieClip(_loc3_.getChildAt(0));
               }
            }
         }
         return null;
      }
      
      public function showUiButton(param1:String, param2:Boolean) : void
      {
         if(param1 in this.gui)
         {
            this.gui[param1].visible = param2;
         }
      }
      
      public function setModelViews(param1:TwoWayLink) : void
      {
         this.modelViews = param1;
      }
      
      public function setTasks(param1:TaskRunner) : void
      {
         this.tasks = param1;
      }
      
      public function showArrow(param1:String, param2:Boolean) : void
      {
         var _loc3_:DisplayObject = null;
         if(param1 in this.arrows)
         {
            _loc3_ = DisplayObject(this.arrows[param1]);
            _loc3_.visible = false;
            if(param2)
            {
               _loc3_.visible = true;
               _loc3_.alpha = 0;
               this.tasks.add(new Sequence(new Tween(_loc3_,500,{"alpha":1})));
            }
         }
      }
      
      public function uiArrowOff() : void
      {
         var _loc1_:DisplayObject = null;
         for each(_loc1_ in DisplayUtil.children(this.arrows))
         {
            if(_loc1_.name != "btnSkip")
            {
               _loc1_.visible = false;
            }
         }
      }
      
      private function removeListeners() : void
      {
         this.arrows.confirmQuestion.btnYes.removeEventListener(MouseEvent.CLICK,this.clickOnSkipYes);
         this.arrows.confirmQuestion.btnNo.removeEventListener(MouseEvent.CLICK,this.clickOnSkipNo);
      }
      
      public function dispose() : void
      {
         var _loc1_:DisplayObject = this.arrows.btnSkip;
         _loc1_.removeEventListener(MouseEvent.CLICK,this.clickOnSkip);
         this.gui = null;
         this.sceneObjects = null;
         this.modelViews = null;
         this.arrows = null;
         this.tasks = null;
      }
      
      private function clickOnSkipYes(param1:MouseEvent) : void
      {
         this.removeListeners();
         TutorialManager.endTutorial();
         api.changeRoomXY(51690158,5,3);
      }
      
      public function getNpcState(param1:String) : String
      {
         var _loc2_:MovieClip = this.getNpcMC(param1);
         if(!_loc2_)
         {
            return null;
         }
         return _loc2_.currentLabel;
      }
      
      private function clickOnSkipNo(param1:MouseEvent) : void
      {
         this.removeListeners();
         this.arrows.confirmQuestion.visible = false;
      }
      
      public function setSceneObjects(param1:Array) : void
      {
         this.sceneObjects = param1;
      }
      
      private function clickOnSkip(param1:MouseEvent) : void
      {
         this.arrows.confirmQuestion.visible = true;
         this.arrows.confirmQuestion.btnYes.text.text = api.getText("SI");
         this.arrows.confirmQuestion.btnNo.text.text = api.getText("NO");
         this.arrows.confirmQuestion.btnYes.addEventListener(MouseEvent.CLICK,this.clickOnSkipYes);
         this.arrows.confirmQuestion.btnNo.addEventListener(MouseEvent.CLICK,this.clickOnSkipNo);
         api.trackEvent("TUTORIAL:SKIP",this._lastTrack);
      }
      
      public function set lastTrack(param1:String) : void
      {
         this._lastTrack = param1;
      }
      
      public function setNpcState(param1:String, param2:String) : void
      {
         var _loc3_:MovieClip = this.getNpcMC(param1);
         _loc3_.gotoAndStop(param2);
      }
      
      public function setGui(param1:Gui) : void
      {
         this.gui = param1;
      }
      
      public function uiOff() : void
      {
         this.gui.inventory.visible = false;
         this.gui.actions.visible = false;
         this.gui.home.visible = false;
         this.gui.map.visible = false;
         this.gui.achievements.visible = false;
         this.gui.profile.visible = false;
         this.gui.cel.visible = false;
         this.gui.chat.visible = false;
         this.gui.houseMap.visible = false;
         this.gui.messages.visible = false;
         this.gui.interactionDisplayer.visible = false;
      }
      
      public function portalStatus(param1:Boolean) : void
      {
         var _loc2_:Object = null;
         var _loc3_:GaturroPortalView = null;
         for each(_loc2_ in this.sceneObjects)
         {
            if(_loc2_.name == "door")
            {
               _loc3_ = GaturroPortalView(this.modelViews.getItem(_loc2_));
               _loc3_.visible = param1;
            }
         }
      }
   }
}
