
module logging.formatters.DefaultSyslogFormatter;

import std.datetime;
import std.string;
import logging.levels;
import logging.formatters.Formatter;

class DefaultSyslogFormatter : Formatter
{
	string format(LogLevel loglevel, string m, string func, size_t line, SysTime time, string msg, uint thread_id)
	{
			return "%s @%s():%s".format(
			msg,
			func,
			line
			);
	}
}
