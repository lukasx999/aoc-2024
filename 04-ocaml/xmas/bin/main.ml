open Printf
(* open Str *)



let pattern = "XMAS"
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


let rec print_matrix (matrix : char matrix) =
    match matrix with
    | [] -> printf "\n"
    | head :: tail -> print_list head; print_matrix tail



let read_file (filename : string) : char matrix =
    let rec inner handle list =
        try
            let line = string_to_chars (input_line handle) in
            inner handle (line :: list)
        with _ ->
            close_in_noerr handle;
            list

    in List.rev (inner (open_in filename) [])




let search_string (query : string) (string : string) : int =
    let rec inner (position : int) (occurances : int) =

        if position == (String.length string)-1 then occurances else

            let r = Str.regexp query in
            try
                let index = Str.search_forward r string position in
                inner (index + (String.length query)) (occurances+1)
            with Not_found -> occurances

    in inner 0 0




let chars_to_string (chars : char list) : string =
    String.concat "" (List.map (fun c -> String.make 1 c) chars)





let traverse_matrix_left_to_right (query : string) (matrix : char matrix) : int =

    let rec inner matrix occurances = 
        match matrix with
        | [] -> occurances
        | head :: tail ->
            let count = search_string query (chars_to_string head) in
            inner tail (occurances+count)

    in inner matrix 0



let rotate_matrix_180deg (matrix : char matrix) : char matrix =
    List.map (fun row -> List.rev row) matrix



let rotate_matrix_neg90deg (matrix : char matrix) : char matrix =
    let m = rotate_matrix_180deg matrix in

    let rec inner new_matrix index =
        if index == List.length (List.nth m 0) then new_matrix else
            let rot = List.map (fun row -> List.nth row index) m in
            inner (rot :: new_matrix) (index+1)

    in List.rev (inner [] 0)





let rotate_matrix_90deg (matrix : char matrix) : char matrix =
    let rec inner new_matrix index =
        if index == List.length (List.nth matrix 0) then new_matrix else
            let rot = List.rev (List.map (fun row -> List.nth row index) matrix) in
            inner (rot :: new_matrix) (index+1)

    in List.rev (inner [] 0)







let rotate_matrix_45deg (matrix : char matrix) : char matrix =

    let new_matrix: char matrix ref = ref [] in
    let counter = ref 0 in
    let buf = ref [] in

    let n = List.length (List.nth matrix 0) in
    let m = List.length matrix in
    let larger = if n > m then n else m in

    while !counter != larger*2-1 do
        for x = 0 to n-1 do
            for y = 0 to m-1 do

                let item = List.nth (List.nth matrix y) x in
                if x + y == !counter then
                    (
                        buf := item :: !buf;
                    )
                else ();


            done;


        done;
            new_matrix := !buf :: !new_matrix;
            buf := [];
        counter := !counter + 1;


    done;

    List.rev !new_matrix





let get_occurances (query : string) (filename : string) : int =
    let matrix: char matrix = read_file filename in

    print_matrix (rotate_matrix_45deg matrix);

    let a = traverse_matrix_left_to_right query matrix in
    let b = traverse_matrix_left_to_right query (rotate_matrix_180deg matrix) in
    let c = traverse_matrix_left_to_right query (rotate_matrix_90deg matrix) in
    let d = traverse_matrix_left_to_right query (rotate_matrix_neg90deg matrix) in

    a + b + c + d





let () =
    (* printf "%d\n" (get_occurances pattern filename) *)
    ignore (get_occurances pattern filename)
