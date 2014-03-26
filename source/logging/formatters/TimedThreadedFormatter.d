
module logging.formatters.TimedThreadedFormatter;

import std.datetime;
import std.string;
import logging.levels;
import logging.utils;
import logging.formatters.Formatter;

class TimedThreadedFormatter : Formatter
{
	override string format(LogLevel loglevel, string m, string func, size_t line, SysTime st, string msg, uint thread_id)
	{
		return "%4s.%02u.%02s.%02s.%02s.%06s T#%02s %s %s (at %s():%s)".format(
			st.year,
			st.month,
			st.day,
			st.hour,
			st.minute,
			st.fracSec.usecs,
			abbr_thread_id(),
			LOGLEVEL_STR[loglevel],
			msg,
			func,
			line
			);
	}
}
