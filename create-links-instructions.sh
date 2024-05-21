#!/bin/bash

if [[ "$#" -ne 1 ]]; then

    echo "Usage: $0 <'symbolic'|'hard'>"
    exit 1
fi

LINKS_TYPE=$1

if [[ $LINKS_TYPE != "symbolic" ]] && [[ $LINKS_TYPE != "hard" ]]; then

    echo "Invalid argument: $LINKS_TYPE"
    exit 2
fi

GENERATION_DIR=generated
TAGS_DIR=$GENERATION_DIR/tags
FILES_PATHS_PATH=$GENERATION_DIR/files-names.txt
TAGS_LINKS_DIR=$GENERATION_DIR/tags-links

LINKS_INSTRCTIONS_FILE=generated/links-instructions.sh

FILES_DIR=$(cat nas-dir.txt)

rm -f $LINKS_INSTRCTIONS_FILE

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
    done < $tagPath
done

chmod 777 $LINKS_INSTRCTIONS_FILE

exit $exitCode
