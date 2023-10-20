package com.qb9.gaturro.view.components.banner.fannysreward
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.service.passport.BubbleFlannysService;
   import com.qb9.gaturro.view.gui.banner.properties.IHasData;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class FannysRewardBanner extends InstantiableGuiModal implements IHasData, IHasRoomAPI
   {
      
      private static const COINS_REWARD:int = 3000;
       
      
      private var coinsRewards:TextField;
      
      private var acceptBtn:MovieClip;
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var teamName:String;
      
      private var _data:Object;
      
      private var pets:MovieClip;
      
      private var _rewardData:Object;
      
      private var petNameRewards:TextField;
      
      public function FannysRewardBanner(param1:String = "", param2:String = "")
      {
         super("fannysRewards","fannysRewardsAsset");
      }
      
      private function onConfirm(param1:MouseEvent) : void
      {
         var _loc2_:BubbleFlannysService = null;
         if(Context.instance.hasByType(BubbleFlannysService))
         {
            _loc2_ = Context.instance.getByType(BubbleFlannysService) as BubbleFlannysService;
         }
         else
         {
            _loc2_ = new BubbleFlannysService();
            _loc2_.init();
            Context.instance.addByType(_loc2_,BubbleFlannysService);
         }
         var _loc3_:Object = new Object();
         _loc3_.userName = api.user.username;
         _loc3_.token = _loc2_.funnysToken;
         this._roomAPI.startUnityMinigame("fluffyflaffy",0,null,_loc3_);
         close();
      }
      
      override protected function ready() : void
      {
         this.setupView();
      }
      
      public function set data(param1:Object) : void
      {
         this._rewardData = param1;
      }
      
      private function setupView() : void
      {
         var _loc1_:BubbleFlannysService = null;
         if(Context.instance.hasByType(BubbleFlannysService))
         {
            _loc1_ = Context.instance.getByType(BubbleFlannysService) as BubbleFlannysService;
         }
         else
         {
            _loc1_ = new BubbleFlannysService();
            _loc1_.init();
            Context.instance.addByType(_loc1_,BubbleFlannysService);
         }
         this.coinsRewards = view.getChildByName("coinsRewards") as TextField;
         this.petNameRewards = view.getChildByName("nombreFlanny") as TextField;
         this.acceptBtn = view.getChildByName("acceptBtn") as MovieClip;
         this.pets = view.getChildByName("pets") as MovieClip;
         this.pets.gotoAndStop(_loc1_.currentBreedCode);
         var _loc2_:int = api.getProfileAttribute("coins") as int;
         _loc2_ += COINS_REWARD;
         api.setProfileAttribute("system_coins",_loc2_);
         this.coinsRewards.text = COINS_REWARD.toString();
         this.petNameRewards.text = _loc1_.currentBreedName;
         this.acceptBtn.addEventListener(MouseEvent.CLICK,this.onConfirm);
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
   }
}
