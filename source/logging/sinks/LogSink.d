
module logging.sinks.LogSink;

import logging.levels;
import std.datetime;

interface LogSink
{
	void log(LogLevel loglevel, string m, string func, size_t line, SysTime time, string msg, uint thread_id);
	void loglevel(LogLevel level) @property;
}

class LogSinkBase : LogSink
{
	public override void loglevel(LogLevel level) @property
	{
		_loglevel = level;
	}

	public final void log(LogLevel loglevel, string m, string func, size_t line, SysTime time, string msg, uint thread_id)
	{
		if(loglevel <= _loglevel)
		{
			_log(loglevel, m, func, line, time, msg, thread_id);
		}
	}

	public abstract void _log(LogLevel loglevel, string m, string func, size_t line, SysTime time, string msg, uint thread_id);

	protected LogLevel _loglevel = LogLevel.Debug;
}
