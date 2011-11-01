(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt

let status () = 
  return (200, `Object [
    "status" , `String "running" ;
    "workers", `Int (Kernel.workers ())
  ])


