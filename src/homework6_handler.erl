-module(homework6_handler).
-import(my_cache, [create/1, insert/3, insert/4, lookup/2, delete_obsolete/1]).

-behavior(homework6).

-export([init/0]).
-export([handle_call/2]).
-export([handle_cast/2]).

%cleanup() ->
%    timer:sleep(60000),
%    delete_obsolete(table).

init() ->
    my_cache:create(table),
%    handle_cleanup().
%    spawn(?MODULE, handle_cleanup, []).
%,
    {ok, undefined}.

handle_call(ping, State) ->
    ok = io:format("~p received ping~n", [self()]),
    Result = pong,
    {ok, Result, State};
handle_call({insert, Key, Value}, State) ->
    ok = io:format("~p received insert: ~p with ~p~n", [self(), Key, Value]),
    Result = my_cache:insert(table, Key, Value),
    {ok, Result, State};
handle_call({insert, Key, Value, Expire}, State) ->
    ok = io:format("~p received insert: ~p with ~p, expire ~p~n", [self(), Key, Value, Expire]),
    Result = my_cache:insert(table, Key, Value, Expire),
    {ok, Result, State};
handle_call({lookup, Key}, State) ->
    ok = io:format("~p received lookup: ~p~n", [self(), Key]),
    Result = my_cache:lookup(table, Key),
    {ok, Result, State};
handle_call(_, State) ->
    ok = io:format("~p received wrong_message~n", [self()]),
    {ok, wrong_message, State}.


handle_cast(_Msg, State) ->
    {ok, State}.
