use print::{printv};
use os::{args, exit, getenv};
use strings::{concat};
use io::{read};

export fn main() void = {
	// Read environment
	let storage: str = match(getenv("QNA_STORAGE")) {
	case void => yield concat(getenv("HOME") as str, "/.qna_storage");
	case let s: str => yield s;
	};

	// Read arguments
	let exitval: int = if (len(args) == 1 || args[1] == "help" || isOption(args[1])) {
		printv("Syntax: qna <question>\n\tqna <question-id> <answer>\n\tqna list\n\tqna show <question-id>\n");
		yield 1;
	} else if (args[1] == "list") {
		yield listQuestions(storage);
	} else if (len(args[1]) < 8 && args[1] != "show") {
		printv("\"", args[1], "\" is very short for a question. Continue? (y/N) ");
		let buf: [2]u8 = [0u8...];
		match (read(0, buf)) {case => yield;};
		yield switch (buf[0]) {
		case 'y' => yield askQuestion(storage, args[1]);
		case 'Y' => yield askQuestion(storage, args[1]);
		case => yield 1;
		};
	} else if (len(args) == 2 && args[1] != "show") {
		yield askQuestion(storage, args[1]);
	} else if (args[1] == "show" && len(args) == 3) {
		yield showQuestion(storage, args[2]);
	} else {
		yield answerQuestion(storage, args[1], args[2..]);
	};
	exit(exitval);
};
