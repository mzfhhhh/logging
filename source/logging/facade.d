
module logging.facade;

public import logging.formatters;
public import logging.levels;
public import logging.sinks;

private import std.datetime;
private import std.string;
private import logging.utils;

public struct log
{
	public static void log(LogLevel loglevel, string m = __MODULE__, string func = __FUNCTION__, size_t line = __LINE__, Args...)(string fmt, Args args)
	{
		auto msg = fmt.format(args);

		_facade.log(loglevel, m, func, line, Clock.currTime(), msg, abbr_thread_id());
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

	public static void add_sink(LogSink s)
	{
		_facade.add_sink(s);
	}

	public static void remove_all_sinks()
	{
		_facade.remove_all_sinks();
	}

	shared static this()
	{
		_facade = new FacadeImpl();
	}

	__gshared FacadeImpl _facade;
}

// not quite beautiful: couldnt overcome type system for synchronized class

private class FacadeImpl
{
	public void log(LogLevel loglevel, string m, string func, size_t line, SysTime time, string msg, uint thread_id)
	{
		synchronized(this)
		{
			foreach(l; _sinks)
			{
				l.log(loglevel, m, func, line, Clock.currTime(), msg, abbr_thread_id());
			}
		}
	}

	public void add_sink(LogSink sink)
	{
		synchronized(this)
		{
			_sinks ~= sink;
		}
	}

	public void remove_all_sinks()
	{
		synchronized(this)
		{
			_sinks = null;
		}
	}

	private LogSink[] _sinks;
}

unittest
{
	import std.concurrency;
	import std.stdio;
	import std.file;
	import std.uuid;

	static class ThreadedFormatter : Formatter
	{
		override string format(LogLevel loglevel, string m, string func, size_t line, SysTime st, string msg, uint thread_id)
		{
			return "T#%02s %s %s".format(abbr_thread_id(), LOGLEVEL_STR[loglevel], msg);
		}
	}

	static void worker(int i)
	{
		log.info("worker %s", i);
		send(ownerTid(),1);
	}

	log.remove_all_sinks();
	log.info("should not be logged");

	string tmpnam = randomUUID().toString();
	log.add_sink(new FileLogSink(tmpnam, new ThreadedFormatter));

	log.info("should be logged from main thread");

	auto tid = spawn(&worker, 1);
	receiveOnly!int();

	log.remove_all_sinks();

	auto text = readText(tmpnam);

	auto expected_text = `T#00 INFO should be logged from main thread
T#01 INFO worker 1
`;

	assert(text == expected_text);
}
