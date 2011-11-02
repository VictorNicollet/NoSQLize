(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt
open StoreDriver_common
  
class type driver = object
  method get : string -> Json.t option Lwt.t
  method put : string -> Json.t option -> unit Lwt.t
end

module Register = functor(D:DEFINITION) -> struct
  
  let driver_impl tid = object
    method put id json = D.put tid id json
    method get id      = D.get tid id 
  end
    
  let driver id = (driver_impl id :> driver)

  let fresh () = D.fresh ()

end

module InMemory = Register(StoreDriver_inMemory)
  
type id = [ `InMemory of StoreDriver_inMemory.id ]
    
let fresh = function
  | `InMemory -> InMemory.fresh () >>= fun id -> return (`InMemory id) 

let get = function
  | `InMemory id -> InMemory.driver id
