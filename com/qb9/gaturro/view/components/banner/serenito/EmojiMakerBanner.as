package com.qb9.gaturro.view.components.banner.serenito
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.manager.counter.GaturroCounterManager;
   import com.qb9.gaturro.view.components.canvas.common.ExplanationCanvas;
   import com.qb9.gaturro.view.components.canvas.common.ISwitchPostExplanation;
   import com.qb9.gaturro.view.components.canvas.impl.composer.ComposerCanvas;
   import com.qb9.gaturro.view.components.canvas.impl.composer.ComposerDisplayCanvas;
   import com.qb9.gaturro.view.components.canvas.impl.composer.IComposerClient;
   import com.qb9.gaturro.view.gui.base.modal.AbstractCanvasFrameBanner;
   
   public class EmojiMakerBanner extends AbstractCanvasFrameBanner implements IComposerClient, ISwitchPostExplanation
   {
      
      private static const DISPLAY:String = "display";
      
      private static const EMOJI_MASK_PREFIX:String = "serenito2017/wears.mascara";
      
      private static const EDITOR:String = "editor";
      
      private static const TIME_STAMP_ID:String = "serenitoMask";
      
      private static const EXPLANATION:String = "explanation";
      
      private static const COUNTER_ID:String = "serenitoMask";
      
      private static const REJECT:String = "reject";
       
      
      private var resultingItemName:String;
      
      private var result:Array;
      
      private var counterManager:GaturroCounterManager;
      
      public function EmojiMakerBanner()
      {
         super("EmojiMakerBanner","EmojiMakerAsset");
         this.setup();
      }
      
      private function setResultingItemName() : void
      {
         this.resultingItemName = EMOJI_MASK_PREFIX + this.result[0] + "_" + this.result[1] + "_" + this.result[2];
      }
      
      override protected function setInitialCanvasName() : void
      {
         initialCanvasName = EXPLANATION;
      }
      
      private function setResultAndDisplay(param1:Array) : void
      {
         this.result = param1;
         this.setResultingItemName();
         switchTo(DISPLAY,param1);
      }
      
      public function switchToPostExplanation() : void
      {
         if(getCurrentCanvasName() == EXPLANATION)
         {
            switchTo(EDITOR);
         }
         else if(getCurrentCanvasName() == REJECT)
         {
            close();
         }
      }
      
      public function setResult(param1:Array) : void
      {
         if(Boolean(this.counterManager) && this.counterManager.reachedMax(COUNTER_ID))
         {
            this.counterManager.reset(COUNTER_ID);
            this.setResultAndDisplay(param1);
         }
         else
         {
            this.setResultAndDisplay(param1);
         }
      }
      
      override protected function ready() : void
      {
         super.ready();
      }
      
      override protected function setupCanvas() : void
      {
         addCanvas(new com.qb9.gaturro.view.components.canvas.common.ExplanationCanvas(EXPLANATION,EXPLANATION,canvasContainer,this));
         addCanvas(new ComposerCanvas(EDITOR,EDITOR,canvasContainer,this));
         addCanvas(new ComposerDisplayCanvas(DISPLAY,DISPLAY,canvasContainer,this));
         addCanvas(new com.qb9.gaturro.view.components.canvas.common.ExplanationCanvas(REJECT,REJECT,canvasContainer,this));
      }
      
      public function complete() : void
      {
         api.giveUser(this.resultingItemName);
         api.trackEvent("FEATURES:SERENITO2017:EMOJI_MAKER:ARMA_MASCARA",this.resultingItemName);
         this.counterManager.increase(COUNTER_ID);
         close();
      }
      
      private function setup() : void
      {
         this.counterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
      }
   }
}
