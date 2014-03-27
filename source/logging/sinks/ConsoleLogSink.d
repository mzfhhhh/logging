
module logging.sinks.ConsoleLogSink;

import std.datetime;
import logging.sinks.LogSink;
import logging.formatters;

public class ConsoleLogSink : LogSink
{
	public this(Formatter fmt = new ConsoleFormatter)
	{
		_formatter = fmt;
	}

	public override void log(LogLevel loglevel, string m, string func, size_t line, SysTime time, string msg, uint thread_id)
	{
		auto fmsg = _formatter.format(loglevel, m, func, line, time, msg, thread_id);

		std.stdio.writeln(fmsg);
	}

	public void formatter(Formatter fmt) @property
	{
		_formatter = fmt;
	}

	private Formatter _formatter;
}
