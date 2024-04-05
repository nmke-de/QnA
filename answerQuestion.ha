use print::{fdprintv};
use strings::{concat};
use os::{exists, open};
use fs;
use io;

// Add answers to a question given its has or title.
fn answerQuestion(storage: str, qid: str, answers: []str) int = {
	// Open file
	let filename = match (searchQuestion(storage, qid)) {
	case let s: str => yield s;
	case void =>
		fdprintv(2, "Question ", qid, " does not exist.\n");
		return 3;
	};
	defer free(filename);
	let f: io::file = open(filename, fs::flag::WRONLY, fs::flag::APPEND)!;
	defer io::close(f)!;

	// Iterate over answers and append them.
	for (let i = 0z; i < len(answers); i += 1) {
		fdprintv(f, answers[i], "\n");
	};
	return 0;
};
