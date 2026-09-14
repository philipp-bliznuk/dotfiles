# debloat

Disable unused Apple launchd services (Siri, Apple Intelligence, Music, TV+,
Books, Safari agents, iMessage/FaceTime relays, Family, Touch Bar, Print, ...)
and keep them off across reboots while SIP stays on.

Catalog lives in `labels.txt`. Derived from
[mac-os-debloat](https://github.com/OleksandrKrupko/mac-os-debloat) v0.13.2
(MIT), filtered to labels that actually hold with SIP enabled. iCloud, Apple ID,
Keychain, App Store, Calendar, Reminders, Time Machine and Spotlight UI are
deliberately not in the list.

## Why a daemon

With SIP on, launchd drops `launchctl disable` overrides for Apple services at
every boot (`Ignoring enabled state due to rootless restrictions`). Overrides do
hold until the next reboot, so the only moments that matter are boot (system
domain) and login (gui domain). `install` adds a tiny LaunchDaemon that runs
`apply` at boot and every 5 minutes; after the first post-login pass every run
is a no-op. macOS updates reset overrides too; the daemon covers that.

Labels marked `[sip-off]` upstream are demand-started over XPC and respawn in
seconds while SIP is on. They are excluded rather than fought. Same rule for
anything found respawning here: a label that shows `RUN` while `off` in
`status` after a daemon pass is a demand-start respawner on this build, drop it
from `labels.txt`. Dropped so far on macOS 27.0.1:
`com.apple.GenerativeFunctions.agentstored`, `com.apple.sidecar-relay`,
`com.apple.synapse.contentlinkingd`.

## Usage

```sh
./debloat status           # off / on / RUN:<pid> per label
sudo ./debloat apply       # disable + stop, holds until reboot
sudo ./debloat install     # copy to /Library/Application Support/debloat, add daemon, apply
sudo ./debloat uninstall   # remove daemon and copy (overrides stay until reboot)
sudo ./debloat enable      # re-enable every label, remove daemon
sudo ./debloat prune       # third-party launchd plists whose program is gone, y/N each
```

Run from the repo. Nothing is symlinked; `install` copies the script and
`labels.txt` root-owned so the daemon never executes a user-writable file.
Re-run `sudo ./debloat install` after editing `labels.txt`.

## Files

| Path | Purpose |
|---|---|
| `/Library/LaunchDaemons/dev.bliznuk.debloat.plist` | boot daemon (`RunAtLoad`, `StartInterval 300`) |
| `/Library/Application Support/debloat/debloat` | root-owned copy of the script |
| `/Library/Application Support/debloat/labels.txt` | root-owned copy of the catalog |
| `/Library/Application Support/debloat/debloat.log` | stderr of daemon runs |
| `/Library/Application Support/debloat/snapshot.txt` | `launchctl print-disabled` before first apply |

## Revert

`sudo ./debloat enable` lifts every override and removes the daemon. A reboot
alone also resets everything launchd-related.

## Manual, outside the script

Persist across updates on their own:

```sh
sudo mdutil -a -d && sudo mdutil -a -E   # Spotlight indexing off, index erased
sudo tmutil disable                      # Time Machine automatic backups off
```

Revert: `sudo mdutil -a -i on`, `sudo tmutil enable`.

System Settings: Apple Intelligence & Siri off; Privacy & Security > Analytics
all off, Personalized Ads off; Game Center sign out; iCloud toggles off for
apps not used (Photos, Music, TV, Books, Safari, Mail, Contacts, Notes,
Messages); Spotlight > uncheck Siri Suggestions.

## Known side effects

- `com.apple.companiond` off: Apple Watch auto-unlock and iPhone hotspot
  auto-join stop. Delete the line if wanted.
- `com.apple.powerchime` off: no charging chime.
- `com.apple.navd` off: no time-to-leave notifications.
- Safari agents off: Safari still launches, web push and Web Inspector do not.
