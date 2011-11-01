(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt

type database = unit

let databases = Hashtbl.create 100

let name = "in-memory"

let all_databases  () = return (Hashtbl.fold (fun k _ l -> k :: l) databases [])
let put_database name = return (Hashtbl.add databases name ())
let get_database name = return (try Some (Hashtbl.find databases name) with Not_found -> None)
 
