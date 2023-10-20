package com.qb9.gaturro.view.gui.catalog.screens
{
   import assets.CatalogConfirmationMC;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.libs;
   import com.qb9.gaturro.view.gui.util.GuiUtil;
   import com.qb9.gaturro.world.catalog.CatalogItem;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   internal class BaseCatalogModalScreen extends CatalogConfirmationMC implements IDisposable
   {
       
      
      public function BaseCatalogModalScreen()
      {
         super();
         visible = false;
      }
      
      private function add(param1:DisplayObject) : void
      {
         if(param1)
         {
            if(param1 is MovieClip)
            {
               this.resize(param1 as MovieClip);
            }
            ph.addChild(param1);
         }
      }
      
      protected function hide(param1:Event = null) : void
      {
         DisplayUtil.empty(ph);
         visible = false;
      }
      
      private function resize(param1:MovieClip) : void
      {
         ph.scaleY = 1;
         ph.scaleX = 1;
         GuiUtil.fit(param1,170,130,35,23);
      }
      
      public function dispose() : void
      {
         this.hide();
      }
      
      public function show(param1:CatalogItem) : void
      {
         libs.fetch(param1.name,this.add);
         visible = true;
      }
   }
}
