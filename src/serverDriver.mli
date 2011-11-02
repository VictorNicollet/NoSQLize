(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** This module registers and exports all available server drivers. *)

open Driver_types

(** A server driver class. Encapsulates all the details concerning a
    the underlying database driver module. *)
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

(** All available driver types *)
type t = [ `InMemory ]

(** Get a driver using an identifier. *)
val get : t -> driver
