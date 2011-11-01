(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt
open Driver_types

(* We store all the databases in a locked database map, and the nodes inside
   are in turn stored in locked node maps. *)

module D_Id_Map = Map.Make(struct
  type t = d_id
  let compare = compare
end)

module D_Id_Table = Lock.MapLock(D_Id_Map)
 
module N_Id_Map = Map.Make(struct
  type t = n_id
  let compare = compare
end)

module N_Id_Table = Lock.MapLock(N_Id_Map)

type node = {
  metadata : node_metadata
}

type database = {
  nodes : node N_Id_Table.t 
}

let databases = D_Id_Table.create () 

(* Processing the requestes *)

let all_databases     () =
  return (D_Id_Map.fold (fun k _ l -> k :: l) (Lock.get databases) [])

let put_database    name =
  let fresh = { nodes = N_Id_Table.create () } in
  Lock.update (fun map ->
    try ignore (D_Id_Map.find name map) ; map with Not_found ->
      D_Id_Map.add name fresh map) databases ;
  return ()

let get_database    name =
  let open D_Id_Table.Sugar in
      return (databases.[name])
    
let delete_database name = 
  let open D_Id_Table.Sugar in
      return (databases.[name] <- None)
    
let node_count database = 
  return (N_Id_Map.cardinal (Lock.get database.nodes))

let database_count () = 
  return (D_Id_Map.cardinal (Lock.get databases))

let node_metadata node = 
  return (node.metadata)

let all_nodes database = 
  return (N_Id_Map.fold (fun k _ l -> k :: l) (Lock.get database.nodes) [])

let get_node database nid = 
  let open N_Id_Table.Sugar in
      return (database.nodes.[nid])

let put_node database nid metadata = 
  let fresh = { metadata } in
  let open N_Id_Table.Sugar in
      return (database.nodes.[nid] <- Some fresh)

let delete_node database nid = 
  let open N_Id_Table.Sugar in
      return (database.nodes.[nid] <- None)
