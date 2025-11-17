#!/bin/bash
set -e

: "${SHARED:=0}"

# Create xstartup for fluxbox
mkdir -p /root/.vnc
cat > /root/.vnc/xstartup <<'EOF'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
xrdb $HOME/.Xresources
fluxbox &
EOF
chmod +x /root/.vnc/xstartup

# -------------------------------
# Start VNC server with NO password
# -------------------------------
vncserver :0 \
  -geometry 1920x1080 \
  -depth 24 \
  -rfbport 5900 \
  -SecurityTypes None \
  --disconnectClients=0 \
  --neverShared="$(( SHARED ^ 1 ))"

# Start noVNC
NOVNC_UTILS_DIR=/usr/share/novnc/utils
NOVNC_WEB_DIR=/usr/share/novnc

if command -v novnc_proxy >/dev/null 2>&1; then
  novnc_proxy --vnc localhost:5900 --listen 6080 --web "${NOVNC_WEB_DIR}" &
elif [ -e "${NOVNC_UTILS_DIR}/novnc_proxy" ]; then
  python3 "${NOVNC_UTILS_DIR}/novnc_proxy" --vnc localhost:5900 --listen 6080 --web "${NOVNC_WEB_DIR}" &
elif [ -e "${NOVNC_UTILS_DIR}/novnc_proxy.py" ]; then
  python3 "${NOVNC_UTILS_DIR}/novnc_proxy.py" --vnc localhost:5900 --listen 6080 --web "${NOVNC_WEB_DIR}" &
elif [ -e "${NOVNC_UTILS_DIR}/websockify" ]; then
  python3 "${NOVNC_UTILS_DIR}/websockify" --web "${NOVNC_WEB_DIR}" 6080 localhost:5900 &
else
  echo "WARNING: noVNC proxy not found; skipping noVNC startup" >&2
fi

# Start Orange Canvas
QT_AUTO_SCREEN_SCALE_FACTOR=0 orange-canvas --no-splash --no-welcome &

sleep infinity
