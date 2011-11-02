(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** Store drivers describe how the data lines of a node are stored 
    and possibly persisted, as well as how they can be queried. *)

open Driver_types

(** The identifier of a node store *)
type id = [ `InMemory of StoreDriver_inMemory.id ]

(** A polymorphic (late-binding) representation of an individual store *)    
class type driver = object
  method get : string -> Json.t option Lwt.t
  method put : string -> Json.t option -> unit Lwt.t
  method changes : c_id option -> (c_id * string) list Lwt.t
end

(** Get a fresh identifier in a given domain *)
val fresh : store_type -> id Lwt.t

(** Get a driver using an identifier. *)
val get : id -> driver
