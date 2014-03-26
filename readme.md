logging
---------------------------------------
***
Logging library for D. Extandable and configurable. Supports multiple sinks.

### Dependency solving and linking to project

Currently not uploaded to public dub registry (code.dlang.org), so some workaround is needed.

Use `dub add-local` possibility.

    git checkout git@gitlab.nemo.tv:dlibs/logging.git
    cd logging
    dub add-local .

Should add local reference to logging under ~master branch (may use tags or something else)


In dependant project simply add in dub.json under dependencies section

```json
"dependencies":
{
    "logging" : "~master"
}
```

### Example usage:

```d

import logging;

log.add_sink(new ConsoleLogSink);
log.add_sink(new FileLogSink("/dev/null"));
log.add_sink(new SysLogSink("test.app"));

log.error("this msg #%s: %s", 1, "error");
log.warn("this msg #%s: %s", 2, "warn");
log.info("this msg #%s: %s", 3, "info");
log.debg("this msg #%s: %s", 4, "debg");
log.trace("this msg #%s: %s", 5, "trace");
```

