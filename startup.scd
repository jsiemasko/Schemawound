Server.default = s = Server.internal;
//Setting WireBufs and MemSize large to avoid errors on big UGENS
s.options.numWireBufs_(1024);
s.options.memSize_(131072);
s.latency_(0.7);
s.boot();