package com.qb9.gaturro.socialnet
{
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.socialnet.messages.AvatarImageMessage;
   import com.qb9.gaturro.socialnet.messages.ImageMessage;
   import com.qb9.gaturro.socialnet.messages.JoinedChallengeMessage;
   import com.qb9.gaturro.socialnet.messages.SceneImageMessage;
   import com.qb9.gaturro.socialnet.messages.ScoreMessage;
   import com.qb9.gaturro.socialnet.messages.SocialNetMessage;
   import com.qb9.gaturro.socialnet.messages.TextMessage;
   import com.qb9.gaturro.socialnet.messages.UserMessage;
   import com.qb9.gaturro.util.xmprpc.XMLRPCDataTypes;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import flash.utils.setTimeout;
   
   public class SocialNet
   {
       
      
      private var mailerResponse:GaturroMailer;
      
      private var successTestCallback:Function;
      
      private const DELAY:int = 500;
      
      private var errorTestCallback:Function;
      
      private const USERNAME_NOT_EXISTS:String = "Username does not exist!";
      
      public function SocialNet()
      {
         super();
      }
      
      public static function get enabled() : Boolean
      {
         return settings.socialNet && settings.services.socialNet.enabled && settings.services.socialNet.showUI && user.socialNetEn == true && user.socialNetShow == true;
      }
      
      public static function getJoinedChallengeMessage(param1:String, param2:String, param3:String) : JoinedChallengeMessage
      {
         return new JoinedChallengeMessage(settings.socialNet.joinedChallengeService,param1,param2,param3);
      }
      
      public static function getTextMessage(param1:String) : TextMessage
      {
         return new TextMessage(settings.socialNet.textService,param1);
      }
      
      public static function getUserMessage(param1:String) : UserMessage
      {
         return new UserMessage(settings.socialNet.userMessageService,param1);
      }
      
      public static function getSceneImageMessage(param1:BitmapData, param2:String) : SceneImageMessage
      {
         return new SceneImageMessage(settings.socialNet.sceneImageService,imgType,jpgQuality,param1,param2);
      }
      
      public static function getScoreMessage(param1:Object) : ScoreMessage
      {
         return new ScoreMessage(settings.socialNet.scoreService,param1);
      }
      
      private static function get imgType() : String
      {
         return settings.services.socialNet.imageType;
      }
      
      public static function get uiEenabled() : Boolean
      {
         return settings.socialNet && settings.services.socialNet.showUI && user.socialNetEn == true && user.socialNetShow == true;
      }
      
      public static function getComicImageMessage(param1:BitmapData, param2:String) : SceneImageMessage
      {
         return new SceneImageMessage(settings.socialNet.comicImageService,imgType,jpgQuality,param1,param2);
      }
      
      public static function getAvatarImageMessage(param1:Gaturro, param2:DisplayObjectContainer) : AvatarImageMessage
      {
         return new AvatarImageMessage(settings.socialNet.avatarImageService,imgType,jpgQuality,param1,param2,settings.services.socialNet.avatarImage);
      }
      
      public static function getAchievMessage(param1:String) : TextMessage
      {
         return new TextMessage(settings.socialNet.textService,param1);
      }
      
      private static function get jpgQuality() : int
      {
         return settings.services.socialNet.jpegQuality;
      }
      
      public function getComicImageMessage(param1:BitmapData, param2:String) : SceneImageMessage
      {
         return SocialNet.getComicImageMessage(param1,param2);
      }
      
      public function get enabled() : Boolean
      {
         return SocialNet.enabled;
      }
      
      public function testService(param1:Function, param2:Function) : void
      {
         this.successTestCallback = param1;
         this.errorTestCallback = param2;
         var _loc3_:SocialNetConnection = new SocialNetConnection();
         _loc3_.setUrl(settings.services.socialNet.api);
         _loc3_.addEventListener(Event.COMPLETE,this.serviceOk);
         _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.serviceError);
         _loc3_.addEventListener(IOErrorEvent.NETWORK_ERROR,this.serviceError);
         _loc3_.addEventListener(IOErrorEvent.VERIFY_ERROR,this.serviceError);
         _loc3_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.serviceError);
         _loc3_.addEventListener(ErrorEvent.ERROR,this.serviceError);
         _loc3_.call(settings.socialNet.testService);
         setTimeout(this.timeoutTestError,settings.services.socialNet.testTimeout);
      }
      
      private function error(param1:Event) : void
      {
         var _loc2_:SocialNetConnection = SocialNetConnection(param1.target);
         this.removeMessageEvents(_loc2_);
         var _loc3_:SocialNetMessage = _loc2_.message;
         if(!_loc3_.mustSendMail)
         {
            return;
         }
         this.sendMail(region.key("feedbackSubjectError"),region.key(_loc3_.feedbackErrorText));
      }
      
      public function set mailer(param1:GaturroMailer) : void
      {
         this.mailerResponse = param1;
      }
      
      public function get showUI() : Boolean
      {
         return settings.services.socialNet.showUI;
      }
      
      private function serviceError(param1:Event) : void
      {
         var _loc2_:SocialNetConnection = SocialNetConnection(param1.target);
         this.removeTestEvents(_loc2_);
         if(this.errorTestCallback != null)
         {
            this.errorTestCallback();
         }
         this.successTestCallback = null;
         this.errorTestCallback = null;
      }
      
      private function removeMessageEvents(param1:SocialNetConnection) : void
      {
         param1.removeEventListener(Event.COMPLETE,this.complete);
         param1.removeEventListener(IOErrorEvent.IO_ERROR,this.error);
         param1.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.error);
         param1.removeEventListener(IOErrorEvent.VERIFY_ERROR,this.error);
         param1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.error);
         param1.removeEventListener(ErrorEvent.ERROR,this.error);
      }
      
      private function sendMail(param1:String, param2:String) : void
      {
         this.mailerResponse.sendFakeMessage(region.key("feedbackMessageName"),param1,param2);
      }
      
      public function get setttingEnabled() : Boolean
      {
         return settings.services.socialNet.enabled;
      }
      
      public function sendMessage(param1:SocialNetMessage) : void
      {
         logger.debug("send message");
         if(param1 is ImageMessage && Boolean(settings.socialNet.useTestImagePhp))
         {
            setTimeout(this.sendTestMessage,this.DELAY,param1);
         }
         else
         {
            setTimeout(this.sendMessageNow,this.DELAY,param1);
         }
      }
      
      public function getSceneImageMessage(param1:BitmapData, param2:String) : SceneImageMessage
      {
         return SocialNet.getSceneImageMessage(param1,param2);
      }
      
      private function sendTestMessage(param1:SocialNetMessage) : void
      {
         var _loc2_:ImageMessage = null;
         var _loc3_:* = null;
         var _loc4_:URLRequest = null;
         var _loc5_:URLVariables = null;
         if(param1 is ImageMessage)
         {
            _loc2_ = ImageMessage(param1);
            _loc3_ = "http://lechuck/~mak/";
            if(param1 is SceneImageMessage)
            {
               _loc3_ += "scene.php";
            }
            if(param1 is AvatarImageMessage)
            {
               _loc3_ += "avatar.php";
            }
            (_loc4_ = new URLRequest(_loc3_)).method = URLRequestMethod.POST;
            (_loc5_ = new URLVariables()).image = _loc2_.imageString();
            _loc5_.tipo = imgType;
            _loc5_.nombreArchivo = "imagen." + imgType;
            _loc4_.data = _loc5_;
            navigateToURL(_loc4_,"_blank");
         }
      }
      
      private function removeTestEvents(param1:SocialNetConnection) : void
      {
         param1.removeEventListener(Event.COMPLETE,this.complete);
         param1.removeEventListener(IOErrorEvent.IO_ERROR,this.serviceError);
         param1.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.serviceError);
         param1.removeEventListener(IOErrorEvent.VERIFY_ERROR,this.serviceError);
         param1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.serviceError);
         param1.removeEventListener(ErrorEvent.ERROR,this.serviceError);
      }
      
      private function serviceOk(param1:Event) : void
      {
         var _loc2_:SocialNetConnection = SocialNetConnection(param1.target);
         this.removeTestEvents(_loc2_);
         if(this.successTestCallback != null)
         {
            this.successTestCallback();
         }
         this.successTestCallback = null;
         this.errorTestCallback = null;
      }
      
      private function timeoutTestError() : void
      {
         if(this.errorTestCallback != null)
         {
            this.errorTestCallback();
         }
         this.successTestCallback = null;
         this.errorTestCallback = null;
      }
      
      private function sendMessageNow(param1:SocialNetMessage) : void
      {
         var _loc2_:SocialNetConnection = new SocialNetConnection();
         _loc2_.setUrl(settings.services.socialNet.api);
         _loc2_.addEventListener(Event.COMPLETE,this.complete);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.error);
         _loc2_.addEventListener(IOErrorEvent.NETWORK_ERROR,this.error);
         _loc2_.addEventListener(IOErrorEvent.VERIFY_ERROR,this.error);
         _loc2_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.error);
         _loc2_.addEventListener(ErrorEvent.ERROR,this.error);
         var _loc3_:Array = new Array();
         param1.setParams(_loc3_);
         _loc2_.addParam(_loc3_,XMLRPCDataTypes.ARRAY);
         _loc2_.message = param1;
         _loc2_.call(param1.method);
      }
      
      private function complete(param1:Event) : void
      {
         var _loc2_:SocialNetConnection = SocialNetConnection(param1.target);
         this.removeMessageEvents(_loc2_);
         var _loc3_:SocialNetMessage = _loc2_.message;
         if(!_loc3_.mustSendMail)
         {
            return;
         }
         var _loc4_:Object;
         if((_loc4_ = _loc2_.getResponse()) == this.USERNAME_NOT_EXISTS || Boolean(_loc4_.Error))
         {
            this.sendMail(region.key("feedbackSubjectError"),region.key(_loc3_.feedbackErrorText));
         }
         else
         {
            this.sendMail(region.key("feedbackSubjectSuccess"),region.key(_loc3_.feedbackSuccessText));
         }
      }
   }
}
