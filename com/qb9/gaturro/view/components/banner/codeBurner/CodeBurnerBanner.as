package com.qb9.gaturro.view.components.banner.codeBurner
{
   import com.qb9.gaturro.commons.view.component.canvas.switcher.FrameCanvasSwitcher;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.util.giftcodes.Campaign;
   import com.qb9.gaturro.view.components.canvas.FrameCanvas;
   import com.qb9.gaturro.view.components.canvas.impl.codeBurner.CodeBurnerErrorCanvas;
   import com.qb9.gaturro.view.components.canvas.impl.codeBurner.CodeBurnerFeedbackCanvas;
   import com.qb9.gaturro.view.components.canvas.impl.codeBurner.CodeBurnerHelpCanvas;
   import com.qb9.gaturro.view.components.canvas.impl.codeBurner.CodeBurnerInputCanvas;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.MovieClip;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class CodeBurnerBanner extends InstantiableGuiModal
   {
      
      private static const MAX_ATTEMPTS:int = 5;
      
      private static const INPUT_CANVAS:String = "input";
      
      private static const ERROR_CANVAS:String = "error";
      
      private static const FEEDBACK_CANVAS:String = "feedback";
      
      private static const WAITTING_CANVAS:String = "waitting";
      
      private static const HELP_CANVAS:String = "help";
       
      
      private var intervalId:int;
      
      private var canvasSwitcher:FrameCanvasSwitcher;
      
      private var attemptsCount:int;
      
      private var campaignID:String;
      
      public function CodeBurnerBanner(param1:String = "codeBurnerBanner", param2:String = "CodeBurnerBannerAsset", param3:String = "GT")
      {
         this.campaignID = param3;
         super(param1,param2);
         this.setup();
      }
      
      private function showResult(param1:String) : void
      {
         clearTimeout(this.intervalId);
         if(this.canvasSwitcher.currentCanvas.id != WAITTING_CANVAS)
         {
            return;
         }
         if(param1 == "<error>")
         {
            this.showError("<error>");
            return;
         }
         if(param1 == "<usedcode>")
         {
            this.showError("<usedcode>");
            return;
         }
         this.canvasSwitcher.switchCanvas(FEEDBACK_CANVAS,param1);
      }
      
      override protected function ready() : void
      {
         super.ready();
         this.setupCanvas();
      }
      
      public function gotoHelp() : void
      {
         this.canvasSwitcher.switchCanvas(HELP_CANVAS);
      }
      
      public function goout() : void
      {
         this.close();
      }
      
      public function sendCode(param1:String) : void
      {
         var _loc2_:Campaign = null;
         if(param1)
         {
            this.canvasSwitcher.switchCanvas(WAITTING_CANVAS);
            _loc2_ = api.codeCampaign(this.campaignID);
            if(!_loc2_)
            {
               this.intervalId = setTimeout(this.showError,4000,"<error>");
               return;
            }
            _loc2_.codeCheck(this.showResult,param1);
            this.intervalId = setTimeout(this.showError,20000,"<time out>");
         }
         else
         {
            this.canvasSwitcher.switchCanvas(WAITTING_CANVAS);
         }
      }
      
      override public function close() : void
      {
         super.close();
      }
      
      private function showError(param1:String) : void
      {
         this.canvasSwitcher.switchCanvas(ERROR_CANVAS,param1);
      }
      
      private function setupCanvas() : void
      {
         var _loc1_:MovieClip = view.getChildByName("canvasContainer") as MovieClip;
         this.canvasSwitcher = new FrameCanvasSwitcher(_loc1_);
         this.canvasSwitcher.addCanvas(new CodeBurnerInputCanvas(INPUT_CANVAS,"input",_loc1_,this));
         this.canvasSwitcher.addCanvas(new FrameCanvas(WAITTING_CANVAS,"waitting",_loc1_,this));
         this.canvasSwitcher.addCanvas(new CodeBurnerFeedbackCanvas(FEEDBACK_CANVAS,"feedback",_loc1_,this));
         this.canvasSwitcher.addCanvas(new CodeBurnerErrorCanvas(ERROR_CANVAS,"error",_loc1_,this));
         this.canvasSwitcher.addCanvas(new CodeBurnerHelpCanvas(HELP_CANVAS,"help",_loc1_,this));
         this.canvasSwitcher.switchCanvas(INPUT_CANVAS);
      }
      
      private function setup() : void
      {
      }
      
      public function returnToInput() : void
      {
         if(this.attemptsCount < MAX_ATTEMPTS)
         {
            this.canvasSwitcher.switchCanvas(INPUT_CANVAS);
            ++this.attemptsCount;
         }
         else
         {
            this.goout();
         }
      }
   }
}
