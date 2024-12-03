package main

import (
    "fmt"
    "os"
    "unicode"
    "strconv"
)



const FILENAME string = "input.txt"
// const FILENAME string = "example.txt"

const INSTRUCTION_MUL  string = "mul"
const INSTRUCTION_DO   string = "do()"
const INSTRUCTION_DONT string = "don't()"



func read_file(name string) string{
    data, err := os.ReadFile(name)
    if err != nil { panic (err) }
    return string(data)
}


func match_substring(input string, position int, query string) bool {

    substring_length := len(query)

    if position + substring_length > len(input) {
        return false
    }

    slice := input[position:position+substring_length];
    return slice == query

}


func match_number(input string, position int) int {

    skip := 0
    for i := position+1; i < len(input); i++ {
        if !unicode.IsNumber(rune(input[i])) {
            skip = i - position - 1
            break
        }
    }
    return skip

}


func parse(input string) []int {

    state_repr := []string {
        "PARSER_START",
        "PARSER_MUL_KW",
        "PARSER_LPAREN",
        "PARSER_NUM1",
        "PARSER_COMMA",
        "PARSER_NUM2",
        "PARSER_RPAREN",
    }
    _ = state_repr

    const (
        PARSER_START  = iota
        PARSER_MUL_KW = iota
        PARSER_LPAREN = iota
        PARSER_NUM1   = iota
        PARSER_COMMA  = iota
        PARSER_NUM2   = iota
        PARSER_RPAREN = iota
    )

    state := PARSER_START
    var num1, num2 int = 0, 0
    mul_enabled := true

    results := []int{}

    for position := 0; position < len(input); position++ {
        c := rune(input[position])

        // fmt.Println(state_repr[state])

        switch c {

        case '(':
            if state != PARSER_MUL_KW { state = PARSER_START; continue }
            state++

        case ')':
            if state != PARSER_NUM2 { state = PARSER_START; continue }
            state++

        case ',':
            if state != PARSER_NUM1 { state = PARSER_START; continue }
            state++

        default:

            // PART TWO START

            if match_substring(input, position, INSTRUCTION_DO) {
                mul_enabled = true
                position += len(INSTRUCTION_DO)-1
            }

            if match_substring(input, position, INSTRUCTION_DONT) {
                mul_enabled = false
                position += len(INSTRUCTION_DONT)-1
            }

            // PART TWO END

            if unicode.IsNumber(c) {

                var skip int = match_number(input, position)
                slice := input[position:position+skip+1]

                number, err := strconv.Atoi(slice)
                if err != nil { panic(err) }

                position += skip

                switch state {

                case PARSER_COMMA:
                    state++
                    num2 = number

                case PARSER_LPAREN:
                    state++
                    num1 = number

                default:
                    state = PARSER_START
                    continue

                }

            } else if match_substring(input, position, INSTRUCTION_MUL) {
                    if state != PARSER_START { state = PARSER_START; continue }
                    state++
                    position += len(INSTRUCTION_MUL)-1

            } else {
                state = PARSER_START
            }

        }

        if state == PARSER_RPAREN && mul_enabled {
            results = append(results, num1 * num2)
            state = PARSER_START
        }

    }

    return results

} // ... or just use a regex






func main() {

    file := read_file(FILENAME)
    results := parse(file)

    sum := 0
    for _, element := range results {
        sum += element
    }

    fmt.Println(sum)



}
