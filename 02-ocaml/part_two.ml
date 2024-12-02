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
    let index   = ref 0 in

    while !index < (List.length numbers)-1 do
        let item = (List.nth numbers !index) in
        let next = (List.nth numbers (!index+1)) in

        let slope: bool =
            if inc then
                (is_increasing item next)
            else
                (is_increasing next item)
        in

        if not slope then
            is_safe := false
        else ();

        index := !index + 1
    done;

    !is_safe





let remove_element (numbers: int list) (n: int) : int list =
    List.filteri (fun index x -> index != n) numbers


let rec print_list (list: int list) =
    match list with
    | [] -> printf "\n"
    | x :: xs -> printf "%d " x; print_list xs



let callback_iter_line (line: string) : bool =
    let numbers: int list = string_to_list line in
    let is_safe = ref false in

    let index = ref 0 in

    let inc = compare_items numbers true in
    let dec = compare_items numbers false in
    is_safe := inc || dec;

    let break = ref false in


    if not !is_safe then

        while !index < (List.length numbers) && not !break do

            let new_numbers = remove_element numbers !index in

            let inc = compare_items new_numbers true in
            let dec = compare_items new_numbers false in
            is_safe := inc || dec;

            if !is_safe then break := true;

            index := !index + 1;

        done

    else ();

    !is_safe







let () =
    let safe_count =
        iter_line_by_line filename callback_iter_line in
    printf "safe: %d\n" safe_count;
