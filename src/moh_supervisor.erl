-module(moh_supervisor).
-export([start/2, loop/3]).


start(Mod, Args) -> 
    loop(Mod, start_link, Args).


loop(M, F, A) -> 
    process_flag(trap_exit, true),
    Pid = apply(M, F, A), % Can't use M:F(A), but apply do the same thing.
    receive 
        {"EXIT", Pid, Reason} -> 
            io:format("Process ~p exited because of ~p~n", [Pid, Reason]),  % Default Exit Message 
            loop(M,F,A);
        {"EXIT", Pid, shutdown} -> % Kill message to supervisor
            exit(shutdown) % Will kill itself and all linked processes.
        end.
