(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open BatPervasives

type d_id = string
let database_id = identity

type n_id = string
let node_id = identity

type datatype =
  [ `Array of datatype
  | `Option of datatype
  | `String 
  | `Boolean 
  | `Integer
  | `Number ]
 
