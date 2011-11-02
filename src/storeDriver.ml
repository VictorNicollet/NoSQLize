(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open StoreDriver_common
  
module InMemory = Register(StoreDriver_inMemory)
  
type id = [ `InMemory of StoreDriver_inMemory.id ]
    
let get = function
  | `InMemory id -> InMemory.driver id
