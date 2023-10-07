-module(homework6_cache).
-export([cache_create/1, cache_insert/3, cache_insert/4, cache_lookup/2, delete_obsolete/1]).

cache_create(TableName) ->
	ets:new(TableName, [named_table, public]),
	ok.

cache_insert(TableName, Key, Value) ->
	ets:insert(TableName, {Key, Value}),
	ok.

cache_insert(TableName, Key, Value, Expire) ->
	ExpireTime = erlang:system_time(seconds) + Expire,
	ets:insert(TableName, {Key, Value, ExpireTime}),
	ok.

cache_lookup(TableName, Key) ->
	TimeNow = erlang:system_time(seconds),
	case ets:lookup(TableName, Key) of
		[{Key, Value}] ->
			Value;
		[{Key, Value, Expire}] when Expire >= TimeNow ->
			Value;
		_ -> undefined
	end.

delete_obsolete(TableName) ->
	TimeNow = erlang:system_time(seconds),
	MatchSpec = ets:fun2ms(fun({_, _, Expire}) when Expire < TimeNow -> true end),
	ets:select_delete(TableName, MatchSpec),
	ok.
