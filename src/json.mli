(* NoSQLIze - a public domain NoSQL storage and computation engine. *)

(** Parsing and printing JSON values. *)

(** An OCaml representation of a JSON value. *)
type t = Json_type.t

(** Parses a JSON value provided as a string. 
    @raise Json_type.Json_error
*)
val json_of_string : string -> t

(** Prints a JSON value to a string, in compact form. *)
val string_of_json : t -> string

