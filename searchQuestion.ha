use os::{exists};
use strings::{concat, dup};
use strconv::{u64tosb};
use hash::fnv::{string64};
use print::{logv};
use glob;

fn searchQuestion(storage: str, query: str) (str|void) = {
	// Check verbatim query
	const as_filename = concat(storage, "/", query);
	if (exists(as_filename))
		return as_filename;
	free(as_filename);

	// Check if full question was queried
	const as_fullquestion = concat(storage, "/", u64tosb(string64(query), 16));
	if (exists(as_fullquestion))
		return as_fullquestion;
	free(as_fullquestion);

	// Check if only the beginning of hash was queried
	// Prepare glob
	const as_glob = concat(storage, "/", query, "*");
	defer free(as_glob);
	let globber: glob::generator = glob::glob(as_glob);
	defer glob::finish(&globber);
	// Check first element
	const result = match (glob::next(&globber)) {
	case let s: str => yield dup(s);
	case let f: glob::failure =>
		logv(glob::strerror(f), "\n");
		return;
	case void => return;
	};
	// If a second element exists, return void due to unresolvable
	// ambiguities. Otherwise, return first result.
	match (glob::next(&globber)) {
	case void => return result;
	case str => return;
	case let f: glob::failure =>
		logv(glob::strerror(f), "\n");
		return;
	};
};
