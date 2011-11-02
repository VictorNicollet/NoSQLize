(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt
open StoreDriver_common
  
class type driver = object
end

module Register = functor(D:DEFINITION) -> struct
  
  let driver_impl id = object
  end
    
  let driver id = (driver_impl id :> driver)

  let fresh () = D.fresh ()

end

module InMemory = Register(StoreDriver_inMemory)
  
type t  = [ `InMemory ]
type id = [ `InMemory of StoreDriver_inMemory.id ]
    
let fresh = function
  | `InMemory -> InMemory.fresh () >>= fun id -> return (`InMemory id) 

let get = function
  | `InMemory id -> InMemory.driver id
