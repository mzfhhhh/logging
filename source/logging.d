
module logging;

private import std.datetime;
private import std.stdio;

public enum LogLevel
{
	Error,
	Warning,
	Info,
	Debug,
	Trace
}

private enum string[LogLevel] LOGLEVEL_STR =
[
	LogLevel.Error	: "ERRR",
	LogLevel.Warning: "WARN",
	LogLevel.Info	: "INFO",
	LogLevel.Debug	: "DEBG",
	LogLevel.Trace	: "TRCE"
];

private uint abbr_thread_id()
{
	synchronized
	{
		static uint[core.thread.Thread] abbrs;

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

public struct log
{
	private static void log(LogLevel loglevel, string m = __MODULE__, string func = __FUNCTION__, size_t line = __LINE__, Args...)(string fmt, Args args)
	{
		auto st = Clock.currTime();
		writef("%4s.%02u.%02s.%02s.%02s.%06s T#%02s %s ",
			st.year,
			st.month,
			st.day,
			st.hour,
			st.minute,
			st.fracSec.usecs,
			abbr_thread_id(),
			LOGLEVEL_STR[loglevel]
			);
		writef(fmt, args);
		writefln(" (at %s():%s)", func, line);
	}

	alias error		= log!(LogLevel.Error);
	alias warning	= log!(LogLevel.Warning);
	alias info		= log!(LogLevel.Info);
	alias debg		= log!(LogLevel.Debug);
	alias trace		= log!(LogLevel.Trace);

	alias warn 		= warning;
}
