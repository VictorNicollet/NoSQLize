(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt
open Driver_types
open BatPervasives

module type DEFINITION = sig
  type id 
end

class type driver = object
end

module Register = functor(D:DEFINITION) -> struct
  
  let driver_impl id = object
  end
    
  let driver id = (driver_impl id :> driver)

end
