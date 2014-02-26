
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

private void log(string m = __MODULE__, string func = __FUNCTION__, size_t line = __LINE__, Args...)(LogLevel loglevel, string fmt, Args args)
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

public void error(string m = __MODULE__, string func = __FUNCTION__, size_t line = __LINE__, Args...)(string fmt, Args args)
{
	log!(m,func,line,Args)(LogLevel.Error, fmt, args);
}

public void warning(string m = __MODULE__, string func = __FUNCTION__, size_t line = __LINE__, Args...)(string fmt, Args args)
{
	log!(m,func,line,Args)(LogLevel.Warning, fmt, args);
}

public alias warning warn;

public void info(string m = __MODULE__, string func = __FUNCTION__, size_t line = __LINE__, Args...)(string fmt, Args args)
{
	log!(m,func,line,Args)(LogLevel.Info, fmt, args);
}

public void debg(string m = __MODULE__, string func = __FUNCTION__, size_t line = __LINE__, Args...)(string fmt, Args args)
{
	log!(m,func,line,Args)(LogLevel.Debug, fmt, args);
}

public void trace(string m = __MODULE__, string func = __FUNCTION__, size_t line = __LINE__, Args...)(string fmt, Args args)
{
	log!(m,func,line,Args)(LogLevel.Trace, fmt, args);
}
