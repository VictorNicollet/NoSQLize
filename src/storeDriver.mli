(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** Store drivers describe how the data lines of a node are stored 
    and possibly persisted, as well as how they can be queried. *)

(** The identifier of a node store *)
type id = [ `InMemory of StoreDriver_inMemory.id ]
    
(** Get a driver using an identifier. *)
val get : id -> StoreDriver_common.driver
