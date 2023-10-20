package com.qb9.gaturro.net.secure
{
   import assets.CaptureAvatarAlphaMC;
   import com.qb9.flashlib.geom.Vector2D;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.util.ImageTool;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   
   public class SecureWebServicePutImage extends SecureURLLoader
   {
       
      
      private var _imageB64:String;
      
      private var _imageType:String = "image/jpg";
      
      public function SecureWebServicePutImage()
      {
         super();
         _headerXMethod = HttpMethod.PUT;
      }
      
      override protected function onWebserviceLoaded(param1:Object) : void
      {
         this.dispatchEvent(new SecureResponseEvent(SecureResponseEvent.PUT_IMAGE_COMPLETE,param1));
      }
      
      override protected function loadWebService() : void
      {
         _webServiceRequest.url = _webServiceURL + _webServicePath + "?access_token=" + user.hashSessionId;
         _webServiceRequest.data = _jsonRequest;
         _webServiceRequest.contentType = "application/json";
         super.loadWebService();
      }
      
      public function load(param1:Gaturro, param2:String, param3:uint = 50) : void
      {
         if(param2 == ImageTool.JPG_ENCODING)
         {
            this._imageType = "image/jpg";
         }
         else if(param2 == ImageTool.PNG_ENCODING)
         {
            this._imageType = "image/png";
         }
         var _loc4_:MovieClip = new CaptureAvatarAlphaMC();
         var _loc5_:Vector2D = new Vector2D(2,2);
         var _loc6_:BitmapData = ImageTool.getAvatarBitmap(param1,_loc4_,"avatarPh",280,380,_loc5_);
         this._imageB64 = ImageTool.bitmapToBase64(_loc6_,param2,100);
         _jsonRequest = "{\"smallImage\":\"" + this._imageB64 + "\", \"smallImageType\":\"" + this._imageType + "\"}";
         loadSignature();
      }
   }
}
