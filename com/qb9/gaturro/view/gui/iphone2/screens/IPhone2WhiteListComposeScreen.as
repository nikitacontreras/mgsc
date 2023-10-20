package com.qb9.gaturro.view.gui.iphone2.screens
{
   import assets.Iphone2WLSendMC;
   import assets.WLEditButton2MC;
   import assets.WLReadButton2MC;
   import com.qb9.flashlib.lang.foreach;
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import com.qb9.gaturro.view.world.whitelist.WhiteListPane;
   import com.qb9.gaturro.view.world.whitelist.WhiteListViewEvent;
   import com.qb9.gaturro.whitelist.IPhoneWhiteListVariableReplacer;
   import com.qb9.gaturro.whitelist.WhiteListVariableReplacer;
   import com.qb9.gaturro.world.community.Buddy;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public final class IPhone2WhiteListComposeScreen extends InternalComposeScreen
   {
      
      private static const ITEM_HEIGHT:uint = 22;
      
      private static const MAX_ITEMS:uint = 4;
       
      
      private var buddy:Buddy = null;
      
      private var whitelist:WhiteListNode;
      
      private var tasks:TaskContainer;
      
      private var selector:WLEditButton2MC;
      
      private var pane:WhiteListPane;
      
      private var variables:WhiteListVariableReplacer;
      
      private var ids:Array;
      
      public function IPhone2WhiteListComposeScreen(param1:IPhone2Modal, param2:WhiteListNode, param3:TaskContainer, param4:InternalMessageData = null, param5:Buddy = null)
      {
         this.ids = [];
         super(param1,new Iphone2WLSendMC(),param4,{"choose_text":this.openSelector});
         this.buddy = param5;
         this.whitelist = param2;
         this.variables = new IPhoneWhiteListVariableReplacer();
         this.tasks = param3;
         this.init();
      }
      
      override protected function backButton() : void
      {
         var _loc1_:Object = null;
         if(this.buddy != null)
         {
            _loc1_ = new Object();
            _loc1_.buddy = this.buddy;
            back(IPhone2Screens.SEE_FRIEND,_loc1_);
         }
         else
         {
            back(IPhone2Screens.MESSAGES);
         }
      }
      
      override public function dispose() : void
      {
         if(userField.hasEventListener(Event.CHANGE))
         {
            userField.removeEventListener(Event.CHANGE,this.whenReceiverTextChanges);
         }
         this.disposePane();
         this.whitelist = null;
         this.variables = null;
         this.tasks = null;
         this.selector = null;
         super.dispose();
      }
      
      private function openSelector() : void
      {
         var _loc1_:Sprite = null;
         this.disposePane();
         this.pane = new WhiteListPane(this.whitelist,this.variables,this.tasks);
         this.pane.addEventListener(WhiteListViewEvent.MESSAGE_SELECTED,this.addMessage);
         _loc1_ = this.paneContainer;
         _loc1_.addChild(this.pane);
         this.pane.x = DisplayUtil.offsetX(this.selector,_loc1_) + this.pane.width;
         this.pane.y = DisplayUtil.offsetY(this.selector,_loc1_) + this.selector.height + this.pane.height;
      }
      
      private function whenReceiverTextChanges(param1:Event) : void
      {
         delay(this.updateAllTexts);
      }
      
      private function updateText(param1:int) : void
      {
         var _loc2_:WLReadButton2MC = this.itemHolder.getChildAt(param1) as WLReadButton2MC;
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:String = receiver === DEFAULT_RECEIVER_TEXT ? "" : receiver;
         var _loc4_:int = int(this.ids[param1]);
         _loc2_.field.text = region.getText(MailUtil.fromKey(_loc4_,this.whitelist,_loc3_));
      }
      
      private function init() : void
      {
         this.selector = new WLEditButton2MC();
         this.itemHolder.addChild(this.selector);
         if(this.buddy != null)
         {
            userField.mouseEnabled = false;
            userField.selectable = false;
            userField.tabEnabled = false;
            setVisible("choose",false);
            setVisible("nameShort",false);
            setVisible("nameLarge",true);
         }
         else
         {
            userField.addEventListener(Event.CHANGE,this.whenReceiverTextChanges);
            setVisible("choose",true);
            setVisible("nameShort",true);
            setVisible("nameLarge",false);
         }
      }
      
      private function addId(param1:Number) : void
      {
         var _loc2_:WLReadButton2MC = new WLReadButton2MC();
         _loc2_.buttonMode = true;
         _loc2_.addEventListener(MouseEvent.CLICK,this.removeButton);
         this.itemHolder.addChild(_loc2_);
         this.ids.push(param1);
         this.itemHolder.addChild(this.selector);
         this.updateText(this.ids.length - 1);
         this.updatePositions();
      }
      
      private function removeButton(param1:Event) : void
      {
         var _loc2_:WLReadButton2MC = param1.currentTarget as WLReadButton2MC;
         var _loc3_:int = this.itemHolder.getChildIndex(_loc2_);
         this.ids.splice(_loc3_,1);
         this.itemHolder.removeChildAt(_loc3_);
         this.disposePane();
         this.updatePositions();
      }
      
      private function get itemHolder() : Sprite
      {
         return asset.ph as Sprite;
      }
      
      private function updatePositions() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.itemHolder.numChildren)
         {
            this.itemHolder.getChildAt(_loc1_).y = ITEM_HEIGHT * _loc1_;
            _loc1_++;
         }
         this.selector.visible = _loc1_ <= MAX_ITEMS;
      }
      
      private function disposePane() : void
      {
         if(!this.pane)
         {
            return;
         }
         this.pane.dispose();
         this.pane.removeEventListener(WhiteListViewEvent.MESSAGE_SELECTED,this.addMessage);
         DisplayUtil.dispose(this.pane);
         this.pane = null;
      }
      
      override protected function get message() : Object
      {
         return !!this.ids.length ? this.ids : null;
      }
      
      private function addMessage(param1:WhiteListViewEvent) : void
      {
         this.addId(param1.node.key);
         this.disposePane();
      }
      
      override protected function copy(param1:InternalMessageData) : void
      {
         super.copy(param1);
         var _loc2_:Array = param1.message as Array;
         if(_loc2_)
         {
            foreach(_loc2_,this.addId);
         }
      }
      
      private function get paneContainer() : Sprite
      {
         return parent.parent.parent.parent as Sprite;
      }
      
      private function updateAllTexts() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.ids.length)
         {
            this.updateText(_loc1_);
            _loc1_++;
         }
      }
   }
}
