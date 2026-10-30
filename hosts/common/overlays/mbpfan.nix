# mbpfan 2.4.0 predates the applesmc hwmon conversion in Linux 7.3
# (torvalds/linux@94f5081d3592, first in v7.3-rc1). The driver moved fan
# attributes into <applesmc device>/hwmon/hwmonN/ and renamed them
# (fanN_output -> fanN_target, fanN_manual -> pwmN_enable), so mbpfan's
# legacy probe finds nothing and it exits with
# "mbpfan could not detect any fan. Please contact the developer."
# Patch is upstream PR linux-on-mac/mbpfan#273 (open, not yet merged); it
# keeps the legacy probe and falls back to the hwmon files.
# Leaf package: rebuilding it touches nothing else, no stdenv impact.
final: prev: {
  mbpfan = prev.mbpfan.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      ./patches/mbpfan-2.4.0-hwmon-7.3.patch
    ];
  });
}
