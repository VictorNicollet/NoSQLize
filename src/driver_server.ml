(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt
open Driver_types
open BatPervasives

module type DEFINITION = sig
  type database 
  type node
  val get_database : d_id -> database option Lwt.t
  val put_database : d_id -> unit Lwt.t
  val all_databases : unit -> d_id list Lwt.t
  val delete_database : d_id -> unit Lwt.t
  val node_count : database -> int Lwt.t
  val database_count : unit -> int Lwt.t
  val all_nodes : database -> n_id list Lwt.t
  val get_node : database -> n_id -> node option Lwt.t
  val put_node : database -> n_id -> node_metadata -> unit Lwt.t
  val delete_node : database -> n_id -> unit Lwt.t
  val node_metadata : node -> node_metadata Lwt.t 
end

class type driver = object
  method node_count : d_id -> (int,[`NoDatabase]) BatStd.result Lwt.t
  method put_database : d_id -> unit Lwt.t
  method all_databases : d_id list Lwt.t
  method delete_database : d_id -> unit Lwt.t 
  method database_count : int Lwt.t
  method all_nodes : d_id -> (n_id list,[`NoDatabase]) BatStd.result Lwt.t
  method delete_node : d_id -> n_id -> (unit,[`NoDatabase]) BatStd.result Lwt.t 
  method get_node : d_id -> n_id -> (node_metadata,[`NoDatabase|`NoNode]) BatStd.result Lwt.t
  method put_node : d_id -> n_id -> node_metadata -> (unit,[`NoDatabase]) BatStd.result Lwt.t
end

(* This implements the server_driver interface based on the provided 
   driver description module, and registers it. *)
module Register = functor(D:DEFINITION) -> struct
  
  let driver_impl = object
    method node_count db = D.get_database db >>= (function 
      | None    -> return (Bad `NoDatabase)
      | Some db -> D.node_count db >>= fun count -> return (Ok count))
    method put_database    db = D.put_database db >>= (fun _ -> return ())
    method all_databases      = D.all_databases ()
    method delete_database db = D.delete_database db 
    method database_count     = D.database_count ()
    method all_nodes       db = D.get_database db >>= (function
      | None    -> return (Bad `NoDatabase)
      | Some db -> D.all_nodes db >>= fun l -> return (Ok l))
    method get_node     db no = D.get_database db >>= (function
      | None    -> return (Bad `NoDatabase)
      | Some db -> D.get_node db no >>= (function
	  | None      -> return (Bad `NoNode)
	  | Some node -> D.node_metadata node >>= fun d -> return (Ok d)))
    method put_node   db no m = D.get_database db >>= (function
      | None    -> return (Bad `NoDatabase) 
      | Some db -> D.put_node db no m >>= fun () -> return (Ok ())) 
    method delete_node  db no = D.get_database db >>= (function
      | None    -> return (Bad `NoDatabase) 
      | Some db -> D.delete_node db no >>= fun () -> return (Ok ())) 

  end
    
  let driver = (driver_impl :> driver)

end

type t = [ `InMemory ]
