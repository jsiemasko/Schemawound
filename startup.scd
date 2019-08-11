Server.default = s = Server.internal
s.options //Setting WireBufs and MemSize large to avoid errors on big UGENS
	.numWireBufs_(1024)
	.memSize_(131072);
s.latency_(0.7);
s.boot();