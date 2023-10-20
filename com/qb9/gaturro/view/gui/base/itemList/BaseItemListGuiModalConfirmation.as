package com.qb9.gaturro.view.gui.base.itemList
{
   import assets.ItemsInventoryConfirmationMC;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.globals.libs;
   import com.qb9.gaturro.view.gui.base.itemList.items.BaseItemListItemView;
   import com.qb9.gaturro.view.gui.util.GuiUtil;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BaseItemListGuiModalConfirmation extends ItemsInventoryConfirmationMC implements IDisposable
   {
       
      
      private var isChrismas:Boolean;
      
      public function BaseItemListGuiModalConfirmation(param1:Boolean)
      {
         super();
         this.isChrismas = param1;
         this.init();
      }
      
      private function init() : void
      {
         visible = false;
         description.text = "";
         buy.addEventListener(MouseEvent.CLICK,this.accept);
         cancel.text.text = "CANCELAR";
         cancel.addEventListener(MouseEvent.CLICK,this.hide);
         if(this.isChrismas)
         {
            description.width = 200;
            buy.x -= 80;
            buy.y += 50;
            cancel.y += 50;
            cancel.x -= 80;
            price.y += 30;
            money_txt.y += 30;
            ph.x += 50;
         }
      }
      
      private function add(param1:DisplayObject) : void
      {
         if(param1)
         {
            this.resize(param1);
            ph.addChild(param1);
         }
      }
      
      private function accept(param1:Event) : void
      {
         param1.stopImmediatePropagation();
         dispatchEvent(new Event(Event.SELECT));
         this.hide();
      }
      
      protected function hide(param1:Event = null) : void
      {
         DisplayUtil.empty(ph);
         visible = false;
      }
      
      private function resize(param1:DisplayObject) : void
      {
         ph.scaleY = 1;
         ph.scaleX = 1;
         GuiUtil.fit(param1,170,130,35,23);
      }
      
      public function show(param1:BaseItemListItemView) : void
      {
         price.text = StringUtil.numberSeparator(param1.itemPrice);
         libs.fetch(param1.itemName,this.add);
         visible = true;
      }
      
      public function dispose() : void
      {
         buy.removeEventListener(MouseEvent.CLICK,this.accept);
         cancel.removeEventListener(MouseEvent.CLICK,this.hide);
         this.hide();
      }
   }
}
