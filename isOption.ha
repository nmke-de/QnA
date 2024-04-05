use strings::{toutf8};

fn isOption(s: str) bool = {
	const arr: []u8 = toutf8(s);
	return len(arr) > 0 && arr[0] == '-';
};
