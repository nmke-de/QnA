use print::{fdprintv};
use strings::{concat};
use strconv::{u64tosb};
use hash::fnv::{string64};
use os::{create, exists};
use io;

fn askQuestion(storage: str, question: str) int = {
	let filename = concat(storage, "/", u64tosb(string64(question), 16));
	defer free(filename);
	if (exists(filename)) {
		fdprintv(2, "Hash error occured.\n");
		return 3;
	};
	let f: io::file = create(filename, 0o644)!;
	defer io::close(f)!;
	fdprintv(f, question, "\n");
	return 0;
};
