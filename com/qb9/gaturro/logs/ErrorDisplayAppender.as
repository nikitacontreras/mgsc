package com.qb9.gaturro.logs
{
   import com.qb9.flashlib.color.Color;
   import com.qb9.flashlib.geom.Anchor;
   import com.qb9.flashlib.logs.IAppender;
   import com.qb9.flashlib.logs.Logger;
   import com.qb9.flashlib.prototyping.shapes.BasicShapeConfig;
   import com.qb9.flashlib.prototyping.shapes.Circle;
   import com.qb9.flashlib.utils.DisplayUtil;
   import flash.text.TextField;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class ErrorDisplayAppender extends Circle implements IAppender
   {
       
      
      private var delay:uint;
      
      private var text:TextField;
      
      private var logText:String;
      
      private var id:Number;
      
      private var _isLogging:Boolean = true;
      
      public function ErrorDisplayAppender(param1:uint = 15, param2:uint = 6000)
      {
         super(param1,new BasicShapeConfig(-1,0.8,1),Anchor.center);
         this.delay = param2;
         visible = false;
         this.logText = "";
         this.text = new TextField();
         this.text.y = -200;
         this.text.width = 2000;
      }
      
      public function append(param1:Array, param2:int) : void
      {
         if(!this.isLogging)
         {
            return;
         }
         if(param2 === Logger.LOG_LEVEL_WARNING)
         {
            this.show(Color.YELLOW);
         }
         else if(param2 === Logger.LOG_LEVEL_ERROR)
         {
            this.show(Color.RED);
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_])
            {
               this.logText += param1[_loc3_].toString() + " ";
            }
            _loc3_++;
         }
         this.logText += "\n";
         this.text.text = this.logText;
      }
      
      private function show(param1:uint) : void
      {
         clearTimeout(this.id);
         DisplayUtil.bringToFront(this);
         this.id = setTimeout(this.hide,this.delay);
         paint(param1);
         visible = true;
      }
      
      public function set isLogging(param1:Boolean) : void
      {
         this._isLogging = param1;
      }
      
      private function hide() : void
      {
         this.logText = "";
         DisplayUtil.hide(this);
      }
      
      public function get isLogging() : Boolean
      {
         return this._isLogging;
      }
   }
}
