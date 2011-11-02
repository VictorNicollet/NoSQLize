(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt

type id = string

let fresh () = return (Util.fresh ())
