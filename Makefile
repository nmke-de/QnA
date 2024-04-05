
build: qna

install: build
	install qna /usr/local/bin/qna

uninstall:
	rm -f /usr/local/bin/qna

qna: *.ha print/*.ha
	hare build

clean:
	hare cache -c
	rm -f qna

.PHONY: build clean install uninstall
