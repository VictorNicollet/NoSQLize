(* NoSQLIze - a public domain NoSQL storage and computation engine. *)

open Lwt

let callback req outchan =

  (* POST parameters are treated as a JSON object. Individual fields are parsed if 
     possible, and treated as string literals otherwise. *)
  let json params =
    `Object 
      (List.map 
	 (fun (key,value) -> key, try Json.json_of_string value with _ -> `String value)
	 params)
  in 

  (* The input LWT thread, used to extract the response and send it back. *) 
  let input =
    match req # meth with 
      | `GET  -> Core.get (req # uri) (req # params_GET)
      | `POST -> Core.post (req # uri) (req # params_GET) (json (req # params_POST)) 
  in

  (* Use the result to respond to the request *)
  input >>= fun (status,json) ->

  return 
    (Http_daemon.respond 
       ~code:(`Code status)
       ~body:(Json.string_of_json json)
       ~headers:["Content-Type","application/json"]
       outchan)

let spec =
  Http_types.({
    Http_daemon.default_spec with
      callback = (fun req out -> ignore (callback req out)) ;
      timeout  = Some 10;
      port     = 7456;
  })
    
let _ = Http_daemon.main spec
  
