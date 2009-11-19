
val to_string : Value.t -> string
val of_string : string -> Value.t

type error =
    Unexpected_char of int * char * string
  | Invalid_value of int * string * string
  | Invalid_leading_zero of int * string
  | Unterminated_value of int * string
  | Internal_error of int * string
exception Parse_error of error
