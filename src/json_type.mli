(* NoSQLIze - a public domain NoSQL storage and computation engine. *)

(** OCaml representation of JSON data. *)
type t =
  [ `Null
  | `Array of t list
  | `Object of (string * t) list
  | `Float of float
  | `Int of int
  | `Bool of bool
  | `String of string
  ]


exception Json_error of string
