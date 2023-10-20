package com.qb9.gaturro.view.gui.banner.properties
{
   import flash.utils.Dictionary;
   
   public class PropertySetter implements IPropertySetter
   {
       
      
      private var propertyMap:Dictionary;
      
      private var iHasList:Array;
      
      public function PropertySetter()
      {
         super();
         this.iHasList = new Array();
         this.iHasList.push(IHasRoomAPI);
         this.iHasList.push(IHasOptions);
         this.iHasList.push(IHasNetworkManager);
         this.iHasList.push(IHasTaskRunner);
         this.iHasList.push(IHasData);
         this.iHasList.push(IHasSceneAPI);
         this.propertyMap = new Dictionary();
         this.propertyMap[IHasRoomAPI] = new APIPropertySetter();
         this.propertyMap[IHasOptions] = new OPtionsPropertySetter();
         this.propertyMap[IHasNetworkManager] = new NetworkManagerPropertySetter();
         this.propertyMap[IHasTaskRunner] = new TaskRunnerPropertySetter();
         this.propertyMap[IHasData] = new DataPropertySetter();
         this.propertyMap[IHasSceneAPI] = new SceneAPIPropertySetter();
      }
      
      public function setProperty(param1:IHasPropertyTarget, param2:IPropertyGetter) : void
      {
         var _loc3_:Class = null;
         for each(_loc3_ in this.iHasList)
         {
            if(param1 is _loc3_)
            {
               IPropertySetter(this.propertyMap[_loc3_]).setProperty(param1,param2);
            }
         }
      }
   }
}

import com.qb9.gaturro.view.gui.banner.properties.IHasData;
import com.qb9.gaturro.view.gui.banner.properties.IHasPropertyTarget;
import com.qb9.gaturro.view.gui.banner.properties.IPropertyGetter;
import com.qb9.gaturro.view.gui.banner.properties.IPropertySetter;

class DataPropertySetter implements IPropertySetter
{
    
   
   public function DataPropertySetter()
   {
      super();
   }
   
   public function setProperty(param1:IHasPropertyTarget, param2:IPropertyGetter) : void
   {
      IHasData(param1).data = param2.data;
   }
}

import com.qb9.gaturro.view.gui.banner.properties.IHasPropertyTarget;
import com.qb9.gaturro.view.gui.banner.properties.IHasTaskRunner;
import com.qb9.gaturro.view.gui.banner.properties.IPropertyGetter;
import com.qb9.gaturro.view.gui.banner.properties.IPropertySetter;

class TaskRunnerPropertySetter implements IPropertySetter
{
    
   
   public function TaskRunnerPropertySetter()
   {
      super();
   }
   
   public function setProperty(param1:IHasPropertyTarget, param2:IPropertyGetter) : void
   {
      IHasTaskRunner(param1).taskRunner = param2.taskRunner;
   }
}

import com.qb9.gaturro.view.gui.banner.properties.IHasPropertyTarget;
import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
import com.qb9.gaturro.view.gui.banner.properties.IPropertyGetter;
import com.qb9.gaturro.view.gui.banner.properties.IPropertySetter;

class APIPropertySetter implements IPropertySetter
{
    
   
   public function APIPropertySetter()
   {
      super();
   }
   
   public function setProperty(param1:IHasPropertyTarget, param2:IPropertyGetter) : void
   {
      IHasRoomAPI(param1).roomAPI = param2.roomAPI;
   }
}

import com.qb9.gaturro.view.gui.banner.properties.IHasNetworkManager;
import com.qb9.gaturro.view.gui.banner.properties.IHasPropertyTarget;
import com.qb9.gaturro.view.gui.banner.properties.IPropertyGetter;
import com.qb9.gaturro.view.gui.banner.properties.IPropertySetter;

class NetworkManagerPropertySetter implements IPropertySetter
{
    
   
   public function NetworkManagerPropertySetter()
   {
      super();
   }
   
   public function setProperty(param1:IHasPropertyTarget, param2:IPropertyGetter) : void
   {
      IHasNetworkManager(param1).networkManager = param2.networkManager;
   }
}

import com.qb9.gaturro.view.gui.banner.properties.IHasPropertyTarget;
import com.qb9.gaturro.view.gui.banner.properties.IHasSceneAPI;
import com.qb9.gaturro.view.gui.banner.properties.IPropertyGetter;
import com.qb9.gaturro.view.gui.banner.properties.IPropertySetter;

class SceneAPIPropertySetter implements IPropertySetter
{
    
   
   public function SceneAPIPropertySetter()
   {
      super();
   }
   
   public function setProperty(param1:IHasPropertyTarget, param2:IPropertyGetter) : void
   {
      IHasSceneAPI(param1).sceneAPI = param2.sceneAPI;
   }
}

import com.qb9.gaturro.view.gui.banner.properties.IHasOptions;
import com.qb9.gaturro.view.gui.banner.properties.IHasPropertyTarget;
import com.qb9.gaturro.view.gui.banner.properties.IPropertyGetter;
import com.qb9.gaturro.view.gui.banner.properties.IPropertySetter;

class OPtionsPropertySetter implements IPropertySetter
{
    
   
   public function OPtionsPropertySetter()
   {
      super();
   }
   
   public function setProperty(param1:IHasPropertyTarget, param2:IPropertyGetter) : void
   {
      IHasOptions(param1).options = param2.options;
   }
}
