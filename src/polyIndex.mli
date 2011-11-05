(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** A polymorphic index. Associates a primary identifier (the primary key of 
    a table) with a secondary index composed of one or more columns. The index
    supports fast "what identifiers are associated to this key?" queries as well
    as "set the associated key for this identifier". *)

(** The key is a list of columns that have a definite basic type. *)
type key_type = [ `String | `Int | `Number | `Bool ] list

(** An identifier (the primary key) is always a string. *)
type id  = string

(** A key, represented as a tuple of polymorphic values. These column values will be
    transformed into a concrete value of the type indicated by the column definition
    using {!JsonType} converters. *)
type key = Json.t list

(** The type of a polymorphic index. *)
type t 

(** Create a new indxx from a list of columns. *)
val empty : key_type -> t 

(** Set (or remove) the key associated with an identifier. *)
val set : t -> id -> key option -> t 

(** Get all identifiers associated with a key. If the key is shorter than the
    number of columns, the a prefix match will occur instead. If the key is 
    longer than the number of columns, no results will be returned. *)
val get : t -> key -> id list

(** The length of the list returned by {!get}. *)
val count : t -> key -> int

(** The key associated with an index. *)
val key_of : t -> id -> key option
