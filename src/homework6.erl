-module(homework6).

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([create/1, insert/3, insert/4, lookup/2]).

-define(SERVER, ?MODULE).

-import(homework6_cache, [cache_create/1, cache_insert/3, cache_insert/4, cache_lookup/2, delete_obsolete/1]).

%% API
start_link() ->
	gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%% callback
create(TableName) ->
	gen_server:call(?MODULE, {create, TableName}).

insert(TableName, Key, Value) ->
	gen_server:call(?MODULE, {insert, TableName, Key, Value}).

insert(TableName, Key, Value, Expire) ->
	gen_server:call(?MODULE, {insert, TableName, Key, Value, Expire}).

lookup(TableName, Key) ->
	gen_server:call(?MODULE, {lookup, TableName, Key}).

init([]) ->
	{ok, []}.

handle_call({create, TableName}, _From, State) ->
	Result = homework6_cache:cache_create(TableName),
	erlang:send_after(60000, self(), {cleanup, TableName}),
	{reply, Result, State};
handle_call({insert, TableName, Key, Value}, _From, State) ->
	Result = homework6_cache:cache_insert(TableName, Key, Value),
	{reply, Result, State};
handle_call({insert, TableName, Key, Value, Expire}, _From,  State) ->
	Result = homework6_cache:cache_insert(TableName, Key, Value, Expire),
	{reply, Result, State};
handle_call({lookup, TableName, Key}, _From, State) ->
	Result = homework6_cache:cache_lookup(TableName, Key),
	{reply, Result, State};
handle_call({cleanup, TableName}, _From, State) ->
	Result = homework6_cache:delete_obsolete(TableName),
	{reply, Result, State};
handle_call(_, _From, State) ->
	{reply, wrong_message, State}.

handle_cast(_Msg, State) ->
	{noreply, State}.

handle_info({cleanup, TableName}, State) ->
	homework6_cache:delete_obsolete(TableName),
	erlang:send_after(60000, self(), {cleanup, TableName}),
	{noreply, State};
handle_info(_Info, State) ->
	{noreply, State}.

terminate(_, _) ->
    {shutdown,ok}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% -record(state, {table}).
