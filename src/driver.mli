(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** This module registers and exports all available drivers. *)

(** Server drivers. *)
module Server : sig

  (** Get a driver using an identifier. *)
  val get : [ `InMemory ] -> Driver_server.driver

end
