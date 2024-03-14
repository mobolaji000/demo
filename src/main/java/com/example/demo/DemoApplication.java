package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;



@SpringBootApplication
public class DemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}
}

@RestController
class HelloController {

	@GetMapping("/hello")
	public String hello() {
		return "Hello, Spring Boot!";
	}

	@PostMapping(value = "/api/post", consumes = "application/json", produces = "application/json")
	public String handlePostRequest(@RequestBody PostRequest postRequest) {
		String message = postRequest.getMessage();
		// Process the message or perform any necessary actions
		System.out.println( "Received message: " + message);
		return "Received message: " + message;
	}
}
