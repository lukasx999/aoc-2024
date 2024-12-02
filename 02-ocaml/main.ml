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



let callback line =
    let l = string_to_list line in
    ignore (List.iter (fun x -> printf "%d " x) l);
    printf "\n"



let () =
    ignore (iter_line_by_line "example.txt" callback);
