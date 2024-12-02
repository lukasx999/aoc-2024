open Printf


(* let filename = "example.txt" *)
let filename = "input.txt"


let iter_line_by_line (filename: string) (callback: string -> bool) : int =

    let safe_count = ref 0 in

    let file = open_in filename in
    try
        while true do
            let line: string = input_line file in

            if callback line then
                safe_count := !safe_count + 1
            else ()

        done
    with End_of_file -> close_in file;

    !safe_count





(* "1 2 3" -> [ 1 ; 2 ; 3 ] *)
let rec string_to_list (string: string) : int list =
    let l = String.split_on_char ' ' string in
    List.map (fun x -> int_of_string x) l



let is_increasing (a: int) (b: int) : bool =
    let diff = b - a in
    diff <= 3 && diff > 0



let compare_items (numbers: int list) (inc: bool) : bool =

    let is_safe = ref true in
    let index = ref 0 in

    while !index < (List.length numbers)-1 do
        let item = (List.nth numbers !index) in
        let item_next = (List.nth numbers (!index+1)) in

        let slope: bool = if inc then
            (is_increasing item item_next)
            else
                (is_increasing item_next item)
        in

        if not slope then
            is_safe := false
        else ();

        index := !index + 1
    done;

    !is_safe



let callback_iter_line (line: string) : bool =
    let numbers = string_to_list line in

    let inc = compare_items numbers true in
    let dec = compare_items numbers false in

    inc || dec



let () =
    let safe_count =
        iter_line_by_line filename callback_iter_line in
    printf "safe: %d\n" safe_count;
