(*pp camlp4o `ocamlfind query -i-format lwt.syntax` pa_lwt.cmo *)

open Lwt
open Lwt_io
open Printf
open Value
open Parser_json

let parse_file fname =
  let buf = Buffer.create 1024 in
  Lwt_stream.iter (fun l -> Buffer.add_string buf (l ^ "\n")) (lines_of_file fname) >>
  let s = Buffer.contents buf in
  let v = Parser_json.of_string s in
  printf "%s: %s\n%!" fname (Value.to_string v);
  return ()

let _ =
  let f = [ "basic.json" ] in
  Lwt_main.run (
    Lwt_util.iter parse_file f)
