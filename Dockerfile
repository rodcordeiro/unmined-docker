FROM ubuntu:24.04

  RUN apt-get update \
      && apt-get install -y --no-install-recommends \
          ca-certificates libicu74 libssl3t64 libstdc++6 \
          zlib1g libgssapi-krb5-2 libfontconfig1 \
      && rm -rf /var/lib/apt/lists/*

  WORKDIR /opt/unmined
  COPY unmined/ ./
  RUN chmod +x ./unmined-cli

  ENTRYPOINT ["/opt/unmined/unmined-cli"]
  CMD ["--help"]