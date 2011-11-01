(* NoSQLIze - a public domain NoSQL storage and computation engine. *)

open Lwt

let get  _ _   = return (500,`Null)
let post _ _ _ = return (500,`Null) 
