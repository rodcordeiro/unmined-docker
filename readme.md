Use o pacote **uNmINeD CLI para Linux/glibc x64**, disponível nos [downloads oficiais](https://unmined.net/downloads/). O exemplo abaixo pressupõe Docker com containers Linux e arquitetura AMD64.

Extraia o pacote nesta estrutura, deixando o executável diretamente em `unmined/`:

```text
unmined-docker/
├── Dockerfile
├── unmined/
│   ├── unmined-cli
│   └── ...demais arquivos do pacote
├── world/
│   └── ...cópia do mundo Minecraft
└── output/
```

Crie o `Dockerfile`:

```dockerfile
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
```

No PowerShell, dentro dessa pasta:

```powershell
New-Item -ItemType Directory -Force ./output | Out-Null

docker build --platform linux/amd64 -t unmined-cli:local .

# Confere se o executável inicia.
docker run --rm unmined-cli:local --help

# Gera o mapa usando uma cópia do mundo.
 docker run --rm `
     --mount "type=bind,source=$($PWD.Path)\world,target=/world,readonly" `
     --mount "type=bind,source=$($PWD.Path)\output,target=/output" `
     unmined-cli:local `
     web render `
     --world /world `
     --dimension overworld `
     --output /output `
     --imageformat png `
     --players `
     --shadows 3do `
     -c `
     -f
```

Abra `output/unmined.index.html` no navegador. Repetir o comando permite continuar uma renderização interrompida e atualizar regiões alteradas. [Documentação do CLI](https://unmined.net/docs/cli/getting-started/)

Use uma **cópia consistente do mundo**, obtida com o servidor parado ou por backup. **Este Dockerfile é uma proposta não testada aqui**; as dependências precisam ser confirmadas com o pacote baixado.