#!/bin/bash

# Each book has a directory in the sources path
# e.g. sources/pycabook
# Each book directory contains at least one directory with
# the same name where the book repository has been cloned
# e.g. sources/pycabook/pycabook
# and each book repository should contain the directory src
# e.g. sources/pycabook/pycabook/src

sources_dir=sources
content_dir=content
images_dir=images

pelican_content_dir=pelican/content
pelican_images_dir=${pelican_content_dir}/images

echo "Delete content in ${pelican_content_dir}/*"
rm -fr ${pelican_content_dir}/*

# Copy global content
echo "Copy global content ${content_dir} -> ${pelican_content_dir}"
cp -r ${content_dir}/* ${pelican_content_dir}

# Copy global images
echo "Copy global images ${images_dir}/global -> ${pelican_images_dir}"
mkdir ${pelican_images_dir}
cp -r ${images_dir}/global ${pelican_images_dir}

for book_alias in $(find ${sources_dir} -maxdepth 1 -mindepth 1 -type d | xargs -n 1 basename);
do
    echo "Processing book: ${book_alias}"
    if [[ -f ${sources_dir}/${book_alias}/.ignore ]]; then
	echo "Directory ${book_alias} ignored because of .ignore"
	continue
    fi
    
    book_sources=${sources_dir}/${book_alias}/${book_alias}/src
    book_images=${sources_dir}/${book_alias}/${book_alias}/images
    book_content_images=${content_dir}/images/${book_alias}

    # Check the book sources

    if [[ ! -d ${book_sources} ]];
    then
	echo "Book sources directory ${book_sources} doesn't exist. Skipped"
	continue
    fi

    # Copy the book source files

    if [[ -z $(ls ${book_sources}/*.mau 2> /dev/null) ]]; then continue; fi

    echo "Copy book source files ${book_sources} -> ${pelican_content_dir}/${book_alias}_*"
    for source_file in ${book_sources}/*.mau;
    do
	filename=$(basename ${source_file})
	cp ${source_file} ${pelican_content_dir}/${book_alias}_${filename}
    done

    # Copy the book images
    mkdir ${pelican_images_dir}/${book_alias}

    echo "Copy book images ${book_images} -> ${pelican_images_dir}/${book_alias}"
    cp -r ${book_images}/* ${pelican_images_dir}/${book_alias}

    # Copy custom book images
    echo "Copy custom images ${images_dir} -> ${pelican_images_dir}/${book_alias}"
    cp -r ${images_dir}/${book_alias}/* ${pelican_images_dir}/${book_alias}

    echo
done
