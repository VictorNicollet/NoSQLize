(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt
open Driver_types
open BatPervasives

let error status text = 
  return (status, `Object [ "error", `String text ])

let bad_error = function
  | `NoDatabase -> error 404 "No such database"

let version = "0.1"

let server_driver_name = `InMemory
let server_driver = Driver.Server.get server_driver_name
 
let status () = 
  return (200, `Object [
    "version", `String version ;
    "status" , `String "running" ;
    "workers", `Int (Kernel.workers ())
  ])

let all_databases () = 
  server_driver # all_databases >>= fun all ->
  let all = (all :> string list) in
  return (200, `Object [
    "databases", `Array (List.map (fun s -> `String s) all)
  ])

let get_database db = 
  let db = database_id db in 
  server_driver # database_node_count db >>= function
    | Bad what -> bad_error what 
    | Ok count -> return (200, `Object [ 
    "nodes", `Int count
    ])

let put_database db = 
  let db = database_id db in
  server_driver # put_database db >>= fun () ->
  return (200, `Object [ "ok", `Bool true ])

let delete_database db = 
  let db = database_id db in
  server_driver # delete_database db >>= fun () ->
  return (200, `Object [ "ok", `Bool true ])


