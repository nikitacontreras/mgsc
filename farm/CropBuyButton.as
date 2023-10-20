package farm
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class CropBuyButton extends MovieClip
   {
       
      
      public var background:MovieClip;
      
      public var timeToGrow:MovieClip;
      
      public var cropName:TextField;
      
      public var cropPH:MovieClip;
      
      public var lock:MovieClip;
      
      public var unlocked:farm.CoinAsset;
      
      public var locked:MovieClip;
      
      public var crop:String;
      
      public function CropBuyButton()
      {
         super();
      }
   }
}
