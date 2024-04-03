use print::{fdprintv};
use strings::{concat};
use os::{exists, open};
use fs;
use io;

fn answerQuestion(storage: str, qid: str, answers: []str) int = {
	let filename = concat(storage, "/", qid);
	defer free(filename);
	if (!exists(filename)) {
		fdprintv(2, "Question ", qid, " does not exist.\n");
		return 3;
	};
	let f: io::file = open(filename, fs::flag::WRONLY, fs::flag::APPEND)!;
	defer io::close(f)!;
	for (let i = 0z; i < len(answers); i += 1) {
		fdprintv(f, answers[i], "\n");
	};
	return 0;
};
