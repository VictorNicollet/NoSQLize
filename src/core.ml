(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt

let error status text = 
  return (status, `Object [ "error", `String text ])

let server_driver_name = `InMemory
let server_driver = Driver.Server.get server_driver_name
 
let status () = 
  return (200, `Object [
    "status" , `String "running" ;
    "workers", `Int (Kernel.workers ())
  ])

let all_databases () = 
  server_driver # all_databases >>= fun all -> 
  return (200, `Object [
    "databases", `Array (List.map (fun s -> `String s) all)
  ])

let get_database db = 
  server_driver # database_exists db >>= fun exists ->
  if exists then return (200, `Object [])
  else error 404 "No such database"

let put_database db = 
  server_driver # put_database db >>= fun () ->
  return (200, `Object [ "ok", `Bool true ])

let delete_database db = 
  server_driver # delete_database db >>= fun () ->
  return (200, `Object [ "ok", `Bool true ])


