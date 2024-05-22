#!/bin/bash

GENERATION_DIR=generated

# Input known tags dir
TAGS_DIR=$GENERATION_DIR/tags

# Input knowledge abount known files paths
FILES_PATHS_PATH=$GENERATION_DIR/files-names.txt

# Potential input tags-counting dir
TAGS_COUNTING_DIR=$GENERATION_DIR/tags-countings

# Potential input filters dir
FILTERS_DIR=filters

# Output file
LINKS_INSTRCTIONS_FILE=$GENERATION_DIR/links-instructions.sh

# Output file's links generation path
TAGS_LINKS_DIR=$GENERATION_DIR/tags-links

# Get links destination root folder
FILES_DIR=$(cat nas-dir.txt)

# Check the script is called with the minimum possible arguments count
if [[ "$#" -ne 2 ]]; then

    echo "Usage: $0 <link-type:'symbolic'|'hard'> <filter-type:'all'|'apparitions'|'filters-dir'>"
    exit 1
fi

LINKS_TYPE=$1
FILTER_TYPE=$2

# Check argument LINKS_TYPE is correctly spelled
if [[ $LINKS_TYPE != "symbolic" ]] && [[ $LINKS_TYPE != "hard" ]]; then

    echo "Invalid argument for link-type: $LINKS_TYPE"
    exit 2
fi

# Check argument FILTER_TYPE is correctly spelled
if [[ $FILTER_TYPE != "all" ]] && [[ $FILTER_TYPE != "apparitions" ]] && [[ $FILTER_TYPE != "filters-dir" ]]; then

    echo "Invalid argument for filter-type: $FILTER_TYPE"
    exit 3
fi

# In case $FILTER_TYPE == 'apparitions',
# check $TAGS_COUNTING_DIR and its content
# are present
if [[ $FILTER_TYPE == "apparitions" ]]; then

    if ! [[ -d $TAGS_COUNTING_DIR ]]; then

        echo ./$TAGS_COUNTING_DIR/ does not exist
        exit 4

    elif [[ $(find ./$TAGS_COUNTING_DIR/ -name "*-apparitions.txt" | wc -l) -eq 0 ]]; then

        echo *-apparitions.txt in ./$TAGS_COUNTING_DIR/ do not exist
        exit 5
    fi

    ./count-apparitions.sh

elif [[ $FILTER_TYPE == "filters-dir" ]]; then

    if ! [[ -d $FILTERS_DIR ]]; then

        echo "./$FILTERS_DIR/ does not exist"
        exit 6

    elif ! [[ -f $FILTERS_DIR/*.and.txt ]] && ! [[ -f $FILTERS_DIR/*.or.txt ]]; then

        echo "./$FILTERS_DIR/*.and.txt do not exist and"
        echo "./$FILTERS_DIR/*.or.txt do not exist"
        exit 7
    fi
fi

function createLink {

    tag=$1
    fileBaseName=$2
    filePath=$3

    # Create the dir containing links to files owning this file
    tagLinksDir=$TAGS_LINKS_DIR/$tag
    echo "mkdir -p $tagLinksDir" >> $LINKS_INSTRCTIONS_FILE

    if [[ -f $tagLinksDir/$fileBaseName ]]; then

        echo The tag $tag appears several times in $fileBaseName
        exitCode=1
    
    else

        if [[ $LINKS_TYPE == "symbolic" ]]; then

            # Create the link
            echo "ln -s \"$filePath\" \"$tagLinksDir/$fileBaseName\"" >> $LINKS_INSTRCTIONS_FILE
        
        else

            # Create the link
            echo "ln \"$filePath\" \"$tagLinksDir/$fileBaseName\"" >> $LINKS_INSTRCTIONS_FILE
        fi
    fi
}

# Remove previous generated instructions script
rm -f $LINKS_INSTRCTIONS_FILE

# Echo instructions file begin
echo "#!/bin/bash" >> $LINKS_INSTRCTIONS_FILE
echo "" >> $LINKS_INSTRCTIONS_FILE
echo "rm -rf $TAGS_LINKS_DIR" >> $LINKS_INSTRCTIONS_FILE

exitCode=0

# For each tag which exists
for tagPath in $TAGS_DIR/*; do

    tag=$(basename $tagPath | cut -d "." -f 1)

    # For each file having this tag
    while IFS= read -r fileBaseName; do

        # Find where is the file located
        filePath=$(grep -r "$fileBaseName" $FILES_PATHS_PATH)

        #echo $tag ?
        # Create link if apparition mode is set and apparitions conditions met
        #if [[ $FILTER_TYPE == "apparitions" ]] && [[ $(grep -r $tag $TAGS_COUNTING_DIR | wc -l) -gt 0 ]]; then

            #echo $tag !
            #grep -r $tag $TAGS_COUNTING_DIR | wc -l
            #exitCode=$(createLink "$tag" "$fileBaseName" "$filePath")

        # Create link if set to create all links
        #elif [[ $FILTER_TYPE == "all" ]]; then

            exitCode=$(createLink "$tag" "$fileBaseName" "$filePath")
        #fi

    done < $tagPath
done

chmod 777 $LINKS_INSTRCTIONS_FILE

exit $exitCode
