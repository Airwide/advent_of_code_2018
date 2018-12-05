module File = struct

  let open_in filename fn =
    let ch = open_in filename in
    try
      let res = fn ch in
      close_in ch;
      res
    with e ->
      close_in ch;
      raise e

end

module Seq = struct
  include Seq

  let of_lines ch =
    let rec next () =
      try Cons (input_line ch, next)
      with End_of_file -> Nil
    in next
end

module String = struct
  include String

  let to_chars s =
    let rec build n l =
      if n = 0 then l
      else build (n - 1) (s.[n - 1] :: l)
    in
    build (String.length s) []
  ;;

  let from_chars chars =
    String.init (List.length chars) (fun i -> List.nth chars i)

end

module List = struct
  include List

  let unique_pairs xs =
    let rec take acc = function
      | [] -> acc
      | curr :: next ->
        let acc' = next |> List.map (fun x -> curr, x) in
        take (acc' @ acc) next
    in take [] xs

  let reject f = filter (fun x -> not (f x))

end

module Map = struct
  module type S = sig
    include Map.S
    val maxf: (key -> 'a -> 'b) -> 'a t -> key * 'a
  end

  module Make (Ord: Map.OrderedType) : S with type key = Ord.t = struct
    module Map = Map.Make(Ord)
    include Map

    let maxf f m =
      fold (fun key value acc ->
        let a' = f key value in
        match acc with
        | Some (a,_) when a' <= a -> acc
        | _ -> Some (a', (key,value))
      ) m None
      |> function
        | None -> failwith "no values"
        | Some (_,max) -> max

  end
end
