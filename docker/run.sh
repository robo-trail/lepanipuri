#!/usr/bin/env bash

# Exit on error
set -e 

# Define container name map
declare -A CONTAINERS=(
    [devel]=devel_docker
    [thor]=thor_docker
    [orin]=orin_docker
)

# Container restarting flag
RESTART=false

# Container stopping flag
STOP=false

# Import script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Source colors script
source $SCRIPT_DIR/utils/print_color.sh

# Usage/help
function usage() {
    print_info ""
    print_info "Usage: ./run.sh [OPTIONS]"
    print_info ""
    print_info "Options:"
    print_info "  -t | --target agro | devel         # Target docker to run"
    print_info "  -r | --restart                   # Pass to restart existing container"
    print_info "  -s | --stop                      # Stop existing container"
    print_info "  -h | --help                      # Show this help mesage and exit"
    print_info ""
    print_info "Examples:"
    print_info "  ./run.sh --target agro                    # Run agro_docker"
    print_info "  ./run.sh --target devel                   # Run devel_docker"
    print_info ""
}

# Argument parsing
VALID_ARGS=$(getopt -o hrst: --long help,restart,stop,target: -- "$@")
eval set -- "$VALID_ARGS"

while [ : ]; do
    case "$1" in
        -t | --target)
            TARGET="$2"
            shift 2
            ;;
        -r | --restart)
            RESTART=true
            shift 1
            ;;
        -s | --stop)
            STOP=true
            shift 1
            ;;
        -h | --help)
            usage
            exit 0
            ;;
        --) shift;
            break
            ;;
        *)
            print_error "Unknown option: $1"
            usage
            exit 1
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

# Export runtime environments
#export USER_ID=$(id -u)
#export USER_GROUP=$(id -g)
#export USER_NAME=$(whoami)

# Export for compose context
export SCRIPT_DIR CONTAINER_NAME

# Sync user/group mappings
#cp /etc/group $SCRIPT_DIR/.etc_group
#cp /etc/passwd $SCRIPT_DIR/.etc_passwd
#getent group $(whoami) >> $SCRIPT_DIR/.etc_group
#getent passwd $(whoami) >> $SCRIPT_DIR/.etc_passwd

# Prepopulate known_hosts for GitHub to avoid SSH prompts
#ssh-keyscan github.com > "$HOME/.ssh/known_hosts" 
# try to append; warn on failure but continue
#if ! ssh-keyscan github.com >>"$HOME/.ssh/known_hosts" 2>/dev/null; then
#  print_warning "warning: ssh-keyscan github.com failed (offline?); continuing with existing known_hosts" >&2
#fi

# Export X11 display
xhost + local:root >/dev/null 2>&1 && print_info "X11 access granted to local root user"


# Helper: Check if a container exists
function container_exists() {
    docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"
}

# Helper: Update .Xauthority in running container
function update_xauthority() {
    if [ -f "$HOME/.Xauthority" ]; then
	echo "Copying .Xauthority file inside container as .Xauthority.new"
        docker cp $HOME/.Xauthority $CONTAINER_NAME:/home/.Xauthority.new
    fi
}

if [[ "$TARGET" == "devel" || "$TARGET" == "thor" || "$TARGET" == "orin" ]]; then
    print_info "Target selected: $TARGET"

    if [[ "$RESTART" == "true" ]]; then
    
        print_info "Restart requested for $CONTAINER_NAME"
        docker compose --profile "$TARGET" --file docker-compose.run.yml stop
	docker compose --profile "$TARGET" --file docker-compose.run.yml up -d
        print_info "Attaching to container shell..."
	update_xauthority

        docker exec -it "$CONTAINER_NAME" bash

    elif [[ "$STOP" == "true" ]]; then

        print_info "Stop requested for $CONTAINER_NAME"

        if container_exists; then
            print_info "Stopping container: $CONTAINER_NAME"
            docker compose --profile "$TARGET" --file docker-compose.run.yml stop
        fi

    else

        if container_exists; then
            print_info "Using existing container: $CONTAINER_NAME"
            #docker compose --profile "$TARGET" --file docker-compose.run.yml up -d
            docker start "$CONTAINER_NAME"
            update_xauthority

        else
            print_info "No container found, starting a new one"
            print_info "Starting container via Docker Compose..."
            docker compose --profile "$TARGET" --file docker-compose.run.yml up -d
	    update_xauthority
        fi

        print_info "Attaching to container shell..."

        docker exec -it "$CONTAINER_NAME" bash
    fi

else
    print_error "Invalid or no target selected!"
    usage
fi
