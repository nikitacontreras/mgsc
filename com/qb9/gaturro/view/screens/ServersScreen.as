package com.qb9.gaturro.view.screens
{
   import assets.ServersScreenMC;
   import com.qb9.flashlib.lang.map;
   import com.qb9.flashlib.math.QMath;
   import com.qb9.flashlib.net.LoadFile;
   import com.qb9.flashlib.net.LoadFileFormat;
   import com.qb9.flashlib.tasks.Func;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.tracker;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.gaturro.view.screens.events.ServersScreenEvent;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public final class ServersScreen extends ServersScreenMC
   {
      
      private static const MARGIN:uint = 3;
      
      private static const SERVERS_PER_COLUMN:uint = 6;
      
      public static const LOCAL:String = "Local";
       
      
      private var buttons:Array;
      
      private var index:int = 0;
      
      private var columns:int = 2;
      
      public function ServersScreen()
      {
         super();
         this.init();
      }
      
      private function handleError(param1:String) : void
      {
         logger.warning(param1,"the directories from",this.url);
         dispatchEvent(new ServersScreenEvent(ServersScreenEvent.ERROR));
      }
      
      private function handleFile(param1:LoadFile) : void
      {
         if(!param1)
         {
            return this.handleError("Failed to load");
         }
         var _loc2_:Array = param1.data;
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(_loc2_[_loc4_].usage >= 1)
            {
               _loc3_.push(_loc2_.splice(_loc4_,1)[0]);
            }
            _loc4_++;
         }
         _loc2_.sortOn("usage",Array.DESCENDING);
         var _loc5_:Array;
         (_loc5_ = []).push(_loc2_[0],_loc2_[1]);
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_.push(_loc3_[_loc4_]);
            _loc4_++;
         }
         _loc4_ = 2;
         while(_loc4_ < _loc2_.length)
         {
            _loc5_.push(_loc2_[_loc4_]);
            _loc4_++;
         }
         _loc2_ = _loc5_;
         if(!_loc2_ || _loc2_ is Array === false)
         {
            return this.handleError("Invalid JSON while loading");
         }
         if(settings.debug.addLocalHost)
         {
            _loc2_.push({
               "name":LOCAL,
               "host":LOCAL
            });
         }
         this.buttons = map(_loc2_,this.createButton);
         ph.addEventListener(MouseEvent.CLICK,this.checkChooseServer);
         if(this.twoColumns)
         {
            if(this.maxIndex > 0)
            {
               this.setupArrows();
            }
         }
         else
         {
            this.setupSingleColumn();
         }
         this.draw();
         tracker.page(TrackActions.DIRECTORY_READY);
         dispatchEvent(new ServersScreenEvent(ServersScreenEvent.READY));
      }
      
      private function setChatEnabled(param1:Boolean) : void
      {
         signal.visible = !param1;
      }
      
      private function arrowState(param1:InteractiveObject, param2:Boolean) : void
      {
         param1.alpha = param2 ? 1 : 0.5;
         param1.mouseEnabled = param2;
      }
      
      private function draw() : void
      {
         var _loc2_:DisplayObject = null;
         this.arrowState(arrows.up,this.index > 0);
         this.arrowState(arrows.down,this.index < this.maxIndex);
         DisplayUtil.empty(ph);
         var _loc1_:int = 0;
         while(_loc1_ < this.serversPerScreen)
         {
            _loc2_ = this.buttons[_loc1_ + this.index];
            if(_loc2_)
            {
               this.addButton(_loc2_,_loc1_);
            }
            _loc1_++;
         }
      }
      
      private function get maxIndex() : int
      {
         return Math.max(this.buttons.length - this.serversPerScreen,0);
      }
      
      private function moveBy(param1:int) : void
      {
         this.index = QMath.clamp(this.index + param1,0,Number.MAX_VALUE);
         this.index = Math.floor(this.index / 2) * 2;
         this.draw();
      }
      
      private function init() : void
      {
         arrows.visible = false;
         var _loc1_:LoadFile = new LoadFile(this.url,LoadFileFormat.JSON,null,true);
         new Sequence(_loc1_,new Func(this.handleFile,_loc1_)).start();
         this.setChatEnabled(true);
         var _loc2_:LoadFile = new LoadFile(this.chatUrl,LoadFileFormat.JSON,null,true);
         new Sequence(_loc2_,new Func(this.handleChat,_loc2_)).start();
      }
      
      private function createButton(param1:Object) : Button
      {
         return new Button(param1);
      }
      
      private function handleArrowsClick(param1:Event) : void
      {
         switch(param1.target.name)
         {
            case "up":
               this.moveBy(-12);
               break;
            case "down":
               this.moveBy(12);
         }
      }
      
      private function choose(param1:Button) : void
      {
         if(param1.full)
         {
            return;
         }
         ph.removeEventListener(MouseEvent.CLICK,this.checkChooseServer);
         Telemetry.getInstance().trackEvent(TrackCategories.MMO,TrackActions.DIRECTORY_BTN + ":" + this.buttons.indexOf(param1));
         dispatchEvent(new ServersScreenEvent(ServersScreenEvent.CHOSE,param1.host,param1.port,param1.field.text));
      }
      
      private function setupSingleColumn() : void
      {
         this.columns = 1;
         gotoAndStop(3);
      }
      
      private function handleChat(param1:LoadFile) : void
      {
         if(!param1 || !param1.data)
         {
            logger.warning("Error loading chat state file.");
            return;
         }
         var _loc2_:* = param1.data.chat_mode == "true";
         this.setChatEnabled(_loc2_);
      }
      
      private function checkChooseServer(param1:Event) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         while(Boolean(_loc2_) && _loc2_ !== ph)
         {
            if(_loc2_ is Button)
            {
               this.choose(_loc2_ as Button);
               break;
            }
            _loc2_ = _loc2_.parent;
         }
      }
      
      private function setupArrows() : void
      {
         gotoAndStop(2);
         arrows.visible = true;
         arrows.addEventListener(MouseEvent.CLICK,this.handleArrowsClick);
      }
      
      private function get url() : String
      {
         return URLUtil.noCache(settings.connection.directory);
      }
      
      private function get twoColumns() : Boolean
      {
         return this.buttons.length > SERVERS_PER_COLUMN;
      }
      
      private function addButton(param1:DisplayObject, param2:int) : void
      {
         if(this.columns == 1)
         {
            param1.y = param2 * (param1.height + MARGIN);
         }
         else
         {
            param1.y = Math.floor(param2 / 2) * (param1.height + MARGIN);
            param1.x = !!(param2 % 2) ? param1.width + MARGIN : 0;
         }
         ph.addChild(param1);
      }
      
      private function get chatUrl() : String
      {
         return URLUtil.noCache(settings.connection.chatUrl);
      }
      
      private function get serversPerScreen() : int
      {
         return this.columns * SERVERS_PER_COLUMN;
      }
   }
}

import assets.ServerButton;
import com.qb9.flashlib.utils.DisplayUtil;
import com.qb9.gaturro.globals.region;

final class Button extends ServerButton
{
   
   private static const PROGRESS_ROUND:Number = 0.2;
   
   private static const SLOTS:Number = 5;
    
   
   private var port:uint;
   
   private var host:String;
   
   private var full:Boolean;
   
   public function Button(param1:Object)
   {
      var _loc3_:int = 0;
      super();
      region.setText(field,param1.name.toUpperCase());
      field.mouseEnabled = false;
      var _loc2_:Number = Number(param1.usage);
      this.full = _loc2_ >= 99;
      if(this.full)
      {
         DisplayUtil.disableMouse(this);
         alpha = 0.7;
      }
      else
      {
         buttonMode = true;
      }
      _loc3_ = Math.ceil(_loc2_ * SLOTS);
      if(_loc3_ < 0)
      {
         _loc3_ = 0;
      }
      progress.bar.scaleX = (_loc3_ || 1) / SLOTS;
      DisplayUtil.disableMouse(progress);
      this.host = param1.host;
      this.port = param1.port;
   }
}
