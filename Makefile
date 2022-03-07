ARGS = $(filter-out $@,$(MAKECMDGOALS))
%:
	@:

install:
	bundle install