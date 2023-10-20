package com.qb9.gaturro.net.delegate
{
   import com.adobe.serialization.json.JSON;
   import com.qb9.gaturro.commons.event.EventManager;
   import com.qb9.gaturro.commons.net.delegate.AbstractRequestDelegate;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.user.passport.IPassportProductHolder;
   import com.qb9.gaturro.user.passport.PassportProduct;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class PassportProductRequestDelegate extends AbstractRequestDelegate
   {
       
      
      private var tartget:IPassportProductHolder;
      
      public function PassportProductRequestDelegate(param1:IPassportProductHolder, param2:Function, param3:EventManager, param4:EventDispatcher)
      {
         super(param2,param3,param4);
         this.tartget = param1;
      }
      
      override public function handleDelegate(param1:Event) : void
      {
         var _loc2_:String = String(param1.target.data);
         var _loc3_:Object = com.adobe.serialization.json.JSON.decode(_loc2_);
         if(_loc3_.error != null)
         {
            logger.warning("server error: " + _loc3_.error.message);
         }
         else
         {
            this.tartget.passportProduct = new PassportProduct(_loc3_.data);
         }
         if(delegate != null)
         {
            delegate(this.tartget.passportProduct);
         }
         super.handleDelegate(param1);
      }
   }
}
