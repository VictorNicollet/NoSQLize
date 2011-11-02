(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** Store drivers describe how the data lines of a node are stored 
    and possibly persisted, as well as how they can be queried. *)

(** The types of node store drivers *)
type t  = [ `InMemory ]

(** The identifier of a node store *)
type id = [ `InMemory of StoreDriver_inMemory.id ]

(** A polymorphic (late-binding) representation of an individual store *)    
class type driver = object
  val get : string -> Json.t option Lwt.t
  val put : string -> Json.t option -> unit Lwt.t
end

(** Get a fresh identifier in a given domain *)
val fresh : t -> id Lwt.t

(** Get a driver using an identifier. *)
val get : id -> driver
