# Build

FROM alpine:3.12 AS build

COPY . /usr/local/src/members-db
WORKDIR /usr/local/src/members-db
RUN apk add --no-cache --update rustup gcc musl-dev && \
    rustup-init --default-toolchain nightly -y && \
    source $HOME/.cargo/env && \
    cargo build --release


# Run

FROM alpine:3.12

WORKDIR /root
COPY database.yaml /root/database.yaml
COPY --from=build /usr/local/src/members-db/target/release/members-db /usr/local/bin/members-db
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/members-db"]
CMD ["serve"]
