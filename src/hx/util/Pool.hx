package util;
import haxe.ds.Vector.Vector;

/**
 * Pool class to hold given amount of items and recycle them.
 * @author 
 */
@:expose("util.Pool")
class Pool<T>
{
	public var all(get, null):Vector<T>;
	private var _pool:Vector<T>;
	private var _index:Int;

	/**
	 * Initialize the pool with given size. Constructor-function is called for each item.
	 * @param	size Size of the pool
	 * @param	constructor Constructor. This needs to return object type in pool.
	 */
	public function new(size:Int, ?constructor:Void->T) 
	{
		_pool = new Vector<T>(size);
		_index = 0;
		if (constructor != null)
		{
			for ( i in 0...size)
			{
				_pool[i] = constructor();
			}
		}
	}
	
	/**
	 * Returns all objects.
	 * @return
	 */
	public function get_all():Vector<T>
	{
		return _pool;
	}
	
	/**
	 * Add an item to the pool.
	 * It overrides the item in current index. Pool size does not change.
	 * @param	item
	 */
	public function addItem(item:T):Void
	{
		_pool[_index] = item;
		_index = (_index + 1) % _pool.length;
	}
	
	/**
	 * Returns next item in pool. If the item is already used somewhere else, then it is in use in two places.
	 * @return
	 */
	public function getNext():T
	{
		_index = (_index + 1) % _pool.length;
		return _pool[_index];
	}	
}