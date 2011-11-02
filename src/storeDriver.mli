(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** Store drivers describe how the data lines of a node are stored 
    and possibly persisted, as well as how they can be queried. *)

(** The identifier of a node store *)
type id = [ `InMemory of StoreDriver_inMemory.id ]

(** A polymorphic (late-binding) representation of an individual store *)    
class type driver = object
end

(** Get a driver using an identifier. *)
val get : id -> driver
