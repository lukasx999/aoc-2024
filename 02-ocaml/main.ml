open Printf


let iter_line_by_line filename callback =
    let file = open_in filename in
    try
        while true do
            let line = input_line file in
            callback line;
        done
    with End_of_file -> close_in file



let rec append_to_list list string index =
    if index == String.length string then
        list
    else
        let new_list =
            match (String.get string index) with
            | ' ' -> list
            | c -> int_of_string (String.make 1 c) :: list
        in
        append_to_list new_list string (index+1)



(* "1 2 3" -> [ 1 ; 2 ; 3 ] *)
let string_to_list input_string =
    List.rev (append_to_list [] input_string 0)



let is_decreasing a b =
    let diff = a - b in
    diff <= 3 && diff > 0

let is_increasing a b =
    let diff = b - a in
    diff <= 3 && diff > 0



let callback_iter_number number =
    printf "%d " number


let callback_iter_line line =
    let numbers = string_to_list line in

    let is_safe = ref false in
    let index = ref 0 in


    while index < List.length numbers do
    let item = (List.nth numbers !index) in
    let item_next = (List.nth numbers !index+1) in
    done

    is_increasing (item item_next)




    (* ignore (List.iter callback_iter_number numbers); *)

    printf "\n"



let () =
    ignore (iter_line_by_line "example.txt" callback_iter_line);
