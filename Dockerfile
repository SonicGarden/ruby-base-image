ARG RUBY_VERSION=3.2.2
FROM public.ecr.aws/docker/library/ruby:$RUBY_VERSION-slim

# Update gems and bundler
RUN RUBY_YJIT_ENABLE=1 gem update --system --no-document
RUN gem install -N bundler
    

# Install packages needed to build gems and node modules
RUN --mount=type=cache,id=dev-apt-cache,sharing=locked,target=/var/cache/apt \
    --mount=type=cache,id=dev-apt-lib,sharing=locked,target=/var/lib/apt \
    apt-get update -qq && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y curl supervisor libjemalloc2 gnupg lsb-release vim awscli
