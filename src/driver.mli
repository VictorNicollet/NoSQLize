(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** Drivers provide a generic way to access the underlying system. 
    There are three kinds of drivers: 

    Server drivers determine how server information (such as the
    list of all databases) is stored.

    Store drivers determine how an individual store will store data.

    Process drivers determine how the data will be processed by a 
    processing node. 
*)

(** The server driver interface. *)
module type SERVER_DRIVER = sig

  (** The (unique) name of the driver. Used when selecting a driver from
      several available drivers. *)
  val name : string

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
class type server_driver = object
  method name : string
  method database_exists : string -> bool Lwt.t
  method put_database : string -> unit Lwt.t
  method all_databases : string list Lwt.t
  method delete_database : string -> unit Lwt.t
end

(** Register a server driver. This makes it available for instantiation
    using {!get_server_driver}. *)
module RegisterServerDriver : functor (D:SERVER_DRIVER) -> sig
  val driver : server_driver
end

(** Get a server driver by name. Returns [None] if it does not exist. *)
val get_server_driver : string -> server_driver option
