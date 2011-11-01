(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** Server drivers describe how meta-information about a given server (databases, 
    stores, nodes...) is stored and manipulated. 
*)

(** The server driver interface. *)
module type DEFINITION = sig

  (** The type of a database. *)
  type database 

  (** Get a database by its name, if it exists. *)
  val get_database : string -> database option Lwt.t

  (** Put (create if not exists) a database by name. *)
  val put_database : string -> database Lwt.t

  (** Get the names of all available databases. *)
  val all_databases : unit -> string list Lwt.t

  (** Delete all the information ABOUT a database. *)
  val delete_database : string -> unit Lwt.t
end

(** A server driver class. Encapsulates all the details concerning a
    the underlying database driver module. *)
class type driver = object
  method database_exists : string -> bool Lwt.t
  method put_database : string -> unit Lwt.t
  method all_databases : string list Lwt.t
  method delete_database : string -> unit Lwt.t
end

(** Register a server driver. This makes it available for instantiation
    using {!get_server_driver}. *)
module Register : functor (D:DEFINITION) -> sig
  val driver : driver
end

(** All available driver types *)
type t = [ `InMemory ]
