-module(enemy).
-export([start/0, loop/0, start_link/0]).


% API
start() ->  
    erlang:spawn(?MODULE, loop, []).

start_link() -> 
    spawn_link(?MODULE, loop, []).


% INTERNAL
gethand() -> 
    case trunc(rand:uniform() * 3) of
        0 -> rock;
        1 -> scissor;
        2 -> paper
    end.


%Internal
loop() ->
    receive
        {ServerPID, RefID, cancel} -> ServerPID ! {RefID, ok};  % Cancels by sending back a reponse.
        {ServerPID, RefID, _} -> ServerPID ! {RefID, gethand()}, loop()
    end.