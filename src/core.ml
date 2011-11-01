(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt
open Driver_register

let server_driver_name = "in-memory"
let server_driver = 
  match Driver.get_server_driver server_driver_name with
    | Some driver -> driver
    | None -> assert false
 
let status () = 
  return (200, `Object [
    "status" , `String "running" ;
    "workers", `Int (Kernel.workers ())
  ])


