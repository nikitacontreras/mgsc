package com.qb9.gaturro.view.gui.iphone2.screens
{
   import assets.Iphone2FriendLine;
   import assets.Iphone2ListMC;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.lang.AbstractMethodError;
   import com.qb9.flashlib.math.QMath;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import com.qb9.gaturro.world.community.Buddy;
   import com.qb9.gaturro.world.community.CommunityManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class InternalBuddiesListScreen extends InternalTitledScreen
   {
      
      private static const VISIBLE_ITEMS:uint = 24;
      
      private static const COLUMNS:uint = 3;
      
      private static const MARGIN:uint = 1;
       
      
      protected var originals:Dictionary;
      
      private var relationshipType:int;
      
      private var columnsQty:uint;
      
      private var itemsPerColumns:uint;
      
      private var currentPage:int = 0;
      
      private var firstElement:int = 0;
      
      private var visibleItems:uint;
      
      protected var views:Array;
      
      private var title:String;
      
      public function InternalBuddiesListScreen(param1:IPhone2Modal, param2:String, param3:int = 4)
      {
         super(param1,"",new Iphone2ListMC(),{
            "up":this.up,
            "down":this.down
         });
         this.relationshipType = param3;
         this.title = param2 + " - " + this.getSectionTitle(param3);
         this.visibleItems = VISIBLE_ITEMS;
         this.columnsQty = COLUMNS;
         this.init();
      }
      
      private function setLoadingVisible(param1:Boolean) : void
      {
         if(this.asset != null)
         {
            this.asset.loading.visible = param1;
         }
      }
      
      private function loadFirstFriends() : void
      {
         var _loc6_:DisplayObject = null;
         this.firstElement = QMath.clamp(0,0,user.community.totalBuddiesCount);
         DisplayUtil.empty(this.ph);
         var _loc1_:Array = this.views.slice(this.firstElement);
         var _loc2_:int = Math.min(_loc1_.length,this.visibleItems);
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ <= _loc2_ - 1)
         {
            _loc3_ = _loc5_ % this.columnsQty;
            _loc4_ = int(_loc5_ / this.columnsQty);
            _loc6_ = _loc1_[_loc5_];
            _loc6_.x = (_loc6_.width + MARGIN) * _loc3_;
            _loc6_.y = (_loc6_.height + MARGIN) * _loc4_;
            this.ph.addChild(_loc6_);
            _loc5_++;
         }
         this.updatePagers();
      }
      
      private function get maxIndex() : int
      {
         return Math.max(0,user.community.totalBuddiesCount - this.visibleItems);
      }
      
      protected function updateTitle() : void
      {
         return setTitle(region.getText(this.title) + " (" + user.community.totalBuddiesCount + ")");
      }
      
      private function init() : void
      {
         addEventListener(MouseEvent.CLICK,this.checkClick);
         setVisible("remove",false);
         setVisible("removeAll",false);
         this.currentPage = 0;
         if(!user.community.hasLoadedInitialBuddies())
         {
            user.community.addEventListener(CommunityManager.BUDDIES_BLOCK_LOADED,this.addedBlockOfBuddies);
            user.community.updateBuddiesBlock();
         }
         else
         {
            this.views = [];
            this.firstElement = 0;
            this.addedBlockOfBuddies();
         }
      }
      
      protected function selected(param1:Object) : void
      {
         throw new AbstractMethodError();
      }
      
      private function showFriends(param1:MouseEvent) : void
      {
         this.gotoOtherFriendsScreen(Buddy.FRIEND);
      }
      
      private function disposeItems() : void
      {
         var _loc1_:DisplayObject = null;
         for each(_loc1_ in this.views)
         {
            if(_loc1_ is IDisposable)
            {
               IDisposable(_loc1_).dispose();
            }
         }
         this.originals = null;
         this.views = null;
      }
      
      protected function up() : void
      {
         this.showSince(this.firstElement - this.visibleItems);
         --this.currentPage;
      }
      
      override public function dispose() : void
      {
         this.disposeItems();
         removeEventListener(MouseEvent.CLICK,this.checkClick);
         super.dispose();
      }
      
      private function addedBlockOfBuddies(param1:Event = null) : void
      {
         var _loc3_:Object = null;
         var _loc4_:DisplayObject = null;
         if(user.community.hasEventListener(CommunityManager.BUDDIES_BLOCK_LOADED))
         {
            user.community.removeEventListener(CommunityManager.BUDDIES_BLOCK_LOADED,this.addedBlockOfBuddies);
         }
         this.setLoadingVisible(false);
         this.disposeItems();
         this.originals = new Dictionary(true);
         this.views = [];
         this.firstElement = this.currentPage * user.community.buddiesBlock;
         for each(_loc3_ in user.community.buddies)
         {
            _loc4_ = this.map(_loc3_);
            this.views.push(_loc4_);
            this.originals[_loc4_] = _loc3_;
         }
         this.updateTitle();
         this.showSince(this.firstElement);
      }
      
      private function getSectionTitle(param1:int) : String
      {
         if(param1 == Buddy.FRIEND)
         {
            return region.getText("AMIGOS");
         }
         return "";
      }
      
      protected function map(param1:Object) : DisplayObject
      {
         var _loc2_:Buddy = param1 as Buddy;
         var _loc3_:Iphone2FriendLine = new Iphone2FriendLine();
         _loc3_.username.text = _loc2_.username.toUpperCase();
         _loc3_.gotoAndStop(_loc2_.online ? 2 : 1);
         return _loc3_;
      }
      
      private function checkClick(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         if(this.originals == null)
         {
            return;
         }
         while(_loc2_)
         {
            if(_loc2_ in this.originals)
            {
               iphoneSound();
               this.selected(this.originals[_loc2_]);
               break;
            }
            _loc2_ = _loc2_.parent;
         }
      }
      
      protected function down() : void
      {
         ++this.currentPage;
         if(!user.community.hasLoadedAllBudies())
         {
            this.disposeItems();
            this.setLoadingVisible(true);
            user.community.addEventListener(CommunityManager.BUDDIES_BLOCK_LOADED,this.addedBlockOfBuddies);
            user.community.updateBuddiesBlock();
         }
         else
         {
            this.showSince(this.firstElement + this.visibleItems);
         }
      }
      
      protected function gotoOtherFriendsScreen(param1:int) : void
      {
         goto(IPhone2Screens.FRIENDS,param1);
      }
      
      private function disposeFilter(param1:MovieClip) : void
      {
         param1.removeEventListener(MouseEvent.CLICK,this.showFriends);
      }
      
      private function get ph() : Sprite
      {
         return asset.ph;
      }
      
      private function updatePagers() : void
      {
         setEnabled("arrows.up",this.firstElement > 0);
         setEnabled("arrows.down",this.firstElement < this.maxIndex);
      }
      
      private function showSince(param1:int) : void
      {
         var _loc7_:DisplayObject = null;
         this.firstElement = QMath.clamp(param1,0,user.community.totalBuddiesCount);
         DisplayUtil.empty(this.ph);
         var _loc2_:Array = this.views.slice(this.firstElement);
         var _loc3_:int = Math.min(_loc2_.length,this.visibleItems);
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         while(_loc6_ <= _loc3_ - 1)
         {
            _loc4_ = _loc6_ % this.columnsQty;
            _loc5_ = int(_loc6_ / this.columnsQty);
            _loc7_ = _loc2_[_loc6_];
            _loc7_.x = (_loc7_.width + MARGIN) * _loc4_;
            _loc7_.y = (_loc7_.height + MARGIN) * _loc5_;
            this.ph.addChild(_loc7_);
            _loc6_++;
         }
         this.updatePagers();
      }
   }
}
