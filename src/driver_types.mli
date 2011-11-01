(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** Type definitions relevant to driver types. *)

(** A database identifier. A phantom string to avoid type errors. *)
type d_id = private string

(** Constructing a database identifier from a string. *)
val database_id : string -> d_id

