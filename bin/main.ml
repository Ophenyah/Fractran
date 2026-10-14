
type inp = int list
type fraction = int list * int list (* Num, Den*)

 type program = fraction list 
let n = 60 (* Nombre de facteurs premier *) 

let list_of_primes_60 = [
  2; 3; 5; 7; 11; 13; 17; 19; 23; 29;
  31; 37; 41; 43; 47; 53; 59; 61; 67; 71;
  73; 79; 83; 89; 97; 101; 103; 107; 109; 113;
  127; 131; 137; 139; 149; 151; 157; 163; 167; 173;
  179; 181; 191; 193; 197; 199; 211; 223; 227; 229;
  233; 239; 241; 251; 257; 263; 269; 271; 277; 281
]

let format (n : inp) = let k = List.fold_left2 
(fun acc exp base -> if exp!=0 then (acc ^ (Int.to_string base) ^ "^" ^ (Int.to_string exp) ^ " " ) else acc)
"" 
n list_of_primes_60
in if String.equal k "" then "1" else k


(* Il existe probablement une facon plus optimisée pour build la liste plutot que de modifier a chaque fois, mais comme on le fait relativement peu de fois, comparé
au nombre d'étape possible pour l'execution, ca passe *)
let rec incr_at i v = function
  | [] -> []
  | x :: tl -> if i = 0 then (x + v) :: tl else x :: incr_at (i - 1) v tl



(*On pourrait faire mieux avec des pipes, mais j'ai envie d'etre explicite s'il y a besoin de changer des choses, 
quand y'a des pipes c'est plus dur de suivre, autant etre explicite ici, surtout que le typage aide peu imo*)

(* 2^3*5^4 -> [2^3, 5^4] -> [[2,3],[5,4]]  *)
let parse_product produit = 
  let liste_produits = String.split_on_char '*' produit in
  let liste_paires = List.map (String.split_on_char '^') liste_produits in
  List.fold_left (fun acc paire ->
    match paire with 
    | [a;b] -> incr_at (
        match List.find_index (fun x -> x== (int_of_string a)) list_of_primes_60 with
        | Some a -> a
        | None -> failwith "Prime not found"
    ) (int_of_string b) acc 
    | ["1"] -> acc
    | [a] -> incr_at (
        match List.find_index (fun x -> x== (int_of_string a)) list_of_primes_60 with
        | Some a -> a
        | None -> failwith "Prime not found"
    ) (1) acc 
    | _ -> failwith "paire bizarre"
    ) (List.init n (fun _ -> 0)) (liste_paires)


let parse_fraction frac = 
  let deux_parties (*??? nom nul*) = String.split_on_char '/' frac in 
  match  deux_parties with
  | [a;b] -> (parse_product a, parse_product b )
  | _ -> failwith "Error fraction"



  (* pas tail recursif mais on va pas en mourir*)
let parse_program file = match file with
| [] -> failwith "Error file"
| h::t -> let input = parse_product h in 
  let rec parse_code f = 
    match f with 
    | [] -> []
    | hf::tf -> if String.get hf 0 == '#' then parse_code tf else  (parse_fraction hf)::(parse_code tf)
  in let p = parse_code t in (input,p)





let numerator (a : fraction) = let (x,_) = a in x
let denominator (a : fraction) = let (_,y) = a in y


let check_divisibility (nombre : inp) (test : fraction) =
  let den = denominator test in
    List.fold_left2 (fun acc f_input f_denom -> acc && (f_input >= f_denom)) true nombre den


let rec find_divisor (nombre : inp) (prog : program) = match prog with
    | [] -> None
    | h::t -> match check_divisibility nombre h with 
          | true -> Some h
          | false -> find_divisor nombre t 




let prod (nombre : inp) (prog_frac : fraction) =
  let den = denominator prog_frac in 
  let num = numerator prog_frac in 
   (* let ()  = print_endline (format nombre ^" x " ^ format num ^ "/" ^format den)  in*)
  List.map2 (fun x y -> x - y) nombre den |> List.map2 (fun x y -> x + y) num



let rec run (nombre : inp) (prog : program) =  (*simple pour l'instant  *)
  match  find_divisor nombre prog with
  | None -> nombre
  | Some div -> let new_n = prod nombre div in run new_n prog
  

let run_pair (a,b) = run a b



let read_lines filename = In_channel.with_open_text filename In_channel.input_all
                          |> String.split_on_char '\n'

(*
let () = print_endline "Hello, World!"

let () = (check_divisibility ([5;1;0;1;1]) ([],[4;1;2;0;0])) |> Bool.to_string |> print_endline 

(*let () =  format [5;1;0;1;1]  |> print_endline

let () = run ([20;31;0;0;0] ) ([([0;0;1;0;0],[1;0;0;0;0]);([0;0;1;0;0],[0;1;0;0;0])]) |> format |> print_endline
*)
let () = (parse_product "2^20*3^50") |> format |> print_endline

let () = run (parse_product "2^20*3^51") ( [parse_fraction "5/2"; parse_fraction "5^1/3^1"]  ) |> format |> print_endline


let () = run (parse_product "2^5*3^6") (List.map (fun x -> parse_fraction x) ["5*7*13/3*11";"11/13";"1/11";"3/7";"11/2";"1/3"] )|> format |> print_endline




let () = print_endline (Int.to_string (List.length (read_lines "program.fr")))

let () = "program.fr" |> read_lines |> parse_program |> run_pair |> format |>  print_endline
*)

(*Vu pendant le cours de Reprod en faisant l'exo, y'a mieux pour Args, mais c'est un interpréteur fait en une aprem, y'a pas mort d'homme*)
let () = begin match Array.length Sys.argv  with 
  | 2 -> Sys.argv.(1) |> read_lines
  | 3 -> begin
    let i = read_lines Sys.argv.(1) in
    let p = read_lines Sys.argv.(2) in i @ p  end
  | _ -> failwith "Erreur nombre d'arguments"
end
 |> parse_program |> run_pair |> format |>  print_endline

(*if Array.length Sys.argv!=2 then failwith "Erreur arguments" else Sys.argv.(1) |> read_lines |> parse_program |> run_pair |> format |>  print_endline
*)