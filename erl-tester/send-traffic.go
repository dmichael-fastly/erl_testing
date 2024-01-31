package main

import (
	"bytes"
	"encoding/csv"
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"
	"time"
)

type Counter struct {
	X int
}

// Panic if there is an error
func check(err error) {
	if err != nil {
		panic(err)
	}
}

func send_post() int {
	// HTTP endpoint
	posturl := "https://dmichael-erl-testing.global.ssl.fastly.net/v1/auth/token/external/loginSOMETHINGGOLANG"

	// JSON body
	body := []byte(`{
		"username": "drew",
		"password": "test"
	}`)

	// Create a HTTP post request
	r, err := http.NewRequest("POST", posturl, bytes.NewBuffer(body))
	if err != nil {
		panic(err)
	}

	r.Header.Add("Content-Type", "application/json")

	client := &http.Client{}
	res, err := client.Do(r)
	if err != nil {
		panic(err)
	}

	defer res.Body.Close()

	return res.StatusCode
}

func send_request(current_second int, request_id int, open_requests *Counter, delayed_requests *Counter, finished_requests *Counter) {
	open_requests.X++
	status_code := send_post()
	for status_code == 429 {
		open_requests.X--
		delayed_requests.X++
		// Wait 1 second and then try again
		time.Sleep(1 * time.Second)
		delayed_requests.X--
		open_requests.X++
		status_code = send_post()
	}
	finished_requests.X++
}

func send_requests(current_second int, requests_to_send int, open_requests *Counter, delayed_requests *Counter, finished_requests *Counter) {
	for request_id := 0; request_id <= requests_to_send; request_id++ {
		go send_request(current_second, request_id, open_requests, delayed_requests, finished_requests)
	}
}

func main() {
	// open file
	f, err := os.Open("data/requests.csv")
	if err != nil {
		log.Fatal(err)
	}

	// remember to close the file at the end of the program
	defer f.Close()

	// read csv values using csv.Reader
	csvReader := csv.NewReader(f)
	data, err := csvReader.ReadAll()
	if err != nil {
		log.Fatal(err)
	}

	var requests_by_second []int
	for _, record := range data {
		requests_in_this_second, _ := strconv.Atoi(record[0])
		requests_by_second = append(requests_by_second, requests_in_this_second)
	}

	open_requests := &Counter{0}
	delayed_requests := &Counter{0}
	finished_requests := &Counter{0}
	current_second := 0
	for range time.Tick(time.Second * 1) {
		fmt.Println("On second", current_second, ": opening", requests_by_second[current_second], " requests,", open_requests.X, "currently open,", delayed_requests.X, "currently delayed", finished_requests.X, "finsished")
		go send_requests(current_second, requests_by_second[current_second], open_requests, delayed_requests, finished_requests)
		current_second++
	}
}
