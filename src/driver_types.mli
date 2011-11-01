(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** Type definitions relevant to driver types. *)

(** A database identifier. A phantom string to avoid type errors. *)
type d_id = private string

(** Constructing a database identifier from a string. *)
val database_id : string -> d_id

(** A node identifier. A phantom string to avoid type errors. *)
type n_id = private string

(** Constructing a node identifier from a string. *)
val node_id : string -> n_id

(** Data types, can be used by drivers to optimize queries. *)
type datatype =
  [ `Array of datatype
  | `Option of datatype
  | `String 
  | `Boolean 
  | `Integer
  | `Number ]
