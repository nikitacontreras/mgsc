package com.qb9.gaturro.view.gui.iphone2.screens
{
   import assets.IPhone2WaitingMC;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.util.TimingUtil;
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   internal class InternalWaitingScreen extends BaseIPhone2Screen
   {
       
      
      private var callback:Function;
      
      private var timeoutId:int;
      
      public function InternalWaitingScreen(param1:IPhone2Modal)
      {
         super(param1,new IPhone2WaitingMC(),{});
      }
      
      private function step(param1:Event = null) : void
      {
         if(this.callback !== null)
         {
            iphoneSound();
            this.callback();
            this.callback = null;
         }
      }
      
      protected function show(param1:String, param2:Function) : void
      {
         this.callback = param2;
         region.setText(asset.field,param1.toUpperCase());
         asset.gotoAndStop(2);
         addEventListener(MouseEvent.CLICK,this.step);
         buttonMode = true;
         this.timeoutId = setTimeout(this.step,TimingUtil.getReadDelay(param1));
      }
      
      override public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.step);
         this.callback = null;
         clearTimeout(this.timeoutId);
         super.dispose();
      }
   }
}
