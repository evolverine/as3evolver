/**
 * @author Mihai Chira
 * */
package com.pearson.shingo.view.components.flex3.breadcrumbs
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	
	
	/**
	 * <p>
	 * The BreadcrumbsController manipulates the actual breadcrumbs, managing the data and dispatching events when it changes. The view
	 * (Breadcrumbs.mxml) picks up the events and redraws its components accordingly. It also handles individual breadcrumb clicking events.
	 * </p>
	 * 
	 * <p>
	 * Breadcrumbs functioning mechanism: a custom event is dispatched on every
	 * breadcrumb click, event which is defined at the time of the breadcrumb is added. Each breadcrumb has an EventInfo object attached to it,
	 * which contains the type of the event to be dispatched, and an additional data property for custom information. The implementing project
	 * is expected to capture these events and perform the necessary actions. The events are dispatched via a delegate, which needs to implement the
	 * <code>IEventDispatcherDelegate</code> interface. The <code>DefaultEventDispatcherDelegate</code> is the default delegate for dispatching events.
	 * </p>
	 * 
	 * 
	 * 
	 * <p>
	 * <b>To implement this component in your project:</b></p>
	 * <p>
	 * - There is no direct implementation of the controller in code, as there is an expectation that an implementing project will use Spring for
	 * Actionscript to inject this dependency into the view, using the <code>breadcrumbsController</code> setter on the Breadcrumbs mxml component.
	 * Alternatively one could merely instantiate this class in a project-specific subclass of Breadcrumbs:
	 * <code>this.breadcrumbsController = new BreadcrumbsController();</code><br/>
	 * - There is no direct implementation of the event dispatcher delegate in the code, as there is an expectation that an implementing project
	 * will use Spring for Actionscript to inject this dependency into the BreadcrumbsController via the <code>eventDispatcherDelegate</code> property.
	 * Alternatively an implementing project can simply assign an implementer of the <code>IEventDispatcherDelegate</code> interface (either
	 * an instance of <code>DefaultEventDispatcherDelegate</code>, or of a custom delegate ).<br/>
	 * - The controller is ideally accessed via a subclass of the Breadcrumbs mxml component via the <code>controller</code> getter.
	 * </p>
	 * 
	 * <p>
	 * The BreadcrumbsController can also be subclassed in the implementing project for any custom functionality it needs to perform.
	 * </p>
	 * 
	 * @see com.pearson.shingo.view.components.flex3.breadcrumbs.Breadcrumbs
	 * @see com.pearson.shingo.view.components.flex3.breadcrumbs.DefaultEventDispatcherDelegate
	 * */
	
	
	
	public class BreadcrumbsController extends EventDispatcher
	{
		//inject this through Spring, or just assign it
		public var eventDispatcherDelegate : IEventDispatcherDelegate;
		
		protected static var _changeEvent : Event = new Event(Event.CHANGE, false);
		protected var _items : Array = [];
		protected var _perpetualRootItem : IBreadcrumb;
		protected var _perpetualRootItemArray : Array = [];
		
		
		
		/**
		 * Sets the perpetual root item. This is useful when there always needs to be an item as the first
		 * breadcrumb, for instance a 'Home' breadcrumb. If the perpetual root item is not null,
		 * calling <code>clearItems()</code> will not clear the root item. Also, calling this function when
		 * there already are breadcrumb items will insert the perpetual root item as the first breadcrumb.
		 * 
		 * @param displayName the name of the root breadcrumb
		 * @param eventData the event information which the <code>eventDispatcherDelegate</code> uses to
		 * dispatch an event when the root breadcrumb is clicked.
		 * 
		 * @see #clearPerpetualRootItem()
		 * @see #clearItems()
		 * */
		public function setPerpetualRootItem(displayName:String, eventData:EventInfo) : void
		{
			if(displayName)
				this.perpetualRootItem = new BreadcrumbData(displayName, eventData);
			else
				this.perpetualRootItem = null;
		}
		
		/**
		 * Clears the perpetual root item.
		 * 
		 * @see #setPerpetualRootItem()
		 * @see #clearItems()
		 * */
		public function clearPerpetualRootItem() : void
		{
			this.perpetualRootItem = null;
		}
		
		
		
		
		/**
		 * Adds a new breadcrumb item to the data source, and sends an event to trigger a redraw on the view.
		 * 
		 * @param item an instance of a class which implements IBreadcrumb (either custom made or <code>BreadcrumbData</code>)
		 * 
		 * @see #addWithProperties()
		 * @see com.pearson.shingo.view.components.flex3.breadcrumbs.IBreadcrumb
		 * @see com.pearson.shingo.view.components.flex3.breadcrumbs.BreadcrumbData
		 * */
		public function addItem(val : IBreadcrumb):void
		{
			if(val) {
				this._items.push(val);
				this.dispatchEvent(_changeEvent);
			}
		}
		
		
		/**
		 * Adds a new breadcrumb item to the data source, and sends an event to trigger a redraw on the view. 
		 * 
		 * @param name the display name of the breadcrumb
		 * @param eventData the event information which the <code>eventDispatcherDelegate</code> uses to
		 * dispatch an event when this breadcrumb is clicked.
		 * 
		 * @see #addItem()
		 * */
		public function addWithProperties(displayName:String, eventData:EventInfo = null):void
		{
			if(displayName)
				this.addItem(new BreadcrumbData(displayName, eventData)); 
		}
		
		
		/**
		 * Clears all the breadcrumbs, and sends an event to trigger a redraw on the view.
		 * 
		 * If there is a perpetual root breadcrumb item defined, it will not be cleared.
		 * 
		 * @see #clearItemsFromIndex()
		 * @see #setPerpetualRootItem()
		 * */
		public function clearItems():void
		{
			this._items = this._perpetualRootItem ? [this._perpetualRootItem]  : [];
			this.dispatchEvent(_changeEvent);
		}
		
		
		/**
		 * Clears all items starting from a specific index (position) and sends an event to trigger a redraw on the view.
		 * 
		 * @see #clearItems()
		 * */
		public function clearItemsFromIndex(val:Number):void
		{
			if((val >= 0) && (val < this._items.length)) {
				this._items.splice(val, this._items.length - val + 1);
				this.dispatchEvent(_changeEvent);
			}
		}
		
		
		/**
		 * Selects a breadcrumb item (as when the user clicks on its visual representation).
		 * The breadcrumbs added after <code>val</code> are cleared, and the delegate is called to create and dispatch
		 * the event associated with val.
		 * 
		 * @param val the IBreadcrumb item to be selected. It needs to already have been added via <code>addItem()<code> or
		 * <code>addWithProperties()</code>.
		 * @param eventData the event information which the <code>eventDispatcherDelegate</code> uses to
		 * dispatch an event when this breadcrumb is clicked.
		 * 
		 * @see #addItem()
		 * */
		
		public function select(val : IBreadcrumb):void
		{
			if(this.itemExists(val)) {
				var previousLength:Number = this._items.length;
				
				var item:IBreadcrumb;
				if(this._items.length)
					while(item = (this._items[this._items.length-1] as IBreadcrumb)) {
						if(item == val) {
							if(item.eventInfo)
								this.dispatchItemEvent( item.eventInfo );
							
							break;
						}
						else
							this._items.pop();
				}
				
				
				if(previousLength != this._items.length)
					this.dispatchEvent(_changeEvent);
			}		
		}
		
		
		
		
		
		protected function dispatchItemEvent( event : EventInfo ):void
		{
			if(this.eventDispatcherDelegate)
				this.eventDispatcherDelegate.dispatch(event);
		}
		
		protected function itemExists(val:IBreadcrumb):Boolean
		{
			var i:Number = this._items.length;
			while(--i >= 0)
				if(this._items[i] == val)
					return true;

			return false;
		}
		
		
		
		
		
		/**
		 * Represents all the breadcrumb data items.
		 * All of them are implementors of IBreadcrumb.
		 * */
		[Bindable]
		public function get items():Array
		{
			return this._items;
		}
		
		public function set items(val:Array):void
		{
			if(val && (this._items != val))
				this._items = val;
		}
		
		
		
		
		
		
		protected function set perpetualRootItem(val : IBreadcrumb) : void
		{
			if(this._perpetualRootItem != val) {
				if(this._items && this._items.length && this._items[0] == this._perpetualRootItem)
					this._items.shift();
				
				this._perpetualRootItem = val;
				
				if(this._items)
					this._items.unshift(this._perpetualRootItem);
				else
					this.clearItems();
			}
		}
		
		protected function get perpetualRootItem() : IBreadcrumb
		{
			return this._perpetualRootItem;
		}
	}
}