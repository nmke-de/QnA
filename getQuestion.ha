use bufio::{read_line};
use strings::{fromutf8};
use io;

fn getQuestion(f: io::file) str = {
	io::seek(f, 0, io::whence::SET)!;
	const buf:[]u8 = match(read_line(f)) {
		case let bytes: []u8 => yield bytes;
		case io::EOF => yield [];
		case io::error => yield [];
	};
	return match(fromutf8(buf)) {
		case let s: str => yield s;
		case => yield "Invalid";
	};
};
