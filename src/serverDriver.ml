(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open ServerDriver_common
  
module InMemory = Register(ServerDriver_inMemory)
  
let get = function
  | `InMemory -> InMemory.driver
   
