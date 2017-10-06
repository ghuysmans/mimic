type t = {
  connection: int;
  sql: string;
}

let to_string {connection; sql} =
  Printf.sprintf "%d -> %s" connection sql

module Ints = Set.Make(struct
  type t = int
  let compare = compare
end)

let get_connections queries =
  let f (s, l) {connection; _} =
    if Ints.mem connection s then
      s, l
    else
      Ints.add connection s, connection :: l
  in
  let _, conns = List.fold_left f (Ints.empty, []) queries in
  List.rev conns
