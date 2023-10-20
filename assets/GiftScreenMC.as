package assets
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public dynamic class GiftScreenMC extends Sprite
   {
       
      
      public var loadingFriends:MovieClip;
      
      public var icon:MovieClip;
      
      public var send:assets.GameButton;
      
      public var friendList:MovieClip;
      
      public var errorText:TextField;
      
      public var title:TextField;
      
      public var inputField:TextField;
      
      public var close:SimpleButton;
      
      public function GiftScreenMC()
      {
         super();
      }
   }
}
