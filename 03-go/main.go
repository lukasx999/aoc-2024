package main

import (
    "fmt"
    _ "io"
    "os"
    "unicode"
)

func read_file(name string) string{
    data, err := os.ReadFile(name)
    if err != nil { panic (err) }
    return string(data)
}


type MulResult struct {
    a, b int
}


func parse(input string) []MulResult {

    results := []MulResult{}



    for position := 0; position < len(input); position++ {

        var c rune = rune(input[position])
        result := new(MulResult);

        fmt.Println(c)
        fmt.Println(result)

        switch c {
        case '(':
        case ')':
        case ',':
        default:

            // max. 3 digits!
            skip := 0
            for i := position+1; i < len(input); i++ {
                if !unicode.IsDigit(rune(input[i])) {
                    skip = position - i -1
                }
            }
            position += skip



            skip = 0
            for i := position+1; i < len(input); i++ {
                if !unicode.IsLetter(rune(input[i])) {
                    skip = position - i -1
                }
            }
            position += skip

        }




    }

    return results

}



func main() {

    file := read_file("example.txt")
    fmt.Println(file)
    parse(file)

}
