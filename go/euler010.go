// A concurrent prime sieve
 
package main
 
import "fmt"
 
// Send the sequence 2, 3, 4, ... to channel 'ch'.
func Generate(ch chan<- int) {
        for i := 2; ; i++ {
                ch <- i // Send 'i' to channel 'ch'.
        }
}
 
// Copy the values from channel 'in' to channel 'out',
// removing those divisible by 'prime'.
func Filter(in <-chan int, out chan<- int, prime int) {
        for {
                i := <-in // Receive value from 'in'.
                if i%prime != 0 {
                        out <- i // Send 'i' to 'out'.
                }
        }
}
 
// The prime sieve: Daisy-chain Filter processes.
func main() {
        sum := 0
        ch := make(chan int) // Create a new channel.
        go Generate(ch)      // Launch Generate goroutine.
        for i := 0; i < 148933; i++ { //according to www.mathematical.com/primes1000kto2000k.html there are 148,933 primes under 2,000,000.
                prime := <-ch
                //fmt.Println(prime)
                if i%1000 == 0 { fmt.Println(i) }
                sum += prime
                ch1 := make(chan int)
                go Filter(ch, ch1, prime)
                ch = ch1
        }
        fmt.Println(sum)
}

