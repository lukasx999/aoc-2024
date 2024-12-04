open Printf


let filename = "example.txt"


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


let rec print_list_list (list : char list list) =
    match list with
    | [] -> printf "\n"
    | head :: tail -> print_list head; print_list_list tail



let read_file (filename : string) : char list list =
    let rec inner handle list =
        try
            let line = string_to_chars (input_line handle) in
            inner handle (line :: list)
        with _ ->
            close_in_noerr handle;
            list

    in inner (open_in filename) []



let () =
    let f = read_file filename in
    print_list_list f
