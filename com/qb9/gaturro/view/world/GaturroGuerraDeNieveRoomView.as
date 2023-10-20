package com.qb9.gaturro.view.world
{
   import com.adobe.serialization.json.JSON;
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.tasks.Parallel;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.flashlib.tasks.TaskEvent;
   import com.qb9.flashlib.tasks.Wait;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.libs;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.view.world.avatars.GaturroAvatarView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.core.attributes.events.CustomAttributeEvent;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.world.avatars.Avatar;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class GaturroGuerraDeNieveRoomView extends GaturroRoomView
   {
       
      
      private var balls:Array;
      
      private var _timeoutId:uint;
      
      private var _messageCount:int;
      
      private var currentTarget:Point;
      
      private var canShootAgain:Boolean = true;
      
      private const MAX_BALLS:int = 50;
      
      private var messageChangedHandlerMap:Dictionary;
      
      public function GaturroGuerraDeNieveRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:GaturroMailer, param5:WhiteListNode)
      {
         super(param1,param3,param4,param5);
      }
      
      private function onKeyPressed(param1:KeyboardEvent) : void
      {
         var _loc2_:Object = null;
         if(gui.modal)
         {
            return;
         }
         if(Boolean(api.getSession("noBalls")) && api.getBalanceFromUser("nieve2017/props.ball") < 1)
         {
            api.setSession("noBalls",true);
            api.showModal("NO TIENES BOLAS DE NIEVE","nieve2017/props.pilaNieve");
            return;
         }
         if(!this.canShootAgain)
         {
            return;
         }
         api.takeFromUser("nieve2017/props.ball");
         if(param1.keyCode == Keyboard.SPACE)
         {
            this.canShootAgain = false;
            _loc2_ = {};
            _loc2_.id = api.userAvatar.avatarId;
            _loc2_.to = this.currentTarget;
            api.sendMessage("shoot",_loc2_);
            api.playSound("nieve2017/enemyHit");
         }
      }
      
      private function setupMesssageChangedHandlerMap() : void
      {
         this.messageChangedHandlerMap = new Dictionary();
         this.messageChangedHandlerMap["shoot"] = this.processShootMessage;
      }
      
      override protected function whenReady() : void
      {
         this.setup();
      }
      
      private function showMessage() : void
      {
         clearTimeout(this._timeoutId);
         if(this._messageCount > 2)
         {
            return;
         }
         ++this._messageCount;
         var _loc1_:String = Math.random() > 0.5 ? "ARROJA NIEVE CON LA BARRA ESPACIADORA" : "ARROJA NIEVE CON LA TECLA ESPACIO";
         api.textMessageToGUI(_loc1_);
         this._timeoutId = setTimeout(this.showMessage,3200);
      }
      
      private function cleanBalls() : void
      {
         var _loc1_:MovieClip = null;
         if(this.balls.length > this.MAX_BALLS)
         {
            _loc1_ = this.balls.shift();
            DisplayUtil.remove(_loc1_);
            _loc1_ = null;
         }
      }
      
      private function onMouseMoved(param1:MouseEvent) : void
      {
         this.currentTarget = userView.globalToLocal(new Point(mouseX,mouseY));
      }
      
      protected function move(param1:Number, param2:DisplayObject, param3:Point) : void
      {
         var complete:Sequence;
         var tx:Tween;
         var ty:Sequence;
         var speed:Number;
         var time:Number;
         var lag:Wait;
         var ty1:Tween;
         var maxHeihgt:Number;
         var ty2:Tween;
         var midPoint:Point;
         var distance:Number;
         var parabolic:Parallel;
         var shooter:Number = param1;
         var object:DisplayObject = param2;
         var to:Point = param3;
         DisplayUtil.reparentTo(object,background["layer3"]);
         speed = 0.4;
         distance = new Point(to.x,to.y).length;
         time = distance / speed;
         tx = new Tween(object,time,{"x":object.x + to.x});
         midPoint = new Point((object.x + to.x) / 2,(object.y + to.y) / 2);
         maxHeihgt = this.map(distance,0,800,0,100);
         ty1 = new Tween(object,time / 2,{"y":object.y + midPoint.y - maxHeihgt},{"transition":"easeout"});
         ty2 = new Tween(object,time / 2,{"y":object.y + to.y},{"transition":"easein"});
         ty = new Sequence(ty1,ty2);
         parabolic = new Parallel(tx,ty);
         parabolic.addEventListener(TaskEvent.COMPLETE,function():void
         {
            (object as MovieClip).gotoAndStop("activate");
         });
         lag = new Wait(1000);
         complete = new Sequence(parabolic,lag);
         complete.addEventListener(TaskEvent.COMPLETE,function():void
         {
            if(shooter == api.userAvatar.avatarId)
            {
               canShootAgain = true;
            }
            DisplayUtil.reparentTo(object,background["layer2"]);
         });
         tasks.add(complete);
         (object as MovieClip).gotoAndStop("rotate");
      }
      
      private function map(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Number
      {
         return param4 + (param5 - param4) * ((param1 - param2) / (param3 - param2));
      }
      
      private function shoot(param1:Object) : void
      {
         libs.fetch("nieve2017/props.ball_on",this.onFetchCompleted,param1);
      }
      
      override protected function finalInit() : void
      {
         super.finalInit();
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoved);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyPressed);
         this._timeoutId = setTimeout(this.showMessage,1000);
      }
      
      private function onMessageChanged(param1:CustomAttributeEvent) : void
      {
         var _loc2_:Object = com.adobe.serialization.json.JSON.decode(String(param1.attribute.value));
         var _loc3_:Function = this.messageChangedHandlerMap[_loc2_.action];
         _loc3_(_loc2_);
      }
      
      override public function dispose() : void
      {
         var _loc1_:MovieClip = null;
         clearTimeout(this._timeoutId);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoved);
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyPressed);
         for each(_loc1_ in this.balls)
         {
            DisplayUtil.remove(_loc1_);
            _loc1_ = null;
         }
         this.balls = null;
         super.dispose();
      }
      
      protected function onFetchCompleted(param1:DisplayObject, param2:Object) : void
      {
         var avatar:GaturroAvatarView;
         var toPoint:Point = null;
         var algo:DisplayObject = null;
         var displayObject:DisplayObject = param1;
         var message:Object = param2;
         this.balls.push(displayObject);
         this.cleanBalls();
         avatar = getAvatarView(message.params.id);
         while(avatar.clip.arm1.gripFore.numChildren > 0)
         {
            algo = avatar.clip.arm1.gripFore.removeChildAt(0);
            algo = null;
         }
         if(message.params.id == api.userAvatar.avatarId)
         {
            if(avatar.x - message.params.to.x < 0)
            {
               api.setAvatarAttribute("effect","lookRight");
            }
            else
            {
               api.setAvatarAttribute("effect","lookLeft");
            }
            api.setAvatarAttribute("action","throw");
         }
         avatar.clip.arm1.gripFore.addChild(displayObject);
         toPoint = new Point(message.params.to.x,message.params.to.y);
         setTimeout(function():void
         {
            move(message.params.id,displayObject,toPoint);
         },500);
      }
      
      override protected function createAvatar(param1:Avatar) : DisplayObject
      {
         var _loc2_:DisplayObject = super.createAvatar(param1);
         param1.addCustomAttributeListener("message",this.onMessageChanged);
         return _loc2_;
      }
      
      private function processShootMessage(param1:Object) : void
      {
         this.shoot(param1);
      }
      
      protected function setup() : void
      {
         this.balls = [];
         this.setupMesssageChangedHandlerMap();
      }
   }
}
