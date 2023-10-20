package com.qb9.flashlib.input
{
   import com.qb9.flashlib.color.Color;
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.interfaces.IMoveable;
   import com.qb9.flashlib.tasks.Func;
   import com.qb9.flashlib.tasks.ITask;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskContainer;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.utils.setTimeout;
   
   public class Console extends Sprite implements IDisposable, IMoveable
   {
      
      private static const HISTORY_FONT_SIZE:uint = 10;
      
      private static const BG_COLOR:uint = 2236962;
      
      private static const DEFAULT_LOG_COLOR:uint = 10066329;
      
      private static const FIELD_HEIGHT:uint = 25;
      
      private static const DEFAULT_IN_RATIO:Number = 0.75;
      
      private static const BORDER_COLOR:uint = 11184810;
      
      private static const SLIDE_DURATION:uint = 100;
      
      private static const CURSOR:String = ">> ";
      
      private static const FIELD_FONT_SIZE:uint = 14;
       
      
      private var _desposed:Boolean;
      
      private var hotkey:com.qb9.flashlib.input.Hotkey;
      
      private var task:ITask;
      
      private var _stage:Stage;
      
      private var stack:Stack;
      
      private var area:Rectangle;
      
      private var tasks:TaskContainer;
      
      private var cmds:Object;
      
      private var history:TextField;
      
      private var ptr:int = 50;
      
      private var oldFocus:InteractiveObject;
      
      private var field:TextField;
      
      public function Console(param1:TaskContainer = null, param2:Rectangle = null)
      {
         this.cmds = {};
         super();
         this.tasks = param1;
         this.area = param2;
         this.makeInvisible();
         addEventListener(Event.ADDED_TO_STAGE,this.generate);
      }
      
      private function focusField() : void
      {
         this.delay(this.focusElem,this.field);
      }
      
      private function delay(param1:Function, ... rest) : void
      {
         setTimeout.apply(null,[param1,1].concat(rest));
      }
      
      private function flush(param1:Event) : void
      {
         var _loc2_:String = this.field.text;
         if(!_loc2_)
         {
            return;
         }
         this.run(_loc2_);
         this.stack.store(_loc2_);
      }
      
      private function setupStack() : void
      {
         this.stack = new Stack();
      }
      
      private function makeFormat(param1:uint, param2:uint) : TextFormat
      {
         var _loc3_:TextFormat = new TextFormat("Verdana",param2,param1);
         _loc3_.leftMargin = 10;
         _loc3_.leading = 2;
         return _loc3_;
      }
      
      private function error(param1:String) : void
      {
         this.coloredLog(param1,Color.RED);
      }
      
      public function run(param1:String) : void
      {
         var parser:Command;
         var fn:Function;
         var args:Array;
         var cmd:String = null;
         var ret:Object = null;
         var command:String = param1;
         this.coloredLog(command,Color.YELLOW);
         parser = new Command(command);
         cmd = parser.readWord();
         fn = this.cmds[cmd];
         if(fn === null)
         {
            return this.error(cmd + ": command not found");
         }
         args = parser.readArgs();
         if(cmd == "macro" || cmd == "m" || cmd == "reset" || cmd == "r")
         {
            args.push(this);
         }
         try
         {
            ret = fn.apply(null,args);
            if(ret !== null)
            {
               this.print(ret);
            }
            return;
         }
         catch(err:ArgumentError)
         {
            this.error("wrong amount of arguments, expected: " + this.arity(cmd));
            return;
         }
         catch(err:Error)
         {
            this.error(err.message);
            return;
         }
      }
      
      private function focusElem(param1:InteractiveObject) : void
      {
         if(stage && stage.focus !== param1)
         {
            stage.focus = param1;
         }
      }
      
      private function init() : void
      {
         graphics.beginFill(BG_COLOR,0.8);
         graphics.drawRect(0,0,this.area.width,this.area.height);
         graphics.endFill();
         y = -this.area.height;
         this.addBuiltIn();
      }
      
      private function fillTextField(param1:String) : void
      {
         this.fieldText(param1);
         this.delay(this.fixCursor);
      }
      
      private function mouseDownScroll(param1:MouseEvent) : void
      {
         if(this.history != null && this.history.stage != null)
         {
            if(!this.history.stage.hasEventListener(MouseEvent.MOUSE_WHEEL))
            {
               this.history.stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.mouseDownScroll);
            }
            else
            {
               this.history.scrollV += param1.delta * -1;
            }
         }
      }
      
      private function _hide(param1:Event) : void
      {
         this.hide();
      }
      
      private function coloredLog(param1:String, param2:uint) : void
      {
         var _loc3_:int = this.history.text.length;
         param1 += " ";
         this.log(param1);
         this.history.setTextFormat(this.makeFormat(param2,HISTORY_FONT_SIZE),_loc3_,_loc3_ + param1.length);
      }
      
      public function register(param1:String, param2:Function) : void
      {
         this.cmds[param1] = param2;
      }
      
      public function dispose() : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.generate);
         this._stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.mouseDownScroll);
         this.field.removeEventListener(MouseEvent.MOUSE_UP,this.selectText);
         this.history.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this.history.removeEventListener(MouseEvent.MOUSE_UP,this.selectText);
         this.cmds = null;
         this.task = this.tasks = null;
         this.oldFocus = this.field = this.history = null;
         this.stack.dispose();
         this.stack = null;
         if(this.hotkey)
         {
            this.hotkey.dispose();
         }
         this.hotkey = null;
         this._desposed = true;
      }
      
      private function makeField(param1:uint, param2:uint) : TextField
      {
         var _loc3_:TextField = new TextField();
         addChild(_loc3_);
         _loc3_.embedFonts = false;
         _loc3_.width = this.area.width - 0;
         _loc3_.borderColor = BORDER_COLOR;
         _loc3_.border = true;
         _loc3_.defaultTextFormat = this.makeFormat(param1,param2);
         return _loc3_;
      }
      
      public function print(param1:Object, param2:uint = 10066329) : void
      {
         var _loc3_:String = (CURSOR + param1).replace(/(\r?\n)/g,"$1" + CURSOR);
         this.coloredLog(_loc3_,param2);
      }
      
      public function get disposed() : Boolean
      {
         return this._desposed;
      }
      
      private function moveTo(param1:int, param2:Boolean = false) : void
      {
         this.task = new Tween(this,SLIDE_DURATION,{"y":param1},{"transition":"easeOut"});
         if(param2)
         {
            this.task = new Sequence(this.task,new Func(this.makeInvisible));
         }
         if(this.tasks)
         {
            this.tasks.add(this.task);
         }
         else
         {
            this.task.start();
            this.task.update(SLIDE_DURATION);
         }
      }
      
      public function unregister(param1:String) : void
      {
         delete this.cmds[param1];
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         this.history.type = TextFieldType.DYNAMIC;
      }
      
      private function stackUp(param1:Event) : void
      {
         this.fillTextField(this.stack.getNext());
      }
      
      private function log(param1:String) : void
      {
         this.history.appendText("\n" + param1);
         this.history.scrollV = this.history.maxScrollV;
      }
      
      public function get showing() : Boolean
      {
         return visible;
      }
      
      private function fieldText(param1:String) : void
      {
         this.field.text = param1;
         this.fixCursor();
      }
      
      private function selectText(param1:MouseEvent) : void
      {
         var _loc2_:TextField = param1.currentTarget as TextField;
         this.copyText(_loc2_);
      }
      
      private function clearStack() : void
      {
         this.stack.clear();
      }
      
      private function fixCursor() : void
      {
         if(this.field === null)
         {
            return;
         }
         var _loc1_:int = this.field.text.length;
         this.field.setSelection(_loc1_,_loc1_);
      }
      
      public function clear() : void
      {
         this.history.text = "";
         this.delay(this.clearStack);
      }
      
      public function get moving() : Boolean
      {
         return this.task && this.task.running;
      }
      
      private function copyText(param1:TextField) : void
      {
         var _loc2_:String = param1.selectedText;
         trace("Console > selectText > str = [" + _loc2_ + "]");
         System.setClipboard(_loc2_);
      }
      
      public function toggle() : void
      {
         if(this.showing)
         {
            this.hide();
         }
         else
         {
            this.show();
         }
      }
      
      private function stackDown(param1:Event) : void
      {
         this.fillTextField(this.stack.getPrev());
      }
      
      public function hide() : void
      {
         var _loc1_:DisplayObjectContainer = null;
         if(this.moving)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.parent.numChildren - 1)
         {
            _loc1_ = this.parent.getChildAt(_loc2_) as DisplayObjectContainer;
            _loc2_++;
         }
         this.stack.persist();
         this.focusElem(this.oldFocus || stage);
         this.moveTo(0 - this.area.height,true);
         this.history.stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.mouseDownScroll);
         this.field.removeEventListener(MouseEvent.MOUSE_UP,this.selectText);
         this.history.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this.history.removeEventListener(MouseEvent.MOUSE_UP,this.selectText);
      }
      
      private function arity(param1:String) : int
      {
         return this.cmds[param1].length;
      }
      
      private function createField() : void
      {
         this.field = this.makeField(Color.WHITE,FIELD_FONT_SIZE);
         this.field.type = TextFieldType.INPUT;
         this.field.y = this.area.height - FIELD_HEIGHT - 1;
         this.field.height = FIELD_HEIGHT;
         this.field.selectable = true;
         this.field.addEventListener(MouseEvent.MOUSE_UP,this.selectText);
      }
      
      private function makeInvisible() : void
      {
         visible = false;
      }
      
      private function autocomplete(param1:Event) : void
      {
         var _loc5_:String = null;
         if(!this.showing)
         {
            return;
         }
         this.focusField();
         var _loc2_:String = this.field.text;
         if(_loc2_.indexOf(" ") !== -1)
         {
            return;
         }
         var _loc3_:Array = this.suggestions(_loc2_);
         var _loc4_:String = String(_loc3_[0]);
         switch(_loc3_.length)
         {
            case 0:
               break;
            case 1:
               this.fieldText(_loc4_ + " ");
               break;
            default:
               while(!(!(_loc5_ = _loc4_.charAt(_loc2_.length)) || this.suggestions(_loc2_ + _loc5_).length !== _loc3_.length))
               {
                  _loc2_ += _loc5_;
               }
               if(_loc2_ !== this.field.text)
               {
                  this.fieldText(_loc2_);
                  break;
               }
               this.print(this.cmdList(_loc2_));
               break;
         }
      }
      
      private function addBuiltIn() : void
      {
         this.register("clear",this.clear);
         this.register("cmds",this.cmdList);
      }
      
      private function suggestions(param1:String) : Array
      {
         var _loc3_:* = null;
         var _loc2_:Array = [];
         for(_loc3_ in this.cmds)
         {
            if(_loc3_.indexOf(param1) === 0)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_.sort();
      }
      
      private function generate(param1:Event) : void
      {
         this._stage = stage;
         removeEventListener(Event.ADDED_TO_STAGE,this.generate);
         this.area = this.area || new Rectangle(0,0,stage.stageWidth,stage.stageHeight * DEFAULT_IN_RATIO);
         this.init();
         this.createHistory();
         this.setupStack();
         this.createField();
         this.hotkey = new com.qb9.flashlib.input.Hotkey(this);
         this.hotkey.add("enter",this.flush);
         this.hotkey.add("tab",this.autocomplete);
         this.hotkey.add("up",this.stackUp);
         this.hotkey.add("down",this.stackDown);
         this.hotkey.add("esc",this._hide);
      }
      
      private function createHistory() : void
      {
         this.history = this.makeField(16777215,HISTORY_FONT_SIZE);
         this.history.y = 1;
         this.history.wordWrap = true;
         this.history.type = TextFieldType.INPUT;
         this.history.height = this.area.height - FIELD_HEIGHT - 5;
         this.history.selectable = true;
         this.history.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this.history.addEventListener(MouseEvent.MOUSE_UP,this.selectText);
      }
      
      public function show() : void
      {
         var _loc1_:DisplayObjectContainer = null;
         if(this.moving)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.parent.numChildren - 1)
         {
            _loc1_ = this.parent.getChildAt(_loc2_) as DisplayObjectContainer;
            if(_loc1_)
            {
            }
            _loc2_++;
         }
         visible = true;
         this.mouseChildren = true;
         this.mouseEnabled = true;
         if(stage.focus && stage.focus !== this.field)
         {
            this.oldFocus = stage.focus;
         }
         this.stack.reset();
         this.moveTo(0);
         this.focusField();
         this.history.stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.mouseDownScroll);
         if(!this.history.hasEventListener(KeyboardEvent.KEY_DOWN))
         {
            this.history.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         }
         if(!this.field.hasEventListener(MouseEvent.MOUSE_UP))
         {
            this.field.addEventListener(MouseEvent.MOUSE_UP,this.selectText);
         }
      }
      
      private function cmdList(param1:String = "") : String
      {
         return this.suggestions(param1).join(" \t") || "No match found";
      }
   }
}

