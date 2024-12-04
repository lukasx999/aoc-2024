open Printf
open Str



let filename = "example.txt"


type 'a matrix = 'a list list


let string_to_chars (string : string) : char list =
    let rec inner string list =
        match string with
        | "" -> List.rev list
        | str -> 
            let tail = String.sub string 1 ((String.length string)-1) in
            let head = (String.get string 0) :: list in
            inner tail head
    in inner string []




let rec print_list (list : char list) =
    match list with
    | [] -> printf "\n"
    | head :: tail -> printf "%c " head; print_list tail


let rec print_list_list (list : char matrix) =
    match list with
    | [] -> printf "\n"
    | head :: tail -> print_list head; print_list_list tail



let read_file (filename : string) : char matrix =
    let rec inner handle list =
        try
            let line = string_to_chars (input_line handle) in
            inner handle (line :: list)
        with _ ->
            close_in_noerr handle;
            list

    in inner (open_in filename) []




let traverse_list_left_to_right (matrix : char matrix) =

    let query = Str.regexp {| XMAS |} in
    let rec check_line (list : char list) : bool =
        (* let r = Str.rege *)
        let s = String.of_seq (List.to_seq list) in
        true
    in

    let rec inner matrix = 
    match matrix with
        | [] -> ()
    | head :: tail -> inner tail

    in inner matrix




let () =
    let f: char matrix = read_file filename in
    print_list_list f
