package com.qb9.gaturro.net.security.files
{
   import com.hurlant.crypto.hash.MD5;
   import com.hurlant.crypto.rsa.RSAKey;
   import com.hurlant.util.Hex;
   import com.hurlant.util.der.PEM;
   import com.qb9.flashlib.events.QEvent;
   import com.qb9.gaturro.GameData;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.util.errors.FileControlFailure;
   import flash.events.EventDispatcher;
   import flash.net.URLLoader;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   
   public class FileControl extends EventDispatcher
   {
      
      public static const FILE_CONTROL_NOT_EXECUTED:int = 3;
      
      public static const FILE_VIOLATION:String = "FILE_VIOLATION";
      
      public static const FILE_CONTROL_ERROR:int = 2;
      
      public static const FILE_CONTROL_SUCCESS:int = 1;
       
      
      private var register:Boolean = true;
      
      private var hashPerFile:Dictionary;
      
      private var kick:Boolean = false;
      
      private const debug:Boolean = false;
      
      private var errorsFound:Array;
      
      private var rsaPublicKey:RSAKey;
      
      public function FileControl()
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         this.errorsFound = new Array();
         super();
         var _loc1_:int = 0;
         this.hashPerFile = new Dictionary(true);
         if(this.debug)
         {
            logger.debug("file control init: ");
         }
         if(!(GameData.RESOURSES_HASH is Array))
         {
            api.trackEvent("HACKING:HASH","user:" + api.user.username);
            throw new Error("Inconcistente Hash Resource ");
         }
         for each(_loc2_ in GameData.RESOURSES_HASH)
         {
            _loc1_++;
            _loc3_ = String(_loc2_[1]);
            _loc4_ = String(_loc2_[0]);
            if(this.debug)
            {
               logger.debug(_loc3_,_loc4_);
            }
            this.hashPerFile[_loc3_] = _loc4_;
         }
         this.rsaPublicKey = PEM.readRSAPublicKey(GameData.filesHashPublicKey);
      }
      
      private function returnSuccess() : int
      {
         if(this.debug)
         {
            logger.debug("file control success");
         }
         return FILE_CONTROL_SUCCESS;
      }
      
      private function errorOcurred(param1:String, param2:String, param3:String = "", param4:String = "") : void
      {
         var _loc5_:FileControlFailure = new FileControlFailure(param1,param2,param3,param4);
         if(Boolean(api) && api.user.username.indexOf("MROVERE") != -1)
         {
            logger.error("file control failure: ",_loc5_);
         }
         if(this.debug)
         {
            logger.debug("file control failure: ",_loc5_);
         }
         if(this.register)
         {
            Telemetry.getInstance().trackEvent(TrackCategories.SECURITY,TrackActions.FILE_HASH_FAILED + ":" + param1,"",0);
         }
         if(this.kick)
         {
            setTimeout(dispatchEvent,500,new FileControlEvent(FileControlEvent.CONTROL_FAILED,_loc5_));
         }
      }
      
      public function executeOnURLLoader(param1:String, param2:URLLoader) : int
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeMultiByte(String(param2.data),"utf-8");
         return this.execute(param1,_loc3_);
      }
      
      public function get errors() : Array
      {
         return this.errorsFound.slice();
      }
      
      public function set mustRegister(param1:Boolean) : void
      {
         this.register = param1;
      }
      
      private function returnNotExecuted() : int
      {
         if(this.debug)
         {
            logger.debug("file control not executed");
         }
         return FILE_CONTROL_NOT_EXECUTED;
      }
      
      public function execute(param1:String, param2:ByteArray) : int
      {
         var resultText:String = null;
         var encHashStr:String = null;
         var encryptedHashHex:ByteArray = null;
         var decryptedHash:ByteArray = null;
         var decHashStr:String = null;
         var md5:MD5 = null;
         var hash:ByteArray = null;
         var fileSavedHash:String = null;
         var relativeURL:String = param1;
         var fileByteArray:ByteArray = param2;
         if(this.debug)
         {
            logger.debug("executing file control: ",relativeURL);
         }
         resultText = "ControlFile ";
         if(!this.rsaPublicKey)
         {
            resultText += "No PK";
            this.errorOcurred(relativeURL,"No PK");
            return this.returnError();
         }
         try
         {
            encHashStr = String(this.hashPerFile[relativeURL]);
            if(this.debug)
            {
               logger.debug("saved hash: ",encHashStr);
            }
            if(encHashStr != null && encHashStr != "undefined")
            {
               encryptedHashHex = Hex.toArray(encHashStr);
               decryptedHash = new ByteArray();
               this.rsaPublicKey.verify(encryptedHashHex,decryptedHash,encryptedHashHex.length);
               decHashStr = decryptedHash.toString();
               md5 = new MD5();
               hash = md5.hash(fileByteArray);
               fileSavedHash = Hex.fromArray(hash);
               if(fileSavedHash != decHashStr)
               {
                  resultText += relativeURL + " / " + fileSavedHash + " vs " + decHashStr + " --> Violation";
                  if(Boolean(user) && Boolean(user.isAdmin))
                  {
                     if(this.debug)
                     {
                        logger.debug(resultText);
                     }
                  }
                  this.dispatchEvent(new QEvent(FileControl.FILE_VIOLATION,resultText));
                  this.errorsFound.push(resultText);
                  this.errorOcurred(relativeURL,"Violation",fileSavedHash,decHashStr);
                  return this.returnError();
               }
               if(this.debug)
               {
                  logger.debug("success");
               }
               return this.returnSuccess();
            }
            if(this.debug)
            {
               logger.debug("hash null or undefined",fileSavedHash,decHashStr);
            }
            return this.returnNotExecuted();
         }
         catch(e:Error)
         {
            resultText += " Error catch " + relativeURL;
            if(user.isAdmin)
            {
               logger.debug(resultText);
            }
            errorOcurred(relativeURL,"Catch Error");
            return returnError();
         }
         finally
         {
            fileByteArray = null;
         }
      }
      
      public function set mustKick(param1:Boolean) : void
      {
         this.kick = param1;
      }
      
      private function returnError() : int
      {
         if(this.debug)
         {
            logger.debug("file control error");
         }
         return FILE_CONTROL_ERROR;
      }
   }
}
