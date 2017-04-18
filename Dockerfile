FROM fedora:25
MAINTAINER jberkus@redhat.com

RUN dnf install -y tar libcurl-devel zlib-devel patch rubygem-bundler ruby-devel git make gcc gcc-c++ redhat-rpm-config && dnf clean all

# `bundle install` takes pretty long to do; let's cache it and invalidate cache only when copying sources inside
RUN mkdir /source
WORKDIR /source
COPY ./config.rb ./Gemfile ./Gemfile.lock /source/
RUN bundle install

EXPOSE 4567
ENTRYPOINT [ "bundle", "exec" ]
CMD [ "middleman", "server" ]

# this will invalidate cache a lot, hence should be last
COPY . /source
