use print::{printv};
use os::{args, exit, getenv};
use strings::{concat};

export fn main() void = {
	// Read environment
	let storage: str = match(getenv("QNA_STORAGE")) {
	case void => yield concat(getenv("HOME") as str, "/.qna_storage");
	case let s: str => yield s;
	};

	// Read arguments
	let exitval: int = if (len(args) == 1) {
		printv("Syntax: QnA <question>\n\tQnA <question-id> <answer>\n\tQnA list\n\tQnA show <question-id>\n");
		yield 1;
	} else if (args[1] == "list") {
		yield listQuestions(storage);
	} else if (len(args) == 2) {
		yield askQuestion(storage, args[1]);
	} else if (args[1] == "show") {
		yield showQuestion(storage, args[2]);
	} else {
		yield answerQuestion(storage, args[1], args[2..]);
	};
	exit(exitval);
};
