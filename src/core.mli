(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** The core API of the NoSQLize node. These functions perform simple operations 
    as standalone threads. *)

(** Return the current status of the node. *)
val status : unit -> (int * Json.t) Lwt.t

(** Returns the list of names of all databases. *)
val all_databases : unit -> (int * Json.t) Lwt.t

(** Returns the information for one database, if it exists. *)
val get_database : string -> (int * Json.t) Lwt.t

(** Creates a database if it does not already exist. *)
val put_database : string -> (int * Json.t) Lwt.t


