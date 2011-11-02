(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt
open Driver_types
open BatPervasives

let error status text = 
  return (status, `Object [ "error", `String text ])

let bad_error = function
  | `NoDatabase -> error 404 "No such database"
  | `NoNode     -> error 404 "No such node in this database"

let success = return (200, `Object [ "ok", `Bool true ])

let version = "0.1"

let server_driver_name = `InMemory
let server_driver = ServerDriver.get server_driver_name
 
let status () = 
  server_driver # database_count >>= fun db_count -> 
  return (200, `Object [
    "version", `String version ;
    "status" , `String "running" ;
    "workers", `Int (Kernel.workers ());
    "databases", `Int db_count
  ])

let all_databases () = 
  server_driver # all_databases >>= fun all ->
  let all = (all :> string list) in
  return (200, `Object [
    "databases", `Array (List.map (fun s -> `String s) all)
  ])

let get_database db = 
  let db = database_id db in 
  server_driver # node_count db >>= function
    | Bad what -> bad_error what 
    | Ok count -> return (200, `Object [ 
    "nodes", `Int count
    ])

let put_database db = 
  let db = database_id db in
  server_driver # put_database db >>= fun () ->
  success

let delete_database db = 
  let db = database_id db in
  server_driver # delete_database db >>= fun () ->
  success

let all_nodes db = 
  let db = database_id db in
  server_driver # all_nodes db >>= function
    | Bad what -> bad_error what
    | Ok all   -> let all = (all :> string list) in
		  return (200, `Object [
		    "nodes", `Array (List.map (fun s -> `String s) all)
		  ])

let get_node db no = 
  let db = database_id db and no = node_id no in
  server_driver # get_node db no >>= function
    | Bad what -> bad_error what 
    | Ok  meta -> return (200, `Object [])

let put_node db no json = 
  let db = database_id db and no = node_id no in
  let meta = { node_store = `InMemory } in
  server_driver # put_node db no meta >>= function
    | Bad what -> bad_error what
    | Ok  ()   -> success

let delete_node db no = 
  let db = database_id db and no = node_id no in
  server_driver # delete_node db no >>= function
    | Bad what -> bad_error what 
    | Ok  ()   -> success

let with_node_store db no f = 
  let db = database_id db and no = node_id no in
  server_driver # node_store db no >>= function
    | Bad what -> bad_error what 
    | Ok store -> f store

let get_item db no id = 
  with_node_store db no (fun store -> 
    store # get id >>= function 
      | Some json -> return (200, json)
      | None      -> return (404, `Object [ "error", `String "No such item" ]))

let put_item db no id json = 
  with_node_store db no (fun store ->
    store # put id (Some json) >>= fun () ->
    success)
    
let delete_item db no id = 
  with_node_store db no (fun store ->
    store # put id None >>= fun () ->
    success)

let node_changes db no cidopt = 
  with_node_store db no (fun store ->
    let cidopt = BatOption.map change_id cidopt in
    store # changes cidopt >>= fun list ->
    let json_lines = BatList.filter_map (fun (cid,item) -> 
      if Some cid = cidopt then None else Some (
	`Array [ `String (cid :> string) ; `String item ] 
      )
    ) list in
    return (200, `Object [
      "changes", `Array json_lines
    ]))