import com.qb9.flashlib.interfaces.IDisposable;
import flash.net.SharedObject;

class CmdPersistence implements IDisposable
{
   
   private static const SHARED_OBJECT_PROPERTY:String = "cmdCaches";
   
   private static const DELIMITER:String = ";";
    
   
   private var so:SharedObject;
   
   public function CmdPersistence()
   {
      super();
      this.so = SharedObject.getLocal(SHARED_OBJECT_PROPERTY);
   }
   
   public function persist(param1:Array) : void
   {
      this.so.setProperty(SHARED_OBJECT_PROPERTY,param1);
   }
   
   public function dispose() : void
   {
      this.so = null;
   }
   
   public function getPersisted() : Array
   {
      return !!this.so.data.hasOwnProperty(SHARED_OBJECT_PROPERTY) ? this.so.data[SHARED_OBJECT_PROPERTY] : new Array();
   }
}

import com.qb9.flashlib.config.Evaluator;

class Command
{
   
   private static const QUOTE:String = "\"";
   
   private static const SPACE:String = " ";
    
   
   private var data:String;
   
   public function Command(param1:String)
   {
      super();
      this.data = param1;
   }
   
   public function readWord() : String
   {
      return this.until(SPACE);
   }
   
   private function index(param1:String) : int
   {
      var _loc2_:int = int(this.data.indexOf(param1,1));
      if(_loc2_ === -1)
      {
         _loc2_ = int(this.data.length);
      }
      return _loc2_;
   }
   
