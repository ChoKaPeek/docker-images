This repository is intended to create/build images with CI/CD capabilities.

# Built images

## Kuzzle:

- [2.2.2 (armhf)](https://hub.docker.com/layers/chokapeek/kuzzle-armhf/2.2.2/images/sha256-ed9892be2025c7d6b50dc3d4047f9ca7db3ccd14ea1ce148ce2b8cfdb5f49b50?context=explore)

## Elasticsearch:

- [7.4.2 (armhf)](https://hub.docker.com/layers/chokapeek/elasticsearch-armhf/7.4.2/images/sha256-4b5a40be658ff5512818803008fb61e6a19a38221df480d025622a9fc0284fc4?context=explore)

## Elasticsearch, as tweaked by the Kuzzleio team:

- [7.4.2 (armhf)](https://hub.docker.com/layers/chokapeek/es-kuzzle-armhf/7.4.2/images/sha256-73ff106ba5cb5782dc4eba6f8bf0f54d0c5d2b49150a751715b69560d12b22aa?context=explore)

## Wine + Dotnet, using unbuffer as a way to simulate a TTY when needed:

I have a WPF application targetting .Net Framework 4.8 and .Net 5.0, and want
to run its tests in a pipeline. Unfortunately, I don't have a windows runner.
I ended up installing the windows version of .Net 5.0 to enjoy its compatibility
with Windows Desktop functionalities. This image is built for anyone who'd need
to run `unbuffer wine dotnet test`.

- [ubuntu 20.10 (amd64)](https://hub.docker.com/layers/chokapeek/wine-dotnet/20.10/images/sha256-1955852c230e9702d64fe4d6f4975a3999f2078fc48374b8870829530325906d?context=explore)
