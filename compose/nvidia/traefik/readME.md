
# Configuring Traefik with Tailscale IP Address  

If you encounter issues with Traefik and Tailscale IP addresses in the future, configure Tailscale using the following command:  

### Command:  
```sh
tailscale up --snat-subnet-routes=false --accept-routes --advertise-exit-node --advertise-routes=192.168.4.0/24
```

### Explanation:  
- `--snat-subnet-routes=false` → Disables Source NAT for subnet routes, allowing direct communication.  
- `--accept-routes` → Accepts routes advertised by other nodes in the Tailscale network.  
- `--advertise-exit-node` → Advertises this device as an exit node for internet traffic.  
- `--advertise-routes=192.168.4.0/24` → Advertises the specified subnet (192.168.4.0/24) to the Tailscale network.  

### Use Case:  
This setup ensures seamless connectivity between Traefik and Tailscale by correctly routing internal traffic within the network.