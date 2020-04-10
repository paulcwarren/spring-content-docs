#!/bin/bash -eu

snippet () {
	echo Processing $1
	~/workspace/snippet/target/appassembler/bin/snippet $1
}
export -f snippet

main () {

	find $1 -name '*.html' | xargs -L1 bash -c 'snippet "$@"' _
}

main $@
