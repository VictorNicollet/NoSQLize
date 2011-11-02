(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** This module registers and exports all available server drivers. *)

(** Get a driver using an identifier. *)
val get : ServerDriver_common.t -> ServerDriver_common.driver
