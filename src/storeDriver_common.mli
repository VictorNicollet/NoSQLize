(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** Store drivers describe how the data lines of a node are stored 
    and possibly persisted, as well as how they can be queried. *)

open Driver_types

(** The store driver interface. *)
module type DEFINITION = sig
  type id
end

(** A stpre driver class. Encapsulates all the details concerning a
    the underlying storage driver module. *)
class type driver = object
end

(** Register a store driver. *)
module Register : functor (D:DEFINITION) -> sig
  val driver : D.id -> driver
end

