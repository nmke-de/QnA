use bufio::{read_line};
use os::{getenv, open};
use print::{printv, logv};
use strings::{concat, fromutf8};
use unix::{pipe};
use io;
use os::exec;

// Show the content of a question given its hash or the question name.
fn showQuestion(storage: str, qid: str) int = {
	// Open file
	let filename = match(searchQuestion(storage, qid)) {
	case let s: str => yield s;
	case void =>
		logv("Question ", qid, " does not exist.\n");
		return 3;
	};
	defer free(filename);
	let f: io::file = open(filename)!;
	defer io::close(f)!;

	// Spawn pager and create pipe
	// Determine whether to spawn pager and read environment
	let pager: str = match (getenv("QNA_PAGER")) {
	case void => yield "";
	case let s: str => yield s;
	};
	// If QNA_PAGER is not set, don't spawn pager
	if (pager != "") {
		// Create pipe
		match (pipe()) {
		case let pipes: (io::file, io::file) =>
			// If pipe creation was successful, fork
			match (exec::fork()) {
			case void =>
				// Spawn pager
				io::close(pipes.1)!;
				io::close(0)!;
				io::dup2(pipes.0, 0, io::dupflag::NOCLOEXEC)!;
				io::close(pipes.0)!;
				exec::exec(&exec::cmd("/bin/sh", "-c", pager)!);
			case exec::error =>
				// If fork failed, close pipe and continue
				logv("Failed to fork.\n");
				io::close(pipes.0)!;
				io::close(pipes.1)!;
			case let child: exec::process =>
				// As parent, set up pipes and don't quit before
				// child.
				defer exec::wait(&child)!;
				io::close(pipes.0)!;
				io::close(1)!;
				io::dup2(pipes.1, 1, io::dupflag::NOCLOEXEC)!;
				io::close(pipes.1)!;
				return showQuestion_print(qid, f);
			};
		case => yield;
		};
	};
	return showQuestion_print(qid, f);
};

fn showQuestion_print(qid: str, f: io::file) int = {
	// Print question title
	printv("# ", getQuestion(f), "\n\n");
	for (const buf => read_line(f)!) {
		printv(match(fromutf8(buf)) {
			case let s: str => yield s;
			case => continue;
		}, "\n\n");
	};
	io::close(1)!;
	return 0;
};
