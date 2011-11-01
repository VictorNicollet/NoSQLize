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

(** Raw data types *)
type datatype_raw = 
    [ `String
    | `Boolean
    | `Integer
    | `Number ]

(** Optional raw data types *)
type datatype_optraw = 
    [ `Option of datatype_raw
    | datatype_raw ]

(** Data types, can be used by drivers to optimize queries. *)
type datatype =
  [ `Array of datatype
  | `Option of datatype
  | datatype_raw ]

(** Metadata about a node in a database on a server. *)
type node_metadata = 
    {
      node_key_type : datatype_optraw list 
    }
