(*pp camlp4o `ocamlfind query -i-format lwt.syntax` pa_lwt.cmo *)

open Lwt
open Lwt_io
open Printf
open Value
open Parser_json

let parse_file fname =
  Lens_unix.with_file fname
    (fun env ->
      let s = Lens.char_stream env in
      lwt v = Parser_json.of_stream s in
      printf "%s: %s\n%!" fname (Value.to_string v);
      return ()
    )
let _ =
  let f = [ "basic.json"; "list.json"; "broken1.json" ] in
  
  Lwt_main.run (
    Lwt_util.iter parse_file f)
