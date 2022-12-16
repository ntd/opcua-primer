PKGCONFIG = pkg-config


all: server

server: server.c
	gcc -o server server.c $$($(PKGCONFIG) --cflags --libs open62541)

clean:
	-rm -f server

.phony: all clean
