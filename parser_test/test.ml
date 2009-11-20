(*pp camlp4o `ocamlfind query -i-format lwt.syntax` pa_lwt.cmo *)

open Lwt
open Lwt_io
open Printf
open Value
open Parser_json
open OUnit

let parse_file fname =
  Lens_unix.with_file fname
    (fun env ->
      let str = Lens.char_stream env in
      lwt v = Parser_json.of_stream str in
      let _ = Value.to_string v in
      return ()
    )

let rec num n a = match n with |0 -> a |x -> num (x-1) (x::a)

let test_pass n () =
  parse_file (sprintf "json_tests/pass%d.json" n)

exception Didnt_fail_when_it_should_have

let test_fail n () =
  try_lwt 
    parse_file (sprintf "json_tests/fail%d.json" n) >>
    fail Didnt_fail_when_it_should_have
  with
    Parse_error _ -> return ()

let (>::>>) a b =
  a >:: (fun () -> Lwt_main.run (b ()))

let pass_suite = List.map (fun n -> "pass" ^ (string_of_int n) >::>> test_pass n) (num 3 [])
let fail_suite = List.map (fun n -> "fail" ^ (string_of_int n) >::>> test_fail n) (num 33 [])
 
let suite = pass_suite @ fail_suite

let _ =
  run_test_tt_main ("JSON" >::: suite)

