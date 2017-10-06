module type S = sig
  val name: string
  val generate: Query.t list -> unit Lwt.t
end

let l: (module S) list = [
  (module Backend_c);
  (module Backend_debug);
  (module Backend_ocaml);
]


let to_pair (module B: S) =
  B.name, B.generate
