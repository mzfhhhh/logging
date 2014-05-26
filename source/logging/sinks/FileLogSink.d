
module logging.sinks.FileLogSink;

import std.datetime;
import std.stdio;
import logging.sinks.LogSink;
import logging.formatters;

public class FileLogSink : LogSinkBase
{
	private File _file;

	public this(string filename, Formatter fmt = null)
	{
		_file.open(filename, "a");
		_file.setvbuf(300, _IOLBF);

		if(fmt is null)
		{
			fmt = new TimedThreadedFormatter;
		}

		_formatter = fmt;
	}

	public override void _log(LogLevel loglevel, string m, string func, size_t line, SysTime time, string msg, uint thread_id)
	{
		auto fmsg = _formatter.format(loglevel, m, func, line, time, msg, thread_id);
		_file.writeln(fmsg);
	}

	public void formatter(Formatter fmt) @property
	{
		_formatter = fmt;
	}

	private Formatter _formatter;
}
