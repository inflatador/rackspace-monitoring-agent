return {
  name = "rackspace-monitoring-agent",
  version = "1.9.7",
  dependencies = {
    "rphillips/options@0.0.5",
    "virgo-agent-toolkit/rackspace-monitoring-client@0.3",
    "virgo-agent-toolkit/virgo@0.13",
  },
  files = {
    "**.lua",
    "libs/$OS-$ARCH/*",
    "!*.ico",
    "!CHANGELOG",
    "!Dockerfile",
    "!LICENSE*",
    "!Makefile",
    "!README*",
    "!contrib",
    "!examples",
    "!lit",
    "!lit-*",
    "!luvi",
    "!static",
    "!tests",
    "!lua-sigar",
    "!rackspace-monitoring-agent",
  }
}
