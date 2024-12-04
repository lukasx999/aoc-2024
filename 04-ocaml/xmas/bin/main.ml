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



(* (* width = 3 -> [ 1 ; 2 ; 2 ; 1 ] *) *)
(* let create_widthmap (width : int) : int list = *)
(*     let rising = List.init (width-1) (fun x -> x+1) in *)
(*     let falling = List.rev rising in *)
(*     List.append rising falling *)


(* let widthmap = [ 1 ; 2 ; 2 ; 1 ] in *)
let create_widthmap (width : int) : int list =
    let rising = List.init (width-1) (fun x -> x+1) in
    let falling = List.rev rising in
    List.append rising falling




(* 123           *)
(* 456 -> 142536 *)
let merge_columns_to_list (matrix : char matrix) : char list =
    let width = List.length (List.nth matrix 0) in
    let buf = ref [] in

    let rec inner index =
        if index == width then () else

            let for_item = fun row ->
                let x = (List.nth row index) in
                buf := x :: !buf;
            in

            ignore (List.map for_item matrix);
            inner (index+1)

    in inner 0;
    !buf



let rotate_matrix_45deg (matrix : char matrix) : char matrix =
    let cols : char list = merge_columns_to_list matrix in
    let stack = Stack.of_seq (List.to_seq cols) in

    let width = List.length (List.nth matrix 0) in
    let widthmap: int list = create_widthmap width in

    let new_matrix : char matrix ref = ref [] in
    let buf = ref [] in

    let index = ref 0 in
    while !index < List.length widthmap do

        let w = List.nth widthmap !index in

        let j = ref 0 in
        while !j < w do
            let item = Stack.pop stack in
            buf := item :: !buf;
            j := !j + 1;
        done;
        j := 0;

        new_matrix := (List.rev !buf) :: !new_matrix;
        buf        := [];
        index      := !index + 1;
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
