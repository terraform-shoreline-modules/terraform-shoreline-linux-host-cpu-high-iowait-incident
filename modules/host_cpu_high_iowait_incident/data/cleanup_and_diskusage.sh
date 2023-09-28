bash

#!/bin/bash



# Set variables

TARGET_DIR=${DIRECTORY_PATH}
DAYS_MODIFIED=${DAYS_MODIFIED}


# Delete unnecessary files

sudo find $TARGET_DIR -type f -name "*.log" -ctime $DAYS_MODIFIED -delete



# Check available disk space

df -h $TARGET_DIR