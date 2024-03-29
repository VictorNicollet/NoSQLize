(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt

let dispatch req outchan =

  let assoc_to_json list = 
    (* We are actually hacking around the HTTP library's inability to handle
       non-form-encoded POST data by parsing the form data as JSON fields. If
       a field is not valid JSON, it is treated as a string literal. *)
    `Object 
      (List.map 
	 (fun (key,value) -> key, try Json.json_of_string value with _ -> `String value)
	 list)
  in

  let result = 
    let uri = req # uri in
    let args = req # params_GET in
    let more = match req # meth with `GET -> `GET | `POST -> 
      let params = req # params_POST in 
      (* We are actually hacking around the HTTP library's inability to handle
	 DELETE & PUT requests by performing a POST and embedding the actual
	 method in the POST body. *)
      let meth = try Some (List.assoc "method" params) with Not_found -> None in 
      match meth with 
	| Some "DELETE" -> `DELETE 
	| Some "PUT"    -> `PUT (assoc_to_json (List.remove_assoc "method" params))
	| _             -> `POST (assoc_to_json params)
    in

    Api_parse.parse ~uri ~args ~more
  in
    
  (* Use the result to respond to the request *)
  result >>= fun (status,json) ->
  
  return 
    (Http_daemon.respond 
	~code:(`Code status)
	~body:(Json.string_of_json json)
	~headers:["Content-Type","application/json"]
	outchan)

(* All the relevant work, except for sending out the response, should happen
   in the pre-emptive Lwt worker thread. *)
let callback req outchan = 
  Kernel.throw (dispatch req) outchan

let port = 7456
  
let spec =
  Http_types.({
    Http_daemon.default_spec with
      callback ;
      mode     = `Single ;
      timeout  = None ;
      port     ;
  })
    
let _ = 
  Http_daemon.main spec  
  
