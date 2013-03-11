ERL_RUN_ARGS:=-pa ebin -config elog -boot start_sasl -s dp_push_app main

compile: get-deps
	rebar compile

get-deps:
	rebar get-deps

clean:
	rebar clean
	rm -f erl_crash.dump

test:	compile
	rebar eunit skip_deps=true

run:
	ERL_LIBS=deps erl $(ERL_RUN_ARGS)

background:
	ERL_LIBS=deps erl -detached $(ERL_RUN_ARGS)

dialyzer:
	dialyzer --src -I include src

dialyzer_beam:
	dialyzer ebin
