#!/usr/bin/env node
var lines = require("fs").readFileSync(__dirname + "/../../../zones/transitions.txt", "utf8").split(/\n/);
lines.pop()
require("../../proof")(lines.length * 2, function (equal, tz) {
  // TODO Not automatically applying zone.
  var partials = {}
  for (var i = 0, I = lines.length; i < I; i++) {
    line = lines[i];
    var record = line.split(/\s/)
    name = record[0];
    wallclock = record[1];
    posix = record[2];
    before = record[3];
    after = record[4];
    local = (partials[name]) || (partials[name] = tz(require("timezone/" + name, name)));
    equal(
      local(tz(posix, "%F %T%$", "-1 millisecond"), name, "%::z/%Z"),
      before,
      [ name, wallclock, posix, before, "before",
        local(tz(posix, "%F %T%$", "-1 millisecond"), name, "%::z/%Z"),
        tz(posix, "-1 millisecond") ].join(" "));
    equal(
      local(tz(posix, "%F %T%$"), name, "%::z/%Z"),
      after,
      [ name, wallclock, posix, after, "after",
        local(tz(posix, "%F %T%$"), name, "%::z/%Z") ].join(" "));
  }
});
