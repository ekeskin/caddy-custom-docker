# ---- Builder Stage ----
# Use the official Caddy builder image for the specified version.
# This image contains the 'xcaddy' tool needed to build Caddy with plugins.
FROM caddy:$2-builder AS builder

# Use xcaddy to build Caddy with the required custom modules.
# Standard modules are included automatically.
RUN xcaddy build \
    --with github.com/WeidiDeng/caddy-cloudflare-ip \
    --with github.com/caddy-dns/cloudflare

# ---- Final Stage ----
# Use the official standard Caddy image for the specified version.
FROM caddy:2

# Copy the custom-built Caddy binary from the builder stage
# over the standard one in the final image.
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# The final image now contains Caddy with the standard modules plus:
# - github.com/WeidiDeng/caddy-cloudflare-ip
# - github.com/caddy-dns/cloudflare
