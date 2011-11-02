(* NoSQLize - a public domain NoSQL storage and computation engine. *)

module Store = struct

  open Driver_store

  module InMemory = Register(Driver_store_inMemory)

  type id = [ `InMemory of Driver_store_inMemory.id ]

  let get = function
    | `InMemory id -> InMemory.driver id

end

module Server = struct

  open Driver_server

  module InMemory = Register(Driver_server_inMemory)

  let get = function
    | `InMemory -> InMemory.driver

end
