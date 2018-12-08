FROM ruby:2.5
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
	nodejs \
	yarn \
	build-essential \
	libpq-dev \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

ENV RAILS_ROOT /var/www/app_name
RUN mkdir -p $RAILS_ROOT 
# Set working directory
WORKDIR $RAILS_ROOT
# Setting env up
ENV RAILS_ENV='production'
ENV RACK_ENV='production' 
ENV NODE_ENV='production'
ENV RAILS_SERVE_STATIC_FILES="true"
# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --jobs 20 --retry 5 --without development test 
# Adding project files
COPY . .
RUN bundle exec rake webpacker:compile
EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]