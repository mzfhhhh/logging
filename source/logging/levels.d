
module logging.levels;

public enum LogLevel
{
	Error,
	Warning,
	Info,
	Debug,
	Trace
}

public enum string[LogLevel] LOGLEVEL_STR =
[
	LogLevel.Error	: "ERRR",
	LogLevel.Warning: "WARN",
	LogLevel.Info	: "INFO",
	LogLevel.Debug	: "DEBG",
	LogLevel.Trace	: "TRCE"
];
