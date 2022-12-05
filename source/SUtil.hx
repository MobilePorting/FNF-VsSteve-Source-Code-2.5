package;

import haxe.CallStack;
import lime.system.System as LimeSystem;
import openfl.Lib;
import openfl.events.UncaughtErrorEvent;

using StringTools;

/**
 * ...
 * @author Mihai Alexandru (M.A. Jigsaw)
 */
class SUtil
{
        /**
	 * Uncaught error handler, original made by: sqirra-rng
	 */
	public static function uncaughtErrorHandler():Void
	{
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, function(u:UncaughtErrorEvent)
		{
			var callStack:Array<StackItem> = CallStack.exceptionStack(true);
			var errMsg:String = '';

			for (stackItem in callStack)
			{
				switch (stackItem)
				{
					case CFunction:
						errMsg += 'a C function\n';
					case Module(m):
						errMsg += 'module ( ' + m + ')\n';
					case FilePos(s, file, line, column):
						errMsg += file + ' (line ' + line + ')\n';
					case Method(cname, meth):
						errMsg += cname == null ? "<unknown>" : cname + '.' + meth + '\n';
					case LocalFunction(n):
						errMsg += 'local function ' + n + '\n';
				}
			}

			errMsg += u.error;

			#if sys
			try
			{/*do nothing beacuse no external storage xd*/}
			#end

			println(errMsg);
			Lib.application.window.alert(errMsg, 'Error!');
			LimeSystem.exit(1);
		});
	}

	private static function println(msg:String):Void
	{
		#if sys
		Sys.println(msg);
		#else
		// Pass null to exclude the position.
		haxe.Log.trace(msg, null);
		#end
	}
}
