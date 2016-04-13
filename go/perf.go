package main

import "time"
import "fmt"

const iterations = 1000000000

func timeTrack(start time.Time, name string) {
	elapsed := time.Since(start)
	fmt.Printf("%s took %s\n", name, elapsed)
}

func main() {
	loop_baseline()
	j := add_baseline()
	j = multiply_baseline()
	fmt.Println(j)
}

func loop_baseline() {
	defer timeTrack(time.Now(), "loop_baseline")
	for i := 0; i < iterations; i++ {
	}
	return
}

func add_baseline() int {
	defer timeTrack(time.Now(), "add_baseline")
	j := 0
	for i := 0; i < iterations; i++ {
		j += 1
	}
	return j
}

func multiply_baseline() int {
	defer timeTrack(time.Now(), "multiply_baseline")
	j := 0
	k := 17
	for i := 0; i < iterations; i++ {
		j = k * i
	}
	return j
}
