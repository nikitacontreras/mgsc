package com.qb9.gaturro.view.screens
{
   import assets.LoadingScreenGranjaMC;
   import assets.LoadingScreenMC;
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.net.LoadFile;
   import com.qb9.flashlib.net.LoadFileFormat;
   import com.qb9.flashlib.tasks.Func;
   import com.qb9.flashlib.tasks.ITask;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.gaturro.util.advertising.EPlanning;
   import com.qb9.gaturro.util.advertising.EPlanningEvent;
   import com.qb9.mambo.view.loading.BaseLoadingScreen;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class GaturroLoadingScreen extends BaseLoadingScreen
   {
      
      public static const DEFAULT:String = "DEFAULT_SCREEN";
      
      private static const FADE_DURATION:uint = 400;
      
      public static const GRANJA:String = "GRANJA_SCREEN";
      
      private static const LONG_DURATION:uint = 40000;
      
      public static var TYPE:String = DEFAULT;
      
      private static const SHORT_DURATION:uint = 750;
       
      
      private var loadingData:Object;
      
      private var tasks:TaskRunner;
      
      private var asset:MovieClip;
      
      private var stepTask:ITask;
      
      private var withTips:Boolean = true;
      
      public function GaturroLoadingScreen(param1:Boolean = true, param2:Object = null)
      {
         super();
         this.withTips = param1;
         this.loadingData = param2;
      }
      
      override protected function draw() : void
      {
         var _loc1_:LoadFile = null;
         this.tasks = new TaskRunner(this);
         this.tasks.start();
         switch(TYPE)
         {
            case GRANJA:
               this.asset = new LoadingScreenGranjaMC();
               break;
            default:
               this.asset = new LoadingScreenMC();
         }
         addChild(this.asset);
         this.stepTask = this.makeTask(LONG_DURATION);
         this.tasks.add(this.stepTask);
         if(this.withTips)
         {
            _loc1_ = new LoadFile(this.tipsUrl,LoadFileFormat.SWF);
            new Sequence(_loc1_,new Func(this.handleTips,_loc1_)).start();
         }
      }
      
      private function randomizeSigns(param1:MovieClip) : void
      {
         var _loc2_:int = Math.floor(Math.random() * param1.totalFrames) + 1;
         param1.gotoAndStop(_loc2_);
      }
      
      private function handleTips(param1:LoadFile) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:MovieClip = null;
         var _loc5_:Boolean = false;
         if(!param1 || !param1.data)
         {
            return;
         }
         var _loc2_:MovieClip = param1.data as MovieClip;
         this.asset.ph.addChild(_loc2_);
         for each(_loc3_ in DisplayUtil.children(_loc2_))
         {
            _loc3_.visible = false;
         }
         if(!(_loc4_ = _loc2_.getChildByName("signs_" + region.country) as MovieClip))
         {
            _loc4_ = _loc2_.getChildByName("signs") as MovieClip;
         }
         _loc4_.x = 0;
         _loc4_.y = 0;
         _loc4_.visible = true;
         if(this.loadingData && this.loadingData.nextRoom && this.roomType(this.loadingData.nextRoom) != "normal")
         {
            trace("INGRESANDO A UN ROOM DE TIPO: " + this.roomType(this.loadingData.nextRoom));
            _loc5_ = false;
            while(!_loc5_)
            {
               this.randomizeSigns(_loc4_);
               if(this.roomType(this.loadingData.nextRoom) == "boca" && _loc4_.currentLabel != "river")
               {
                  _loc5_ = true;
               }
               if(this.roomType(this.loadingData.nextRoom) == "river" && _loc4_.currentLabel != "boca")
               {
                  _loc5_ = true;
               }
            }
         }
         else
         {
            this.randomizeSigns(_loc4_);
         }
      }
      
      private function adLoaded(param1:EPlanningEvent) : void
      {
         EPlanning(param1.currentTarget).removeEventListener(EPlanningEvent.CONTENT_LOADED,this.adLoaded);
         if(param1.content)
         {
            this.asset.eplanning.addChild(param1.content);
         }
      }
      
      override public function hide() : void
      {
         if(!this.tasks)
         {
            return;
         }
         this.tasks.remove(this.stepTask);
         this.tasks.add(new Sequence(this.makeTask(SHORT_DURATION),new Tween(this,FADE_DURATION,{"alpha":0},{"transition":"easein"}),new Func(this.dispose)));
      }
      
      private function tipsRoomFilter(param1:int) : Boolean
      {
         return true;
      }
      
      private function loadEplanning(param1:String) : void
      {
         var _loc3_:EPlanning = null;
         var _loc2_:Boolean = false;
         if(EPlanning.isValidTag(param1))
         {
            _loc3_ = new EPlanning();
            _loc3_.addEventListener(EPlanningEvent.CONTENT_LOADED,this.adLoaded);
            _loc3_.loadByTag(param1);
            _loc2_ = true;
         }
      }
      
      private function roomType(param1:int) : String
      {
         if(param1 >= 51688824 && param1 <= 51688834)
         {
            return "boca";
         }
         if(param1 >= 51689003 && param1 <= 51689023)
         {
            return "boca";
         }
         if(param1 == 69405)
         {
            return "boca";
         }
         if(param1 == 69404)
         {
            return "river";
         }
         if(param1 >= 51689578 && param1 <= 51689591)
         {
            return "river";
         }
         if(param1 == 51689814)
         {
            return "river";
         }
         return "normal";
      }
      
      private function get tipsUrl() : String
      {
         var _loc1_:String = URLUtil.getUrl("ui/tips.swf");
         return URLUtil.versionedPath(_loc1_);
      }
      
      private function makeTask(param1:uint) : ITask
      {
         return new Tween(this.asset.progressBar.bar,param1,{"x":0},{"transition":"cubiceaseout"});
      }
      
      override public function dispose() : void
      {
         DisplayUtil.dispose(this);
         if(this.tasks)
         {
            this.tasks.dispose();
         }
         this.tasks = null;
         super.dispose();
      }
   }
}
