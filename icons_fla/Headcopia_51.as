package icons_fla
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
   
   public dynamic class Headcopia_51 extends MovieClip
   {
       
      
      public var accesories:MovieClip;
      
      public var mouths:MovieClip;
      
      public var mouth1:MovieClip;
      
      public var mouth2:MovieClip;
      
      public var hairs:MovieClip;
      
      public var eye1:MovieClip;
      
      public var ears1:MovieClip;
      
      public var hats:MovieClip;
      
      public var eye2:MovieClip;
      
      public var ears2:MovieClip;
      
      public function Headcopia_51()
      {
         super();
      }
      
      public function reset() : void
      {
         eye1.color2.gotoAndStop(1);
         eye2.color2.gotoAndStop(1);
         mouth1.color1.gotoAndStop(1);
         mouth2.color1.gotoAndStop(1);
         eye1.gotoAndStop(1);
         eye2.gotoAndStop(1);
         mouth1.gotoAndStop(1);
         mouth2.gotoAndStop(1);
      }
      
      public function eyes(param1:String) : void
      {
         eye1.gotoAndStop(param1);
         eye2.gotoAndStop(param1);
      }
      
      public function mouth(param1:String) : void
      {
         mouth1.gotoAndStop(param1);
         mouth2.gotoAndStop(param1);
      }
   }
}
