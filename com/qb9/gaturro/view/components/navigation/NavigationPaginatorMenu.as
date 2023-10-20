package com.qb9.gaturro.view.components.navigation
{
   import com.qb9.gaturro.commons.event.PaginatorEvent;
   import com.qb9.gaturro.view.components.repeater.RepeaterPaginatedFacade;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   
   public class NavigationPaginatorMenu implements INavigationMenu
   {
       
      
      protected var repeaterFacade:RepeaterPaginatedFacade;
      
      private var _disposed:Boolean = false;
      
      protected var prevBtn:InteractiveObject;
      
      protected var nextBtn:InteractiveObject;
      
      protected var viewContainer:DisplayObjectContainer;
      
      public function NavigationPaginatorMenu()
      {
         super();
      }
      
      protected function setupSingleButtons() : void
      {
         this.prevBtn = this.viewContainer.getChildByName("prev") as InteractiveObject;
         if(this.prevBtn)
         {
            this.prevBtn.addEventListener(MouseEvent.CLICK,this.onPrevBtnClick);
            this.prevBtn.mouseEnabled = this.repeaterFacade.paginator.currentPage > 0 && this.repeaterFacade.paginator.pagesAmount > 1;
            this.nextBtn = this.viewContainer.getChildByName("next") as InteractiveObject;
            if(this.nextBtn)
            {
               this.nextBtn.addEventListener(MouseEvent.CLICK,this.onNextBtnClick);
               this.nextBtn.mouseEnabled = this.repeaterFacade.paginator.currentPage < this.repeaterFacade.paginator.pagesAmount && this.repeaterFacade.paginator.pagesAmount > 1;
               return;
            }
            throw new Error("Could\'t find Next Button");
         }
         throw new Error("Could\'t find Prev Button");
      }
      
      protected function onPrevBtnClick(param1:MouseEvent) : void
      {
         this.repeaterFacade.gotoPrevPage();
      }
      
      private function onPageChanged(param1:PaginatorEvent) : void
      {
         if(this.prevBtn)
         {
            if(param1.startItemId <= 0)
            {
               this.prevBtn.mouseEnabled = false;
            }
            else
            {
               this.prevBtn.mouseEnabled = true;
            }
         }
         if(this.nextBtn)
         {
            if(param1.endItemId >= param1.totalItem)
            {
               this.nextBtn.mouseEnabled = false;
            }
            else
            {
               this.nextBtn.mouseEnabled = true;
            }
         }
      }
      
      public function reset() : void
      {
         this.prevBtn.mouseEnabled = this.repeaterFacade.paginator.currentPage > 0 && this.repeaterFacade.paginator.pagesAmount > 1;
         this.nextBtn.mouseEnabled = this.repeaterFacade.paginator.currentPage < this.repeaterFacade.paginator.pagesAmount && this.repeaterFacade.paginator.pagesAmount > 1;
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function setup(param1:DisplayObjectContainer, param2:RepeaterPaginatedFacade) : void
      {
         this.viewContainer = param1;
         this.repeaterFacade = param2;
         this.repeaterFacade.addEventListener(PaginatorEvent.PAGE_CHANGED,this.onPageChanged);
         this.setupSingleButtons();
      }
      
      protected function onNextBtnClick(param1:MouseEvent) : void
      {
         this.repeaterFacade.gotoNextPage();
      }
      
      public function dispose() : void
      {
         this.nextBtn.removeEventListener(MouseEvent.CLICK,this.onNextBtnClick);
         this.nextBtn = null;
         this.prevBtn.removeEventListener(MouseEvent.CLICK,this.onPrevBtnClick);
         this.prevBtn = null;
         this._disposed = true;
      }
   }
}
