use os::{diropen};
use print::{printv, logv};
use fs;
use io;

fn listQuestions(storage: str) int = {
	// Open directory
	const store_fs: *fs::fs = match (diropen(storage)) {
		case let f: *fs::fs => yield f;
		case fs::error => {
			logv("Failed to open storage at `", storage, "`.\n");
			return 4;
		};
	};
	const close: *fs::closefunc = store_fs.close as *fs::closefunc;
	const store_iter: *fs::iterfunc = store_fs.iter as *fs::iterfunc;
	const open: *fs::openfilefunc = store_fs.openfile as *fs::openfilefunc;
	defer close(store_fs);
	const iter: *fs::iterator = match (store_iter(store_fs, ".")) {
		case let i: *fs::iterator => yield i;
		case fs::error => {
			logv("Failed to iterate over storage at `", storage, "`.\n");
			return 5;
		};
	};
	defer match (iter.finish) {
		case null => yield;
		case let finish: *fs::finishfunc => finish(iter);
	};

	// Iterate over directory
	for (true) {
		const entry: fs::dirent = match(iter.next(iter)) {
			case let d: fs::dirent => yield d;
			case void => break;
			case fs::error => {
				logv("Error when iterating over storage at `", storage, "`.\n");
				return 6;
			};
		};
		// Ignore files that are not regular files
		if (entry.ftype & fs::mode::REG != fs::mode::REG)
			continue;
		// TODO Read question and print filename (hash) and question to
		// screen
		let f: io::file = open(store_fs, entry.name)!;
		defer io::close(f)!;
		printv(entry.name, "\t", getQuestion(f), "\n");
	};
	return 0;
};
