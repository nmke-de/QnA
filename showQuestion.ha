use bufio::{read_line};
use os::{exists, open};
use print::{printv, logv};
use strings::{concat, fromutf8};
use io;

fn showQuestion(storage: str, qid: str) int = {
	let filename = concat(storage, "/", qid);
	defer free(filename);
	if (!exists(filename)) {
		logv("Question ", qid, " does not exist.\n");
		return 3;
	};
	let f: io::file = open(filename)!;
	defer io::close(f)!;
	printv(getQuestion(f), "\n");
	for (true) {
		const buf:[]u8 = match(read_line(f)) {
			case let bytes: []u8 => yield bytes;
			case io::EOF => break;
			case io::error => {
				logv("Failed to read answer at question ", qid, ".\n");
				return 7;
			};
		};
		printv(match(fromutf8(buf)) {
			case let s: str => yield s;
			case => continue;
		}, "\n");
	};
	return 0;
};
