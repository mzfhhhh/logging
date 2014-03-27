
module logging.formatters.ConsoleFormatter;

import std.datetime;
import std.string;
import logging.levels;
import logging.formatters.Formatter;

private enum string[LogLevel] LOGLEVEL_TO_COLOR =
[
	LogLevel.Error	: "\x1b[31;01m",
	LogLevel.Warning: "\x1b[33m",
	LogLevel.Info	: "",
	LogLevel.Debug	: "\x1b[02m",
	LogLevel.Trace	: "\x1b[02m"
];

class ConsoleFormatter : Formatter
{
	string format(LogLevel loglevel, string m, string func, size_t line, SysTime time, string msg, uint thread_id)
	{
		return "%s%s \x1b[02m@%s:%s\x1b[00m".format(
		LOGLEVEL_TO_COLOR[loglevel],
		msg,
		func,
		line
		);
	}
}
