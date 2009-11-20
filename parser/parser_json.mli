val to_string : Value.t -> string
type error =
    Unexpected_char of int * char * string
  | Invalid_value of int * string * string
  | Invalid_leading_zero of int * string
  | Unterminated_value of int * string
  | Internal_error of int * string
exception Parse_error of error
val of_stream : char Lwt_stream.t -> Value.t Lwt.t
val of_string : string -> Value.t Lwt.t
