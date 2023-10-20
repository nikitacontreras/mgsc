package assets
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   public dynamic class SnakeGameMainMC extends MovieClip
   {
       
      
      public var scoreGroup:MovieClip;
      
      public var userCoin:GatuCoinAsset;
      
      public var snake_area:MovieClip;
      
      public var userCoinAmount:TextField;
      
      public var title:TextField;
      
      public var loseText:TextField;
      
      public var back:SimpleButton;
      
      public var playButton:MovieClip;
      
      public var wellcomeText:MovieClip;
      
      public function SnakeGameMainMC()
      {
         super();
      }
   }
}
