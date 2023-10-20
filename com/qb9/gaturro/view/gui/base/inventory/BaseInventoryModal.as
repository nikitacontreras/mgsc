package com.qb9.gaturro.view.gui.base.inventory
{
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.gui.util.GuiUtil;
   import flash.display.Sprite;
   
   public class BaseInventoryModal extends BaseGuiModal
   {
      
      protected static const WRAP_MARGIN:uint = 5;
      
      protected static const WRAP_COLOR:uint = 16373265;
       
      
      private var wrap:Sprite;
      
      protected var widget:com.qb9.gaturro.view.gui.base.inventory.InventoryWidget;
      
      public function BaseInventoryModal(param1:Array = null, param2:int = 0)
      {
         super();
         if(param1)
         {
            this.widget = InventoryWidget(param1[0]);
            this.wrap = new Sprite();
            this.init(this.widget,this.wrap,param2);
         }
      }
      
      protected function init(param1:Sprite, param2:Sprite, param3:int = 0) : void
      {
         addChild(param2);
         param1.x = param1.y = WRAP_MARGIN;
         param2.addChild(param1);
         if(this.hasOverlay())
         {
            this.addRactAndOverlay(param2);
         }
         param2.y = -param1.height - WRAP_MARGIN * 2 + param3;
         mouseEnabled = param2.mouseEnabled = false;
      }
      
      protected function addRactAndOverlay(param1:Sprite) : void
      {
         var w:Sprite = param1;
         var rounding:uint = uint(settings.gui.overlay.rounding);
         with(w.graphics)
         {
            beginFill(WRAP_COLOR);
            drawRoundRect(0,0,width + WRAP_MARGIN * 2,height + WRAP_MARGIN * 2,rounding);
            endFill();
         }
         GuiUtil.addOverlay(this);
      }
      
      protected function hasOverlay() : Boolean
      {
         return true;
      }
      
      override public function dispose() : void
      {
         if(this.widget)
         {
            this.widget.dispose();
            this.widget = null;
         }
         super.dispose();
      }
   }
}
