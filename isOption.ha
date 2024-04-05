use strings::{toutf8};

// Check whether a command line argument is an option.
fn isOption(s: str) bool = {
	const arr: []u8 = toutf8(s);
	return len(arr) > 0 && arr[0] == '-';
};
