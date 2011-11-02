(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** The asynchronous kernel. Initializes Lwt in a separate (non-Lwt)
    thread, and provides the {!delegate} function that other (non-Lwt)
    threads can use to delegate somputations to the Lwt-running thread. 
*)

(** Delegate work to the worker thread. [delegate f x] will execute [f x] in
    the worker thread, and return the result back to the calling
    thread. *)
val delegate : ('a -> 'b Lwt.t) -> 'a -> 'b 

(** Throw work at the worker thread. [throw f x] will entirely execute [f x]
    in the worker thread, and no result will be returned. *)
val throw : ('a -> unit Lwt.t) -> 'a -> unit 

(** The number of delegated tasks currently being executed. *)
val workers : unit -> int
