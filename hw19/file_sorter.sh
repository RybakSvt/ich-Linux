
#!/bin/bash

# Directory paths
BASE_DIR="/opt/250425-ptm/svetlana.r"
DIR1="$BASE_DIR/random_files"
DIR2="$BASE_DIR/even_files"

# Create and clean directories
mkdir -p "$DIR1" "$DIR2"

# Create 100 files with random names
echo "Creating 100 files in $DIR1"
for i in {1..100}; do
    touch "$DIR1/$RANDOM"
done

# Move files with even numbers
count_moved=0
for file in "$DIR1"/*; do
    filename=$(basename "$file")
    if (( filename % 2 == 0 )); then
        mv "$file" "$DIR2/"
        ((count_moved++))
    fi
done

# Results
echo "Done! Files moved: $count_moved"
echo "Remaining in $DIR1: $((100 - count_moved))"
