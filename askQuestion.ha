use print::{fdprintv};
use strings::{concat};
use strconv::{u64tosb};
use hash::fnv::{string64};
use os::{create, exists, mkdir};
use io;

// Create a new question
fn askQuestion(storage: str, question: str) int = {
	// Encertain the existence of the storage
	if (!exists(storage)) {
		match (mkdir(storage, 0o755)) {
			case void => yield;
			case => {
				fdprintv(2, "Could not create storage at `", storage, "`.\n");
				return 8;
			};
		};
	};

	// Generate hash and filename
	let filename = concat(storage, "/", u64tosb(string64(question), 17));
	defer free(filename);

	// Check if file exists
	if (exists(filename)) {
		fdprintv(2, "Hash error occured.\n");
		return 3;
	};

	// Create file and add quesion title
	let f: io::file = create(filename, 0o644)!;
	defer io::close(f)!;
	fdprintv(f, question, "\n");
	return 0;
};
