(*pp camlp4o `ocamlfind query -i-format lwt.syntax` pa_lwt.cmo *)

open Lwt
open Lwt_io

let with_file fname fn =
  with_file ~mode:input fname
    (fun ic ->
      let readfn = read_into ic in
      let e = Lens.env ~sz:2048 ~readfn in
      fn e
    )

