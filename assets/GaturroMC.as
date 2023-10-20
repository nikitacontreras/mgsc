package assets
{
   import adobe.utils.*;
   import flash.accessibility.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   
   public dynamic class GaturroMC extends MovieClip
   {
       
      
      public var chat_ph:MovieClip;
      
      public var icon:MovieClip;
      
      public var objects_ph:MovieClip;
      
      public var belly:MovieClip;
      
      public var medal_ph:MovieClip;
      
      public var foot1:MovieClip;
      
      public var foot2:MovieClip;
      
      public var transport:MovieClip;
      
      public var arm1:MovieClip;
      
      public var head:MovieClip;
      
      public var arm2:MovieClip;
      
      public var special_ph:MovieClip;
      
      public var transportMC:MovieClip;
      
      public var transportMC2:MovieClip;
      
      public function GaturroMC()
      {
         super();
      }
      
      public function reset() : void
      {
         head.eye1.color2.gotoAndStop(1);
         head.eye2.color2.gotoAndStop(1);
         head.mouth1.color1.gotoAndStop(1);
         head.mouth2.color1.gotoAndStop(1);
         head.eye1.gotoAndStop(1);
         head.eye2.gotoAndStop(1);
         head.mouth1.gotoAndStop(1);
         head.mouth2.gotoAndStop(1);
         headAction("reseted");
      }
      
      public function headAction(param1:String) : void
      {
         head.gotoAndStop(param1);
      }
      
      public function eyes(param1:String) : void
      {
         head.eye1.color2.gotoAndStop(1);
         head.eye2.color2.gotoAndStop(1);
         head.eye1.gotoAndStop(param1);
         head.eye2.gotoAndStop(param1);
      }
      
      public function mouth(param1:String) : void
      {
         head.mouth1.color1.gotoAndStop(1);
         head.mouth2.color1.gotoAndStop(1);
         head.mouth1.gotoAndStop(param1);
         head.mouth2.gotoAndStop(param1);
      }
   }
}