   private function readToken() : Object
   {
      if(this.data.charAt(0) === QUOTE)
      {
         return this.until(QUOTE).slice(1);
      }
      return Evaluator.parse(this.readWord());
   }
   
   public function readArgs() : Array
   {
      var _loc1_:Array = [];
      while(this.data)
      {
         if(this.data.charAt(0) === SPACE)
         {
            this.data = String(this.data.slice(1));
         }
         else
         {
            _loc1_.push(this.readToken());
         }
      }
      return _loc1_;
   }
   
   private function until(param1:String) : String
   {
      var _loc2_:int = int(this.index(param1));
      var _loc3_:String = String(this.data.slice(0,_loc2_));
      this.data = String(this.data.slice(_loc2_ + 1));
      return _loc3_;
   }
}

import com.qb9.flashlib.interfaces.IDisposable;

class Stack implements IDisposable
{
   
   private static const MAX_STACK_QUANTITY:int = 20;
    
   
   private var stack:Array;
   
   private var index:int;
   
   private var persistence:CmdPersistence;
   
   public function Stack()
   {
      super();
      this.setupPersistence();
   }
   
   public function store(param1:String) : void
   {
      if(this.stack.length == MAX_STACK_QUANTITY)
      {
         this.stack.splice(1,1);
      }
      this.stack.splice(this.stack.length,0,param1);
   }
   
