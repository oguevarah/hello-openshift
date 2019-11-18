package io.veicot.hello;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@RestController
public class HelloController {

    @Value( "${hello.message}" )
    private String helloMessage;

    @RequestMapping("/hello")
    public String hello() {
        return String.format(helloMessage, "World");
    }

    @RequestMapping("/hello/{name}")
    public String helloWithName(@PathVariable() String name) {
        return String.format(helloMessage, name);
    }
}