ARGS = $(filter-out $@,$(MAKECMDGOALS))
%:
	@:

install:
	bundle install


lint:
	bundle exec rubocop

lint-fix:
	bundle exec rubocop --auto-correct

test:
	bin/rails test $(ARGS)