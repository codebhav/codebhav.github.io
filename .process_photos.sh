#!/bin/bash

# Directory paths
FULLSIZE_DIR="assets/images/photos/fullsize"
THUMBS_DIR="assets/images/photos/thumbs"
PHOTOS_DIR="_photos"

# Create directories if they don't exist
mkdir -p "$FULLSIZE_DIR"
mkdir -p "$THUMBS_DIR"
mkdir -p "$PHOTOS_DIR"

# Function to convert filename to title
filename_to_title() {
    # Replace hyphens with spaces and capitalize each word
    echo "$1" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)} 1'
}

# Check if ImageMagick is installed and determine the correct command
if command -v magick &> /dev/null; then
    # ImageMagick v7+
    CONVERT_CMD="magick"
    echo "Using ImageMagick v7+ (magick command)"
elif command -v convert &> /dev/null; then
    # ImageMagick v6 or earlier
    CONVERT_CMD="convert"
    echo "Using ImageMagick v6 or earlier (convert command)"
else
    echo "Error: ImageMagick is not installed. Please install it first."
    exit 1
fi

# Process new photos
echo "Checking for new photos..."
found_new=0

for file in "$FULLSIZE_DIR"/*.jpg "$FULLSIZE_DIR"/*.jpeg "$FULLSIZE_DIR"/*.png "$FULLSIZE_DIR"/*.JPG "$FULLSIZE_DIR"/*.JPEG "$FULLSIZE_DIR"/*.PNG; do
    # Skip if pattern doesn't match any files
    [ -e "$file" ] || continue
    
    # Get basename of file
    filename=$(basename "$file")
    base="${filename%.*}"
    ext="${filename##*.}"
    
    # Make sure extension is lowercase
    lowercase_ext=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
    standardized_filename="$base.$lowercase_ext"
    
    # Standardize filename if needed
    if [ "$filename" != "$standardized_filename" ]; then
        echo "Standardizing filename: $filename -> $standardized_filename"
        mv "$file" "$FULLSIZE_DIR/$standardized_filename"
        filename="$standardized_filename"
    fi
    
    # Check if thumbnail already exists
    if [ ! -f "$THUMBS_DIR/$filename" ]; then
        echo "Processing new photo: $filename"
        found_new=1
        
        # Create a thumbnail that's appropriate for the gallery
        echo "Creating thumbnail..."
        $CONVERT_CMD "$FULLSIZE_DIR/$filename" -resize "400x300^" -gravity center -extent 400x300 -quality 85 "$THUMBS_DIR/$filename"
        
        if [ $? -ne 0 ]; then
            echo "Error: Failed to create thumbnail for $filename"
            continue
        fi
        
        # Create MD file if it doesn't exist
        md_file="$PHOTOS_DIR/$base.md"
        if [ ! -f "$md_file" ]; then
            echo "Creating Markdown file..."
            title=$(filename_to_title "$base")
            current_date=$(date +"%Y-%m-%d")
            
            # Create the MD file with front matter
            cat > "$md_file" << EOF
---
layout: photo
title: "$title"
image: $filename
date: $current_date
---

$title.
EOF
            echo "Created $md_file"
        fi
        
        echo "Finished processing $filename"
        echo "------------------------"
    fi
done

# Show summary
if [ $found_new -eq 0 ]; then
    echo "No new photos found."
else
    echo "Successfully processed new photos!"
fi

echo "All done!"