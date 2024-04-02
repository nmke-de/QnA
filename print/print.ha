use io;

export fn print(s: str) size = io::write(1, *(&s: *[]u8))!;
