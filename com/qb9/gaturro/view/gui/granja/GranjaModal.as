package com.qb9.gaturro.view.gui.granja
{
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.gui.jobs.JobStats;
   import com.qb9.gaturro.view.world.GaturroHomeGranjaView;
   import farm.GranjaBanner;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class GranjaModal extends BaseGuiModal
   {
       
      
      private var buttons:Array;
      
      private var cropsSorted:Array;
      
      private const buttonsPerPage:int = 3;
      
      private var tasks:TaskRunner;
      
      private var page:int = 1;
      
      private var maxPage:int;
      
      private var granjaView:GaturroHomeGranjaView;
      
      private var objectAPI:GaturroSceneObjectAPI;
      
      public var playingAnim:Boolean;
      
      private var farmerLevel:int;
      
      private var jobStats:JobStats;
      
      private var crops:Object;
      
      private const margin:int = 30;
      
      private var asset:GranjaBanner;
      
      private var roomAPI:GaturroRoomAPI;
      
      public function GranjaModal(param1:TaskRunner, param2:GaturroSceneObjectAPI, param3:GaturroRoomAPI)
      {
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         this.cropsSorted = [];
         super();
         this.objectAPI = param2;
         this.roomAPI = param3;
         this.asset = new GranjaBanner();
         this.tasks = param1;
         this.playingAnim = false;
         addChild(this.asset);
         this.granjaView = param3.roomView as GaturroHomeGranjaView;
         this.jobStats = this.granjaView.jobStats;
         addEventListener(MouseEvent.CLICK,this.handleCloseClicks);
         this.page = api.getSession("lastCropPage") as int || 1;
         this.crops = settings.granjaHome.crops;
         this.cropsSorted = [];
         var _loc4_:Array = [];
         for each(_loc5_ in this.crops)
         {
            _loc4_.push(_loc5_);
         }
         _loc6_ = 1;
         while(_loc4_.length > _loc6_)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc4_.length)
            {
               if(_loc4_[_loc7_].id == _loc6_)
               {
                  this.cropsSorted.push(_loc4_[_loc7_]);
                  _loc6_++;
               }
               _loc7_++;
            }
         }
         this.farmerLevel = this.jobStats.currentLevel;
         this.asset.leftScroll.addEventListener(MouseEvent.CLICK,this.scrollLeft);
         this.asset.rightScroll.addEventListener(MouseEvent.CLICK,this.scrollRight);
         this.createButtons();
         this.loadPage();
      }
      
      override public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.handleCloseClicks);
         super.dispose();
      }
      
      private function loadPage() : void
      {
         while(this.asset.phBotones.numChildren > 0)
         {
            this.asset.phBotones.removeChildAt(0);
         }
         var _loc2_:int = (this.page - 1) * this.buttonsPerPage;
         var _loc3_:int = this.page * this.buttonsPerPage;
         var _loc4_:int = _loc2_;
         while(_loc4_ < _loc3_)
         {
            if(_loc4_ < this.buttons.length)
            {
               this.asset.phBotones.addChild(this.buttons[_loc4_]);
            }
            _loc4_++;
         }
         api.playSound("granja/pantallaSilo");
      }
      
      private function createButtons() : void
      {
         var _loc3_:Object = null;
         var _loc4_:CropButton = null;
         this.maxPage = Math.ceil(this.cropsSorted.length / this.buttonsPerPage);
         var _loc1_:int = 0;
         this.buttons = [];
         var _loc2_:int = 0;
         while(_loc2_ < this.cropsSorted.length)
         {
            _loc3_ = {
               "cropObj":this.cropsSorted[_loc2_],
               "relativeIndex":_loc1_,
               "absoluteIndex":_loc2_,
               "jobLevel":this.farmerLevel,
               "granjaView":this.granjaView,
               "objectAPI":this.objectAPI,
               "tasks":this.tasks,
               "popUp":this,
               "playSound":api.playSound
            };
            _loc4_ = new CropButton(_loc3_);
            this.buttons.push(_loc4_);
            _loc1_++;
            if(_loc1_ >= this.buttonsPerPage)
            {
               _loc1_ = 0;
            }
            _loc2_++;
         }
         if(this.page == this.maxPage)
         {
            this.asset.rightScroll.gotoAndStop("disabled");
         }
         else
         {
            this.asset.rightScroll.gotoAndStop("idle");
         }
         if(this.page == 1)
         {
            this.asset.leftScroll.gotoAndStop("disabled");
         }
         else
         {
            this.asset.leftScroll.gotoAndStop("idle");
         }
      }
      
      private function scrollRight(param1:MouseEvent) : void
      {
         this.asset.leftScroll.gotoAndStop("idle");
         var _loc2_:int = this.page;
         if(this.page < this.maxPage)
         {
            ++this.page;
         }
         if(this.page == this.maxPage)
         {
            this.asset.rightScroll.gotoAndStop("disabled");
         }
         if(this.page != _loc2_)
         {
            this.loadPage();
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:* = false;
         var _loc5_:int = 0;
         var _loc7_:MovieClip = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc2_:int = (this.page - 1) * this.buttonsPerPage;
         var _loc6_:int = api.getProfileAttribute("coins") as int;
         if(param1.target == this.asset.seed2)
         {
            _loc2_++;
         }
         else if(param1.target == this.asset.seed3)
         {
            _loc2_ += 2;
         }
         _loc3_ = String(this.cropsSorted[_loc2_].name);
         _loc4_ = this.cropsSorted[_loc2_].unlockAt as int <= this.jobStats.currentLevel;
         _loc5_ = int(this.cropsSorted[_loc2_].price);
         if(_loc4_ && _loc6_ >= _loc5_)
         {
            this.granjaView.plantCrop(this.cropsSorted[_loc2_],this.objectAPI);
            this.granjaView.activeCrop = this.cropsSorted[_loc2_];
            this.granjaView.planting = true;
            this.close();
         }
         else
         {
            if(this.playingAnim)
            {
               return;
            }
            api.playSound("cosas2");
            _loc8_ = int((_loc7_ = this.asset.phBotones.getChildAt(_loc2_ % 3) as MovieClip).unlocked.price.textColor);
            _loc9_ = _loc7_.x;
            this.playingAnim = true;
            if(_loc4_)
            {
               _loc7_.unlocked.price.textColor = 16711680;
            }
            this.tasks.add(new Sequence(new Tween(_loc7_,200,{"x":_loc9_ + 5},{"transition":"easeIn"}),new Tween(_loc7_,200,{"x":_loc9_ - 5},{"transition":"easeIn"}),new Tween(_loc7_,100,{"x":_loc9_},{"transition":"easeIn"}),new Tween(_loc7_.unlocked.price,1,{"textColor":_loc8_}),new Tween(this,1,{"playingAnim":false})));
         }
      }
      
      override protected function get openSound() : String
      {
         return null;
      }
      
      private function scrollLeft(param1:MouseEvent) : void
      {
         this.asset.rightScroll.gotoAndStop("idle");
         var _loc2_:int = this.page;
         if(this.page > 1)
         {
            --this.page;
         }
         if(this.page == 1)
         {
            this.asset.leftScroll.gotoAndStop("disabled");
         }
         if(this.page != _loc2_)
         {
            this.loadPage();
         }
      }
      
      override protected function get closeSound() : String
      {
         return null;
      }
      
      override public function close() : void
      {
         this.objectAPI.view.dispatchEvent(new Event("CLOSE"));
         api.setSession("lastCropPage",this.page);
         super.close();
      }
      
      private function handleCloseClicks(param1:Event) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         while(Boolean(_loc2_) && _loc2_ !== this)
         {
            if(_loc2_.name === "close")
            {
               api.playSound("granja/cierraSemilla");
               return this.close();
            }
            _loc2_ = _loc2_.parent;
         }
      }
   }
}
