(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** Server drivers describe how meta-information about a given server (databases, 
    stores, nodes...) is stored and manipulated. 
*)

open Driver_types

(** The server driver interface. *)
module type DEFINITION = sig

  (** The type of a database. *)
  type database 

  (** The type of a node specification in a database. *)
  type node

  (** Get a database by its name, if it exists. *)
  val get_database : d_id -> database option Lwt.t

  (** Put (create if not exists) a database by name. *)
  val put_database : d_id -> unit Lwt.t

  (** Get the names of all available databases. *)
  val all_databases : unit -> d_id list Lwt.t

  (** Delete all the information ABOUT a database. *)
  val delete_database : d_id -> unit Lwt.t

  (** Count the nodes in a database. *)
  val node_count : database -> int Lwt.t

  (** Count the databases on this server. *)
  val database_count : unit -> int Lwt.t

  (** Return all nodes in a database. *)
  val all_nodes : database -> n_id list Lwt.t

  (** Get a node from a database *)
  val get_node : database -> n_id -> node option Lwt.t

  (** Put new node metadata in the database. *)
  val put_node : database -> n_id -> node_metadata -> unit Lwt.t
    
  (** Delete the metadata of a node from the database *)
  val delete_node : database -> n_id -> unit Lwt.t

  (** The key type of the node (what index is used for accessing it) *)
  val node_metadata : node -> node_metadata Lwt.t 

end
