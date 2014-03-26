
module logging.sinks.LogSink;

import logging.levels;
import std.datetime;

interface LogSink
{
	void log(LogLevel loglevel, string m, string func, size_t line, SysTime time, string msg, uint thread_id);
}
