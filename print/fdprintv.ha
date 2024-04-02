use io;

// Print text to fd.
export fn fdprintv(fd: io::file, text: str...) size = {
	// TODO use stack for allocation, or at least determine array length at compile time (VLA).
	let vec: []io::vector = [];
	defer free(vec);
	for (let i: size = 0; i < len(text); i += 1) {
		append(vec, io::mkvector(*(&(text[i]): *[]u8)));
	};
	return io::writev(fd, vec...)!;
};

@test fn fdprintv() void = {
	assert(fdprintv(1, "Hello ", "World!", "\n") == 13, "Print failed.");
	assert(fdprintv(1, "") == 0, "Printing nothing failed.");
	assert(fdprintv(1) == 0, "Printing absolutely nothing failed.");
	assert(fdprintv(2, "Logging.") == 8, "Logging failed.");
};
