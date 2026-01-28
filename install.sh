#!/bin/bash
set -e

# Install dependencies
apt-get update
apt-get install -y curl gnupg lsb-release

# Add ROS2 GPG key
curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

# Add ROS2 apt repository (Jazzy for Ubuntu Noble 24.04)
echo "deb http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2.list

# Install ROS2 Jazzy Desktop (includes RViz2, rqt, demo nodes, GUI tools)
apt-get update
apt-get install -y ros-jazzy-desktop

# Clean up apt cache
rm -rf /var/lib/apt/lists/*

# Extract and write app version
APP_VERSION=$(dpkg -s ros-jazzy-desktop | grep -i "^Version:" | awk '{print $2}')
echo "$APP_VERSION" > /app/app_version.txt

# Create run script for RViz2
echo '#!/bin/bash
sleep 2
source /opt/ros/jazzy/setup.bash
rviz2
' > /app/scripts/run-ros2-rviz.sh
chmod +x /app/scripts/run-ros2-rviz.sh

# Create run script for rqt
echo '#!/bin/bash
sleep 2
source /opt/ros/jazzy/setup.bash
rqt
' > /app/scripts/run-ros2-rqt.sh
chmod +x /app/scripts/run-ros2-rqt.sh

# Create multi-VNC sessions manifest
# Display :0 remains the primary desktop (handled by core)
# Display :1 → RViz2, Display :2 → rqt
cat > /app/sessions.json <<'EOF'
[
  {
    "name": "rviz2",
    "command": "bash /app/scripts/run-ros2-rviz.sh",
    "display": 1
  },
  {
    "name": "rqt",
    "command": "bash /app/scripts/run-ros2-rqt.sh",
    "display": 2
  }
]
EOF
