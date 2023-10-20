package com.qb9.gaturro.view.components.banner.albumHalloween2018
{
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.view.components.banner.dressingRoom.LoadingCanvas;
   import com.qb9.gaturro.view.components.canvas.common.ExplanationCanvas;
   import com.qb9.gaturro.view.components.canvas.common.ISwitchPostExplanation;
   import com.qb9.gaturro.view.gui.base.modal.AbstractCanvasFrameBanner;
   import flash.utils.setTimeout;
   
   public class AlbumHalloween2018Banner extends AbstractCanvasFrameBanner implements ISwitchPostExplanation
   {
       
      
      private var _taskRunner:TaskRunner;
      
      public function AlbumHalloween2018Banner()
      {
         super("albumHalloween2018","albumBannerAsset");
      }
      
      override protected function ready() : void
      {
         this.loadSettings();
         api.freeze();
         super.ready();
      }
      
      override protected function setInitialCanvasName() : void
      {
         initialCanvasName = "loading";
      }
      
      override public function dispose() : void
      {
         api.unfreeze();
         this._taskRunner.dispose();
         super.dispose();
      }
      
      private function loadSettings() : void
      {
         trace("loadSettings");
         this._taskRunner = new TaskRunner(view);
         this._taskRunner.start();
         setTimeout(this.switchCanvas,2000,"cardViewer");
      }
      
      public function switchToPostExplanation() : void
      {
         switchTo("cardViewer");
      }
      
      public function switchCanvas(param1:String, param2:Object = null) : void
      {
         switchTo(param1,param2);
      }
      
      override protected function setupCanvas() : void
      {
         addCanvas(new LoadingCanvas("loading","loading",canvasContainer,this));
         addCanvas(new AlbumHalloween2018Canvas("cardViewer","cardViewer",canvasContainer,this));
         addCanvas(new ExplanationCanvas("help","help",canvasContainer,this));
      }
      
      public function get taskRunner() : TaskRunner
      {
         return this._taskRunner;
      }
   }
}
