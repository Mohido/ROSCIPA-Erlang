-module(game).
-compile(export_all).


% API
start() ->  
    erlang:spawn(?MODULE, init, []).

start_link() -> 
    spawn_link(?MODULE, init, []).

init() -> 
    EnemyPid = enemy:start_link(),
    loop(EnemyPid, 0).

 
calculate(Player, Gesture) -> 
    io:format("Enemy Replied with: ~p~n", [Gesture]),
    if
        (Gesture == rock) andalso (Player == 0) -> 0;
        (Gesture == rock) andalso (Player == 1) -> -1;
        (Gesture == rock) andalso (Player == 2) -> 1;
        (Gesture == scissor) andalso (Player == 1) -> 0;
        (Gesture == scissor) andalso (Player == 0) -> 1;
        (Gesture == scissor) andalso (Player == 2) -> -1;
        (Gesture == paper) andalso (Player == 2) -> 0;
        (Gesture == paper) andalso (Player == 1) -> 1;
        (Gesture == paper) andalso (Player == 0) -> -1
    end.

%Internal
loop(EnemyPid, Wins) ->
    % Initialize Enemy
    io:format("Wins: ~p~n", [Wins]),
    {ok, Term} = io:read("Enter a number: 0 for rock, 1 for scissor, 2 for paper: "),
    Ref = make_ref(),
    EnemyPid ! {self(), Ref, play},
    receive
        {_, Gesture} -> loop(EnemyPid, Wins + calculate(Term, Gesture))
    end.