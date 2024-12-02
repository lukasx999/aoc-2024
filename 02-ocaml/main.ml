open Printf


let filename = "example.txt"
(* let filename = "input.txt" *)


let iter_line_by_line filename callback =

    let safe_count = ref 0 in

    let file = open_in filename in
    try
        while true do
            let line = input_line file in

            if callback line then
                safe_count := !safe_count + 1
            else ()

        done
    with End_of_file -> close_in file;

    !safe_count





(* "1 2 3" -> [ 1 ; 2 ; 3 ] *)
let rec string_to_list string =
    let l = String.split_on_char ' ' string in
    List.map (fun x -> int_of_string x) l




let is_decreasing a b =
    let diff = a - b in
    diff <= 3 && diff > 0

let is_increasing a b =
    let diff = b - a in
    diff <= 3 && diff > 0



let compare_items_part_two numbers callback =

    let problem_dampened = ref false in
    let is_safe = ref true in
    let index = ref 0 in

    while !index < (List.length numbers)-1 do
        let item = (List.nth numbers !index) in
        let item_next = (List.nth numbers (!index+1)) in


        if not (callback item item_next) then
            if not !problem_dampened then
                problem_dampened := true
            else
                is_safe := false
        else ();

        index := !index + 1
    done;

    !is_safe




let compare_items_part_one numbers callback =

    let is_safe = ref true in
    let index = ref 0 in

    while !index < (List.length numbers)-1 do
        let item = (List.nth numbers !index) in
        let item_next = (List.nth numbers (!index+1)) in

        if not (callback item item_next) then
            is_safe := false
        else ();

        index := !index + 1
    done;

    !is_safe






let callback_iter_line line =
    let numbers = string_to_list line in

    (* let inc = compare_items_part_one numbers is_increasing in *)
    (* let dec = compare_items_part_one numbers is_decreasing in *)
    let inc = compare_items_part_two numbers is_increasing in
    let dec = compare_items_part_two numbers is_decreasing in

    inc || dec



let () =
    let safe_count =
        iter_line_by_line filename callback_iter_line in
    printf "safe: %d\n" safe_count;
