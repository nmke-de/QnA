
export fn logln(text: str...) size = {
	let new_text : []str = [];
	for (let i = 0z; i < len(text); i += 1) {
		append(new_text, text[i]);
	};
	append(new_text, "\n");
	return fdprintv(2, new_text...);
};
