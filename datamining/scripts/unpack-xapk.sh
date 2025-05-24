#!/bin/bash

# Set up directory structure
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DATAMINING_DIR="$PROJECT_ROOT/datamining"
XAPK_DIR="$DATAMINING_DIR/xapk"
PACK_DIR="$DATAMINING_DIR/pack"

# Function to show usage
show_usage() {
    echo "Usage: $0 [XAPK_FILE]"
    echo ""
    echo "If no XAPK file is specified, will use the latest one in datamining/xapk/"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Unpack latest XAPK"
    echo "  $0 SeaOfConquest_20250524_140917.xapk # Unpack specific XAPK"
}

# Determine which XAPK file to unpack
if [ $# -eq 0 ]; then
    # No argument provided, find the latest XAPK file
    XAPK_FILE=$(ls -t "$XAPK_DIR"/*.xapk 2>/dev/null | head -1)
    if [ -z "$XAPK_FILE" ]; then
        echo "❌ No XAPK files found in $XAPK_DIR"
        echo "💡 Run fetch-apk.sh first to download an XAPK file"
        exit 1
    fi
    echo "📦 Using latest XAPK: $(basename "$XAPK_FILE")"
elif [ $# -eq 1 ]; then
    # Argument provided
    if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
        show_usage
        exit 0
    fi

    # Check if it's a full path or just filename
    if [[ "$1" == *"/"* ]]; then
        XAPK_FILE="$1"
    else
        XAPK_FILE="$XAPK_DIR/$1"
    fi

    if [ ! -f "$XAPK_FILE" ]; then
        echo "❌ XAPK file not found: $XAPK_FILE"
        exit 1
    fi
else
    echo "❌ Too many arguments"
    show_usage
    exit 1
fi

# Extract filename without extension for directory name
FILENAME=$(basename "$XAPK_FILE" .xapk)
OUTPUT_DIR="$PACK_DIR/$FILENAME"

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo "📦 Unpacking XAPK file..."
echo "📁 Source: $XAPK_FILE"
echo "📁 Target: $OUTPUT_DIR"
echo ""

# Unpack the XAPK file
cd "$OUTPUT_DIR"
if unzip -q "$XAPK_FILE"; then
    echo "✅ XAPK unpacked successfully!"
    echo ""

    # Show what was extracted
    echo "📋 Contents extracted:"
    ls -la
    echo ""

    # Show APK files specifically
    APK_FILES=$(find . -name "*.apk" -type f)
    if [ ! -z "$APK_FILES" ]; then
        echo "📱 APK files found:"
        echo "$APK_FILES"
        echo ""
    fi

    # Show OBB files specifically
    OBB_FILES=$(find . -name "*.obb" -type f)
    if [ ! -z "$OBB_FILES" ]; then
        echo "🎮 OBB files found:"
        echo "$OBB_FILES"
        echo ""
    fi

    # Show directory size
    echo "📊 Total size: $(du -sh . | cut -f1)"
    echo "📍 Location: $OUTPUT_DIR"

else
    echo "❌ Failed to unpack XAPK file"
    exit 1
fi
