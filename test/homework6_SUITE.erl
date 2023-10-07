-module(homework6_SUITE).

-include_lib("common_test/include/ct.hrl").

-compile(export_all).

all() ->
	[homework6_test_create, homework6_test_insert, homework6_test_lookup].

init_per_suite(Config) ->
	ok = application:start(homework6),
	Config.

homework6_test_create(_Config) ->
	ok = homework6:create(table).

homework6_test_insert(_Config) ->
	ok = homework6:insert(table, one, "1"),
	ok = homework6:insert(table, two, "2", 2).

homework6_test_lookup(_Config) ->
	undefined = homework6:lookup(table, none),
	"1" = homework6:lookup(table, one),
	"2" = homework6:lookup(table, two),
	timer:sleep(60000),
	undefined = homework6:lookup(table, two).

end_per_suite(Config) ->
	ok = application:stop(homework6),
	Config.
