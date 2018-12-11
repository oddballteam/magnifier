FROM ruby:2.5-slim
LABEL authors="Rob Wilkinson <rob@oddball.io>, Keifer Furzland <keifer@oddball.io>"

# Set some variables
ENV REPO_DIR /home/magnifier/src
ENV GEM_DIR /home/magnifier/gems

# Set application specific environment variables
# Eventually this can be migrated to something like: 
# ENV ENV_FILE /home/magnifier/.env
ENV PORT=3000
ENV RAILS_ENV='production'
ENV RACK_ENV='production'
ENV NODE_ENV='production'
ENV RAILS_SERVE_STATIC_FILES='true'
ENV PATH="`ruby -e 'puts Gem.user_dir'`/bin:$PATH"

# Inject RAILS_MASTER_KEY
ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY=$RAILS_MASTER_KEY

# Install curl so we can install yarn (ruby-slim doesn't have curl)
RUN apt-get update -yqq && \
    apt-get install -yqq --no-install-recommends curl gnupg2

# Install Node and Yarn
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Update local packages and install dependencies, then clean up
RUN apt-get update -yqq && \
    apt-get install -yqq --no-install-recommends \
      build-essential \
      libpq-dev \
      nodejs \
      yarn \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# We don't need documentashun
RUN echo "gem: --no-ri --no-rdoc" | tee /etc/gemrc

# Create user and group, freeze GID/UID to avoid permission issues w/ shared
# data folders mounted across multiple machines
RUN groupadd magnifier --gid 8411 && \
    useradd --home /home/magnifier --create-home --shell /bin/false --uid 8412 --gid 8411 magnifier 

# Run stuff as magnifier 
USER magnifier

# Create app folder
RUN mkdir -p $GEM_DIR $REPO_DIR $REPO_DIR/tmp

# Symlink a persisted gem folder, so we don't have to d/l again on each release
RUN ln -sn /home/magnifier/src/vendor/bundle $GEM_DIR 

# Change Working dir
RUN mkdir -p $REPO_DIR
WORKDIR $REPO_DIR

# Install gems
COPY --chown=magnifier:magnifier Gemfile Gemfile 
COPY --chown=magnifier:magnifier Gemfile.lock Gemfile.lock 
RUN bundle install --jobs 20 --retry 5 --deployment --without development test

# Install node-modules
COPY --chown=magnifier:magnifier package.json package.json 
COPY --chown=magnifier:magnifier yarn.lock yarn.lock 
RUN bundle exec yarn

# Now copy rest of app, minus what is is in .dockerignore
COPY --chown=magnifier:magnifier . .

# Compile static assets
RUN bundle exec rake webpacker:compile

# Expose service ports
EXPOSE 3000

# Provide a Healthcheck for Docker risk mitigation
HEALTHCHECK --interval=3600s \ 
  CMD curl -f http://localhost:3000 || exit 1

# Default command, running app as service
CMD ["bundle", "exec", "foreman", "start"]
