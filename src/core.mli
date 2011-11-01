(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** The core API of the NoSQLize node. These functions perform simple operations 
    as standalone threads. *)

(** Return the current status of the node. *)
val status : unit -> (int * Json.t) Lwt.t


