(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** A synchronized container for an immutable value, useful to serialize updates to 
    that value. *)

(** A synchronized container. *)
type 'a t

(** An alias for the container type. *)
type 'a lock = 'a t

(** Create a container with an initial value. *)
val create : 'a -> 'a t

(** Get the container value. This always works. *)
val get : 'a t -> 'a 

(** Lock and update the container. The current value is provided as input to avoid
    race conditions. *)
val transaction : ('a -> 'a Lwt.t) -> 'a t -> unit Lwt.t

(** Update the container by performing a non-interruptable information. IMPORTANT: in
    order to avoid race conditions, if the new value depends in any way on the old value,
    then that dependency must be computed freshly based on the provided value. That is,
    [let x = get t + 1 in update (fun _ -> x) t] is incorrect, but
    [update (fun x -> x + 1) t] is correct. *)
val update : ('a -> 'a) -> 'a t -> unit 

(** A map module based on the standard map module, but adapted so that mutator functions
    update a synchronized value instead of returning a new map. *)
module MapLock : functor (M:Map.S) -> sig

  (** The type of a key on this map. *)
  type key = M.key

  (** The type of a map in a locked container. *)
  type 'a t = 'a M.t lock

  (** Create an empty map *)
  val create : unit -> 'a t 

  (** Add a key/value pair. *)
  val add : 'a t -> key -> 'a -> unit 

  (** Remove a key/value pair. *)
  val remove : 'a t -> key -> unit 

  (** Set a key-value pair, or remove the pair, depending on whether a value was provided
      or not. *)
  val set : 'a t -> key -> 'a option -> unit

  (** Get a value from the map. *)
  val get : 'a t -> key -> 'a option
    
  (** This is a hack to use the string syntax sugar. *)
  module Sugar : sig
    module String : sig
      val get : 'a t -> key -> 'a option
      val set : 'a t -> key -> 'a option -> unit
    end
  end

end
