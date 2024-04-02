use io;

export fn log(s: str) size = io::write(2, *(&s: *[]u8))!;
