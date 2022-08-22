# Add CAP_NET_ADMIN to the binary; required if manually installing the Tailscale *.spk file.
# This step is required every time you upgrade Tailscale.
sudo setcap cap_net_admin+eip /var/packages/Tailscale/target/bin/tailscaled

# These three commands are only needed once and persist should over restarts.
sudo mkdir -p /dev/net
sudo chmod 755 /dev/net
sudo mknod /dev/net/tun c 10 200
sudo chmod 0666 /dev/net/tun

# Persist the /dev/net/tun settings - Use this as a user defined script after restart
/var/packages/Tailscale/target/bin/tailscale configure-host

sudo synosystemctl restart pkgctl-Tailscale.service