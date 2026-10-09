open Swig
open Cpp11_strongly_typed_enumerations

let _ = assert ((enum_to_int `Enum1 (C_enum `Val1)) = C_int 0)
let _ = assert ((enum_to_int `Enum1 (C_enum `Val3)) = C_int 13)
let _ = assert ((enum_to_int `Enum1 (C_enum `Val4)) = C_int 14)
let _ = assert ((enum_to_int `Enum1 (C_enum `Val6a)) = C_int 14)
let _ = assert ((int_to_enum `Enum1 13) = C_enum `Val3)

let _ = assert ((enum_to_int `Enum2 (C_enum `Val5b)) = C_int 23)
let _ = assert ((enum_to_int `Enum2 (C_enum `Val6b)) = C_int 24)

let _ = assert ((enum_to_int `PRINT_SETUP (C_enum `TO_CONSOLE)) = C_int 0)
let _ = assert ((enum_to_int `PRINT_SETUP (C_enum `TO_CSV)) = C_int 1)
