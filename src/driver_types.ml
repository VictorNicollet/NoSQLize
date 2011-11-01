(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open BatPervasives

type d_id = string
let database_id = identity

type n_id = string
let node_id = identity

type datatype_raw = 
    [ `String
    | `Boolean
    | `Integer
    | `Number ]

type datatype_optraw = 
    [ `Option of datatype_raw
    | datatype_raw ]

type datatype =
  [ `Array of datatype
  | `Option of datatype
  | datatype_raw ]
 
type node_metadata = 
    {
      node_key_type : datatype_optraw list 
    }
