#!/usr/bin/env bash

# Exit on error
set -e 

# Define container name map
declare -A CONTAINERS=(
    [devel]=devel_docker
    [thor]=thor_docker
    [orin]=orin_docker
)

# Tag for server
BASE_TAG="jetson_thor"

# Default computer architecture
ARCH=$(uname -m)

# Import print_color.sh
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $SCRIPT_DIR/utils/print_color.sh

function usage() {
    print_info ""
    print_info "Usage: ./build.sh [OPTIONS]"
    print_info ""
    print_info "Options:"
    print_info "  -t | --target user| devel          # Type of docker to build"
    print_info "  -v | --version <version>           # Version to apply (Use with --target devel)"
    print_info "  -h | --help                        # Show this help mesage and exit"
    print_info ""
    print_info "Examples:"
    print_info "  ./build.sh --target user                     # Build user_docker image"
    print_info "  ./build.sh --target devel --version v1.0     # Build devel_docker image and tag it"
    print_info ""
    print_info "Happy Dockering! May your layers cache and your builds never fail."
}

VALID_ARGS=$(getopt -o ht:v: --long help,target:,version: -- "$@")
eval set -- "$VALID_ARGS"

while [ : ]; do
    case "$1" in
        -t | --target)
            TARGET="$2"
            shift 2
            ;;
        -v | --version)
            VERSION="$2"
            shift 2
            ;;
        -h | --help)
            usage
            exit 0
            ;;
        --) shift;
            break
            ;;
    esac
done

# Validate target
if [[ -z "$TARGET" ]] || [[ -z "${CONTAINERS[$TARGET]}" ]]; then
    print_error "Invalid or missing target."
    usage
    exit 1
fi

# Set container name
CONTAINER_NAME="${CONTAINERS[$TARGET]}"

# Export runtime environment
export USER_ID=$(id -u)
export USER_NAME=$(whoami)

# Export for compose context
export CONTAINER_NAME

# If argument passed and is 'devel', build devel_docker profile instead
if [[ "$TARGET" == "devel" ]]; then
    print_info "Target selected: $TARGET"
    print_info "Building ${TARGET}_docker image ..."
    docker compose --profile $TARGET --file docker-compose.build.yml build
    print_info "Successfully build ${TARGET}_docker:latest"

    if [[ -n "$VERSION" ]]; then
        print_info "Tagging ${TARGET}_docker:latest as $BASE_TAG:$VERSION"
        docker image tag ${TARGET}_docker:latest "$BASE_TAG:$VERSION"
        print_info "Successfully tagged $BASE_TAG:$VERSION"
    else
        print_warning "No version provided. Skipping tagging."
    fi
elif [[ "$TARGET" == "thor" ]]; then
    print_info "Target selected: $TARGET"
    print_info "Building ${TARGET}_docker image ..."
    docker compose --profile $TARGET --file docker-compose.build.yml build
    print_info "Successfully build ${TARGET}_docker:latest"

    if [[ -n "$VERSION" ]]; then
        print_info "Tagging ${TARGET}_docker:latest as $BASE_TAG:$VERSION"
        docker image tag ${TARGET}_docker:latest "$BASE_TAG:$VERSION"
        print_info "Successfully tagged $BASE_TAG:$VERSION"
    else
        print_warning "No version provided. Skipping tagging."
    fi

elif [[ "$TARGET" == "orin" ]]; then
    print_info "Target selected: $TARGET"
    print_info "Building ${TARGET}_docker image ..."
    docker compose --profile $TARGET --file docker-compose.build.yml build
    print_info "Successfully build ${TARGET}_docker:latest"

    if [[ -n "$VERSION" ]]; then
        print_info "Tagging ${TARGET}_docker:latest as $BASE_TAG:$VERSION"
        docker image tag ${TARGET}_docker:latest "$BASE_TAG:$VERSION"
        print_info "Successfully tagged $BASE_TAG:$VERSION"
    else
        print_warning "No version provided. Skipping tagging."
    fi
else
    print_error "Invalid or no target selected!"
    usage
fi
