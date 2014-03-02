
module logging;

private import std.datetime;
private import std.stdio;
private import std.string;

public enum LogLevel
{
	Error,
	Warning,
	Info,
	Debug,
	Trace
}

public enum string[LogLevel] LOGLEVEL_STR =
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

interface Formatter
{
	string format(LogLevel loglevel, string m, string func, size_t line, SysTime time, string msg, uint thread_id);
}

class SimpleFormatter : Formatter
{
	string format(LogLevel loglevel, string m, string func, size_t line, SysTime time, string msg, uint thread_id)
	{
			return "%s %s (at %s():%s)".format(
			LOGLEVEL_STR[loglevel],
			msg,
			func,
			line
			);
	}
}

class TimedThreadedFormatter : Formatter
{
	override string format(LogLevel loglevel, string m, string func, size_t line, SysTime st, string msg, uint thread_id)
	{
		return "%4s.%02u.%02s.%02s.%02s.%06s T#%02s %s %s (at %s():%s)".format(
			st.year,
			st.month,
			st.day,
			st.hour,
			st.minute,
			st.fracSec.usecs,
			abbr_thread_id(),
			LOGLEVEL_STR[loglevel],
			msg,
			func,
			line
			);
	}
}

public struct log
{
	public static void formatter(Formatter f) @property
	{
		_formatter = f;
	}

	public static void log(LogLevel loglevel, string m = __MODULE__, string func = __FUNCTION__, size_t line = __LINE__, Args...)(string fmt, Args args)
	{
		auto msg = fmt.format(args);

		msg = _formatter.format(loglevel, m, func, line, Clock.currTime(), msg, abbr_thread_id());
		writeln(msg);
	}

	public static void error(string m = __MODULE__, string func = __FUNCTION__, size_t line = __LINE__, Args...)(string fmt, Args args)
	{
		log!(LogLevel.Error,m,func,line,Args)(fmt, args);
	}

	public static void warning(string m = __MODULE__, string func = __FUNCTION__, size_t line = __LINE__, Args...)(string fmt, Args args)
	{
		log!(LogLevel.Warning,m,func,line,Args)(fmt, args);
	}

	public alias warning warn;

	public static void info(string m = __MODULE__, string func = __FUNCTION__, size_t line = __LINE__, Args...)(string fmt, Args args)
	{
		log!(LogLevel.Info,m,func,line,Args)(fmt, args);
	}

	public static void debg(string m = __MODULE__, string func = __FUNCTION__, size_t line = __LINE__, Args...)(string fmt, Args args)
	{
		log!(LogLevel.Debug,m,func,line,Args)(fmt, args);
	}

	public static void trace(string m = __MODULE__, string func = __FUNCTION__, size_t line = __LINE__, Args...)(string fmt, Args args)
	{
		log!(LogLevel.Trace,m,func,line,Args)(fmt, args);
	}

	private static Formatter _formatter;

	shared static this()
	{
		_formatter = new TimedThreadedFormatter();
	}
}
