#!/bin/bash

# Set up directory structure
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DATAMINING_DIR="$PROJECT_ROOT/datamining"
XAPK_DIR="$DATAMINING_DIR/xapk"

# Create directories if they don't exist
mkdir -p "$XAPK_DIR"

# Download Sea of Conquest XAPK
echo "📦 Downloading Sea of Conquest XAPK..."
echo "📁 Saving to: $XAPK_DIR"

OUTPUT_FILE="$XAPK_DIR/SeaOfConquest_$(date +%Y%m%d_%H%M%S).xapk"

curl -L \
    --progress-bar \
    --fail \
    --retry 3 \
    --retry-delay 5 \
    --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" \
    -o "$OUTPUT_FILE" \
    "https://d.apkpure.com/b/XAPK/com.seaofconquest.gpru?version=latest"

if [ $? -eq 0 ]; then
    echo "✅ Download successful!"
    echo "📁 File location: $OUTPUT_FILE"
    echo "📊 File size: $(du -h "$OUTPUT_FILE" | cut -f1)"

    # Optional: Show XAPK contents
    echo "📦 XAPK contents:"
    unzip -l "$OUTPUT_FILE" | head -10
else
    echo "❌ Download failed"
    exit 1
fi
