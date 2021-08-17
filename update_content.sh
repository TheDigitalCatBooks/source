#!/bin/bash

# Each book has a directory in the sources path
# e.g. sources/pycabook
# Each book directory contains at least one directory with
# the same name where the book repository has been cloned
# e.g. sources/pycabook/pycabook
# and each book repository should contain the directory src
# e.g. sources/pycabook/pycabook/src
if [[ $# < 1 ]]; then echo "$0 <sources path>"; exit 1; fi

sources_dir=$1

for book_alias in $(find ${sources_dir} -maxdepth 1 -mindepth 1 -type d | xargs -n 1 basename);
do
    echo ${book_alias}
    book_sources=${sources_dir}/${book_alias}/${book_alias}/src
    if [[ ! -d ${book_sources} ]];
    then
	echo "Book sources directory ${book_sources} doesn't exist. Skipped"
	continue
    fi

    if [[ -z $(ls ${book_sources}/*.mau 2> /dev/null) ]]; then continue; fi
    
    for source_file in ${book_sources}/*.mau;
    do
	filename=$(basename ${source_file})
	echo cp ${source_file} pelican/content/${book_alias}_${filename}
    done
done
