(* NoSQLize - a public domain NoSQL storage and computation engine. *)

module Server = struct

  open Driver_server

  module InMemory = Register(Driver_server_inMemory)

  let get = function
    | `InMemory -> InMemory.driver

end