(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** This module registers and exports all available drivers. *)

(** Store drivers. *)
module Store : sig

  (** The identifier of a node store *)
  type id = [ `InMemory of Driver_store_inMemory.id ]

  (** Get a driver using an identifier. *)
  val get : id -> Driver_store.driver

end

(** Server drivers. *)
module Server : sig

  (** Get a driver using an identifier. *)
  val get : Driver_server.t -> Driver_server.driver

end
