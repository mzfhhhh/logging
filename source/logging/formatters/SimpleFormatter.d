
module logging.formatters.SimpleFormatter;

import std.datetime;
import std.string;
import logging.levels;
import logging.formatters.Formatter;

class SimpleFormatter : Formatter
{
	string format(LogLevel loglevel, string m, string func, size_t line, SysTime time, string msg, uint thread_id)
	{
			return "%s %s @%s:%s".format(
			LOGLEVEL_STR[loglevel],
			msg,
			func,
			line
			);
	}
}
