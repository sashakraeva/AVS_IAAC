set -e

# setup ros environment
source "/opt/ros/noetic/setup.zsh"
source "/hull_ws/devel/setup.zsh"

exec "$@"