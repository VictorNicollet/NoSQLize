(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt
open Driver_types
open BatPervasives

module type DEFINITION = sig
end

class type driver = object
end

module Register = functor(D:DEFINITION) -> struct
  
  let driver_impl = object
  end
    
  let driver = (driver_impl :> driver)

end

type t = [ `InMemory ]
