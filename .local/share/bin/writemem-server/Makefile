CC=gcc
CFLAGS=

PREFIX=/usr/local
SERVICE_DIR=/etc/systemd/system

all: writemem-server

writemem-server: main.c
	$(CC) $(CFLAGS) main.c -o writemem-server

clean:
	rm -f writemem-server

install:
	make
	sed -i "s|/home/e|$(HOME)|g" writemem-server.service
	sudo touch $(HOME)/.cache/writemem
	sudo chmod a+rw $(HOME)/.cache/writemem
	sudo install -m 755 writemem-server $(PREFIX)/bin
	sudo install -m 644 writemem-server.service $(SERVICE_DIR)
	sudo systemctl enable writemem-server.service
	sudo systemctl daemon-reload

uninstall:
	sudo systemctl disable writemem-server.service
	sudo rm -f $(PREFIX)/bin/writemem-server
	sudo rm -f $(SERVICE_DIR)/writemem-server.service
	sudo systemctl daemon-reload
