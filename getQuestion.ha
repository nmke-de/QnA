use bufio::{read_line};
use strings::{fromutf8};
use io;

// Reads the question from a file.
fn getQuestion(f: io::file) str = {
	// The question is always found at the beginning.
	io::seek(f, 0, io::whence::SET)!;

	// Read first line
	const buf:[]u8 = match(read_line(f)) {
		case let bytes: []u8 => yield bytes;
		case io::EOF => yield [];
		case io::error => yield [];
	};

	// Convert to Hare String and return
	return match(fromutf8(buf)) {
		case let s: str => yield s;
		case => yield "Invalid";
	};
};
