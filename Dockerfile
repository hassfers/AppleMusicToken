# Build image
FROM vapor/swift:5.2 as build
WORKDIR /build
COPY ./Package.* ./
RUN swift package resolve
COPY . .

RUN apt-get -qq update && apt-get install -y \
  libssl-dev zlib1g-dev openssl \
  && rm -r /var/lib/apt/lists/*
RUN swift build --enable-test-discovery -c release -Xswiftc -g

# Run image
FROM vapor/ubuntu:18.04
WORKDIR /run
COPY --from=build /build/.build/release /run
COPY --from=build /usr/lib/swift/ /usr/lib/swift/
COPY --from=build /build/Public /run/Public
COPY --from=build /build/Sources/App/Asserts/* /run/Sources/App/Asserts/
ENTRYPOINT ["./Run"]
CMD ["serve", "--env", "production", "--hostname", "0.0.0.0"]