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

  (** Get a node from a database *)
  val get_node : database -> n_id -> node option Lwt.t

  (** Put new node metadata in the database. *)
  val put_node : database -> n_id -> node_metadata -> unit Lwt.t
    
  (** Delete the metadata of a node from the database *)
  val delete_node : database -> n_id -> unit Lwt.t

  (** The key type of the node (what index is used for accessing it) *)
  val node_metadata : node -> node_metadata Lwt.t 

end

(** A server driver class. Encapsulates all the details concerning a
    the underlying database driver module. *)
class type driver = object
  method node_count : d_id -> (int,[`NoDatabase]) BatStd.result Lwt.t
  method put_database : d_id -> unit Lwt.t
  method all_databases : d_id list Lwt.t
  method delete_database : d_id -> unit Lwt.t
  method database_count : int Lwt.t
  method delete_node : d_id -> n_id -> (unit,[`NoDatabase]) BatStd.result Lwt.t 
  method get_node : d_id -> n_id -> (node_metadata,[`NoDatabase|`NoNode]) BatStd.result Lwt.t
  method put_node : d_id -> n_id -> node_metadata -> (unit,[`NoDatabase]) BatStd.result Lwt.t 
end

(** Register a server driver. This makes it available for instantiation
    using {!get_server_driver}. *)
module Register : functor (D:DEFINITION) -> sig
  val driver : driver
end

(** All available driver types *)
type t = [ `InMemory ]
