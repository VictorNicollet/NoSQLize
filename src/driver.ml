(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt

module type SERVER_DRIVER = sig
  val name : string
  type database 
  val get_database : string -> database option Lwt.t
  val put_database : string -> database Lwt.t
  val all_databases : unit -> string list Lwt.t
end

class type server_driver = object
  method name : string
  method database_exists : string -> bool Lwt.t
  method put_database : string -> unit Lwt.t
  method all_databases : string list Lwt.t
end

(* This is the list of all available server drivers. *)
let server_drivers = Hashtbl.create 10

let get_server_driver name = 
  try Some (Hashtbl.find server_drivers name) with Not_found -> None 

(* This implements the server_driver interface based on the provided 
   driver description module, and registers it. *)
module RegisterServerDriver = functor(D:SERVER_DRIVER) -> struct
  
  let driver_impl = object
    method name = D.name
    method database_exists db = D.get_database db >>= (fun result -> return (result <> None))
    method put_database    db = D.put_database db >>= (fun _ -> return ())
    method all_databases      = D.all_databases ()
  end
    
let driver = (driver_impl :> server_driver)
  
let _ = Hashtbl.add server_drivers D.name driver

end
