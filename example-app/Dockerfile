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
COPY --from=setup /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=setup /etc/passwd /etc/passwd
USER appuser

COPY bin/example-app /bin/example-app

EXPOSE 8080
ENTRYPOINT ["/bin/example-app"]
