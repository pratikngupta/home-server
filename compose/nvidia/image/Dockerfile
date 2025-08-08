FROM jenkins/inbound-agent:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apk update && \
    apk add --no-cache \
    go \
    python3 \
    py3-pip \
    openjdk21-jdk \
    build-base \
    curl \
    bash && \
    \
    # Clean up apk cache to reduce image size
    rm -rf /var/cache/apk/*

WORKDIR /app

CMD ["/bin/bash", "-c", "echo \"\n--- Alpine Linux Version ---\n\" && cat /etc/alpine-release && \
    echo \"\n--- Go Version ---\n\" && go version && \
    echo \"\n--- Python Version ---\n\" && python3 --version && \
    echo \"\n--- Pip Version ---\n\" && pip3 --version && \
    echo \"\n--- Java Version ---\n\" && java -version && \
    echo \"\n----------------------------------\nContainer Ready!\n----------------------------------\n\" && bash"]
