(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** A dual associative map. Every key is bound to a value and every value is bound to 
    a key. The map can be searched through both directions. For this reason, instead
    of saying 'key' and 'value' this documentation refers to 'a' and 'b' (or 'a-key'
    and 'b-key'). *)

(** An ordered type. Both a-keys and b-keys must be ordered. *)
module type OrderedType = Map.OrderedType

(** A Dual Map module, as constructed by {!Make} *)
module type S = sig

  (** The type of the a-key *)
  type a 

  (** The type of the b-key *)
  type b

  (** The type of a dual map. *)
  type t 

  (** An empty dual map (contains no bindings) *)
  val empty : t

  (** Is a given a-b binding part of a map? *)
  val mem : t -> a -> b -> bool

  (** Find the b-key corresponding to an a-key. *)
  val find_b : t -> a -> b option

  (** Find the a-key corresponding to a b-key. *)
  val find_a : t -> b -> a option 

  (** Add a new binding to the map. Previous bindings for both a and b will
      be removed. *)
  val add : t -> a -> b -> t 

  (** Remove any binding for an a-key *)
  val remove_a : t -> a -> t
    
  (** Remove any binding for a b-key *)
  val remove_b : t -> b -> t

  (** Traverse all a-b pairs between two a-keys, both optional, in ascending order. *)
  val traverse_a : t -> a option -> a option -> (a * b) list 

  (** Traverse all a-b pairs between two b-keys, both optional, in ascending order. *)
  val traverse_b : t -> b option -> b option -> (a * b) list 

end

(** Constructs a dual map by providing the types of both a and b *)
module Make :
  functor (A:OrderedType) ->
    functor (B:OrderedType) ->
      S with type a = A.t and type b = B.t
