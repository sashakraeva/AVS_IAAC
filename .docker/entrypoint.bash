set -e

# setup ros environment
source "/opt/ros/noetic/setup.bash"
source "/hull_ws/devel/setup.bash"

exec "$@"