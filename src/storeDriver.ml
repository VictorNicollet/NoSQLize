(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open StoreDriver_common
  
class type driver = object
end

module Register = functor(D:DEFINITION) -> struct
  
  let driver_impl id = object
  end
    
  let driver id = (driver_impl id :> driver)

end

module InMemory = Register(StoreDriver_inMemory)
  
type id = [ `InMemory of StoreDriver_inMemory.id ]
    
let get = function
  | `InMemory id -> InMemory.driver id
