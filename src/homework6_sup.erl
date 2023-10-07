-module(homework6_sup).

-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	Procs = [{homework6, {homework6, start_link, []},
		permanent, 5000, worker, [homework6]}],
	{ok, {{one_for_one, 5, 10}, Procs}}.
