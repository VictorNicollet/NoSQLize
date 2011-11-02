(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Driver_types

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
  val node_store : node -> StoreDriver.id Lwt.t
end

