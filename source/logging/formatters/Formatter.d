
module logging.formatters.Formatter;

public import logging.levels;

private import std.datetime;

interface Formatter
{
	string format(LogLevel loglevel, string m, string func, size_t line, SysTime time, string msg, uint thread_id);
}
