(* NoSQLize - a public domain NoSQL storage and computation engine. *)

type key_type = [ `String | `Int | `Number | `Bool ] list

type id  = string
type key = Json.t list

type t 

val empty : key_type -> t 

val set : t -> id -> key option -> t 
val get : t -> key -> id list
val count : t -> key -> int
val key_of : t -> id -> key option