   private function setupPersistence() : void
   {
      this.persistence = new CmdPersistence();
      this.stack = this.persistence.getPersisted();
      if(this.stack.length)
      {
         this.index = int(this.stack.length - 1);
      }
      else
      {
         this.stack.push("");
         this.index = 0;
      }
      this.stack.fixed = true;
   }
   
   public function dispose() : void
   {
      this.persist();
      this.stack = null;
      this.persistence.dispose();
   }
   
   public function getNext() : String
   {
      var _loc1_:String = null;
      if(this.stack.length)
      {
         if(this.index - 1 >= 0)
         {
            _loc1_ = String(this.stack[--this.index]);
         }
         else
         {
            _loc1_ = String(this.stack[this.index]);
         }
      }
      else
      {
         _loc1_ = "";
      }
      return _loc1_;
   }
   
   public function clear() : void
   {
      this.stack.length = 0;
   }
   
   public function reset() : void
   {
      this.index = int(this.stack.length - 1);
   }
   
   public function persist() : void
   {
      this.persistence.persist(this.stack);
   }
   
   public function getPrev() : String
   {
      var _loc1_:String = null;
      if(this.stack.length)
      {
         if(this.index + 1 < this.stack.length)
         {
            _loc1_ = String(this.stack[++this.index]);
         }
         else
         {
            _loc1_ = String(this.stack[this.index]);
         }
      }
      else
      {
         _loc1_ = "";
      }
      return _loc1_;
   }
}
