open Printf
(* open Str *)



let pattern = "XMAS"
let filename = "example.txt"
(* let filename = "input.txt" *)


type 'a matrix = 'a list list


let string_to_chars (string : string) : char list =
    let rec inner string list =
        match string with
        | "" -> List.rev list
        | _ -> 
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
                    buf := item :: !buf;

            done;
        done;
        new_matrix := (List.rev !buf) :: !new_matrix;
        buf := [];
        counter := !counter + 1;

    done;

    List.rev !new_matrix



let get_occurances (query : string) (filename : string) : int =
    let matrix: char matrix = read_file filename in

    let a = matrix |> traverse_matrix_left_to_right query  in
    let b = matrix |> rotate_matrix_180deg   |> traverse_matrix_left_to_right query in
    let c = matrix |> rotate_matrix_90deg    |> traverse_matrix_left_to_right query in
    let d = matrix |> rotate_matrix_neg90deg |> traverse_matrix_left_to_right query in
    let e = matrix |> rotate_matrix_45deg    |> traverse_matrix_left_to_right query in
    let f = matrix |> rotate_matrix_45deg    |> rotate_matrix_180deg |> traverse_matrix_left_to_right query in
    let g = matrix |> rotate_matrix_180deg   |> rotate_matrix_45deg  |>  traverse_matrix_left_to_right query in
    let h = matrix |> rotate_matrix_180deg   |> rotate_matrix_45deg  |> rotate_matrix_180deg |> traverse_matrix_left_to_right query in

    a + b + c + d + e + f + g + h




let part_two (filename : string) : int =
    (* TODO: this *)
    let matrix: char matrix = read_file filename in
    0







let () =
    (* printf "%d\n" (get_occurances pattern filename) *)
    printf "%d\n" (part_two filename)
