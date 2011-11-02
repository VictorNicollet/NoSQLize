(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** Store drivers describe how the data lines of a node are stored 
    and possibly persisted, as well as how they can be queried. *)

open Driver_types

(** The store driver interface. *)
module type DEFINITION = sig

  (** The identifier of an individual node store (an in-memory table, a database table
      or some other encapsulated representation of stored data). *)
  type id

  (** Returns a brand new identifier that does not match any existing node data
      and creates no risk of collision. Do not create the underlying storage
      unit yet. *)
  val fresh : unit -> id Lwt.t

  (** Set or removes a binding for the provided identifier. *)
  val put : id -> string -> Json.t option -> unit Lwt.t

  (** Gets the current binding for the provided identifier. *)
  val get : id -> string -> Json.t option Lwt.t

end

