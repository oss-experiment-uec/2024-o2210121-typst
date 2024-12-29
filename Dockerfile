FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx
FROM --platform=$BUILDPLATFORM rust:alpine AS build

COPY --from=xx / /

RUN apk add --no-cache clang lld git
COPY . /app
WORKDIR /app

RUN --mount=type=cache,target=/root/.cargo/git/db \
    --mount=type=cache,target=/root/.cargo/registry/cache \
    --mount=type=cache,target=/root/.cargo/registry/index \
    CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse \
    cargo fetch

ARG TARGETPLATFORM

RUN xx-apk add --no-cache musl-dev openssl-dev openssl-libs-static

ENV CARGO_BUILD_JOBS=2

RUN --mount=type=cache,target=/root/.cargo/git/db \
    --mount=type=cache,target=/root/.cargo/registry/cache \
    --mount=type=cache,target=/root/.cargo/registry/index \
    OPENSSL_NO_PKG_CONFIG=1 OPENSSL_STATIC=1 \
    OPENSSL_DIR=$(xx-info is-cross && echo /$(xx-info)/usr/ || echo /usr) \
    RUST_LOG=trace \
    xx-cargo build -p typst-cli --release --verbose

RUN cp target/$(xx-cargo --print-target-triple)/release/typst target/release/typst
RUN xx-verify target/release/typst

FROM alpine:latest
ARG CREATED
ARG REVISION
LABEL org.opencontainers.image.authors="The Typst Project Developers <hello@typst.app>"
LABEL org.opencontainers.image.created=${CREATED}
LABEL org.opencontainers.image.description="A markup-based typesetting system"
LABEL org.opencontainers.image.documentation="https://typst.app/docs"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.revision=${REVISION}
LABEL org.opencontainers.image.source="https://github.com/oss-experiment-uec/2024-o2210121-typst"
LABEL org.opencontainers.image.title="Typst Docker image"
LABEL org.opencontainers.image.url="https://typst.app"
LABEL org.opencontainers.image.vendor="Typst"

COPY --from=build /app/target/release/typst /bin

COPY . /artifact

# シェルを実行
CMD ["/bin/sh"]
