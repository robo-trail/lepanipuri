# X11 Docker Fix
export XAUTHORITY=/tmp/.Xauthority.new
if [ ! -f "$XAUTHORITY" ]; then
    touch $XAUTHORITY
fi
if [ -n "$DISPLAY" ]; then
    DISPLAY_NUM=$(echo $DISPLAY | grep -oE '[0-9]+' | head -1)
    COOKIE=$(xauth -f /home/$(whoami)/.Xauthority.new list | grep ":${DISPLAY_NUM}" | head -1 | awk '{print $3}')
    if [ -n "$COOKIE" ]; then
        xauth add localhost:${DISPLAY_NUM}.0 MIT-MAGIC-COOKIE-1 $COOKIE 2>/dev/null
        xauth add ${HOSTNAME}:${DISPLAY_NUM}.0 MIT-MAGIC-COOKIE-1 $COOKIE 2>/dev/null
    fi
fi
