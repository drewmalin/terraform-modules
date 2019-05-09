## 
# Step 1: container setup
##
FROM alpine:latest as setup

# Install root certs to allow egress TLS traffic
RUN apk --update add ca-certificates

# Create a user to use when executing the app
RUN adduser -D -g '' appuser

##
# Step 2: app setup
##
FROM scratch

ARG port
ARG bin

COPY --from=setup /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=setup /etc/passwd /etc/passwd
USER appuser

COPY bin/$bin /bin/app

EXPOSE $port
ENTRYPOINT ["/bin/app"]
