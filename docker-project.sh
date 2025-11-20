#! /usr/bin/env bash
example="example2"
# docker build -t wasm-rquickjs-test .
docker run --rm -v $(pwd)/dist/:/app/dist/ -v $(pwd)/examples/:/app/examples/ wasm-rquickjs-test generate-wrapper-crate --js "examples/$example/src/$example.js" --wit "examples/$example/wit/" --output dist --include-cargo-config

docker build -t wasm-rquickjs-project -f Dockerfile.project dist
id=$(docker create wasm-rquickjs-project)

all_wasms=$(docker run --rm wasm-rquickjs-project ls -1a /target-dist/wasm32-wasip1/release/ | grep ".wasm")
for wasm in $all_wasms; do
    docker cp $id:/target-dist/wasm32-wasip1/release/$wasm ./$wasm
done

docker rm -v "$id"
