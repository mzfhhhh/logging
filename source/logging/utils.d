
module logging.utils;

import core.thread;

public uint abbr_thread_id()
{
	import std.stdio;
	synchronized
	{
		shared static uint[core.thread.Thread] abbrs;
		auto tid = core.thread.Thread.getThis();

		if(tid !in abbrs)
		{
			auto next_abbr = cast(uint) abbrs.length;
			if(tid is null)
			{
				next_abbr = uint.max;
			}

			abbrs[tid] = next_abbr;

			return next_abbr;
		}

		return abbrs[tid];
	}
}
