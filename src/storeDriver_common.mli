(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** Store drivers describe how the data lines of a node are stored 
    and possibly persisted, as well as how they can be queried. *)

open Driver_types

(** The store driver interface. *)
module type DEFINITION = sig
  type id
end

