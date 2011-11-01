(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt
open Driver_types

module type DEFINITION = sig
  type database 
  val get_database : d_id -> database option Lwt.t
  val put_database : d_id -> database Lwt.t
  val all_databases : unit -> d_id list Lwt.t
  val delete_database : d_id -> unit Lwt.t
end

class type driver = object
  method database_exists : d_id -> bool Lwt.t
  method put_database : d_id -> unit Lwt.t
  method all_databases : d_id list Lwt.t
  method delete_database : d_id -> unit Lwt.t 
end

(* This implements the server_driver interface based on the provided 
   driver description module, and registers it. *)
module Register = functor(D:DEFINITION) -> struct
  
  let driver_impl = object
    method database_exists db = D.get_database db >>= (fun result -> return (result <> None))
    method put_database    db = D.put_database db >>= (fun _ -> return ())
    method all_databases      = D.all_databases ()
    method delete_database db = D.delete_database db 
  end
    
  let driver = (driver_impl :> driver)

end

type t = [ `InMemory ]
