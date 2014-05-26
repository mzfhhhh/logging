
module logging.sinks.SysLogSink;

import std.datetime;
import std.string;
import logging.sinks.LogSink;
import logging.formatters;

private import logging.syslog;

private enum int[LogLevel] LOGLEVEL_TO_SYSLOG_PRIORITY =
[
	LogLevel.Error	: LOG_ERR,
	LogLevel.Warning: LOG_WARNING,
	LogLevel.Info	: LOG_INFO,
	LogLevel.Debug	: LOG_DEBUG,
	LogLevel.Trace	: LOG_DEBUG
];


public class SysLogSink : LogSinkBase
{
	public this(string ident, Formatter fmt = null)
	{
		if(fmt is null)
		{
			fmt = new DefaultSyslogFormatter;
		}

		_formatter = fmt;

		openlog(ident.ptr, 0, 0);
	}

	public ~this()
	{
		closelog();
	}

	public override void _log(LogLevel loglevel, string m, string func, size_t line, SysTime time, string msg, uint thread_id)
	{
		auto fmsg = _formatter.format(loglevel, m, func, line, time, msg, thread_id);

		auto priority  = LOGLEVEL_TO_SYSLOG_PRIORITY[loglevel];

		.syslog(priority, "%s", toStringz(fmsg));
	}

	public void formatter(Formatter fmt) @property
	{
		_formatter = fmt;
	}

	private Formatter _formatter;
}
