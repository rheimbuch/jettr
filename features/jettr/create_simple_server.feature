@jettr @server
Feature: Create simple server

    As a developer 
    I want to easily create a simple Jetty server
    So that I can easily deploy a simple http handler
    
    
    Scenario: Create server with no arguments
        Given "0" servers exist
        When I create a server "without" "arguments"
        Then the server should be "stopped"
        And the server should be configured to run on port "8080"
        And the server should have "0" handlers
    
    Scenario: Add a handler
        Given "0" servers exist
        When I create a server "without" "arguments"
        And I add a handler that responds with "handler running"
        Then the server should have "1" handlers
    
    Scenario: Start with a handler
        Given "0" servers exist
        When I create a server "without" "arguments"
        And I add a handler that responds with "handler running"
        And I "start" the server
        Then the server should be "running"
        And the handler should respond with "handler running" on port "8080"
    
    Scenario: Port already in use
        Given "0" servers exist
        When I create a server "without" "arguments"
        When I add a handler that responds with "handler running"
        And port "8080" is already in use
        Then "BindException" should be raised when I "start" the server
    
    Scenario: Configure port
        Given I create a server "with" ":port => 9090"
        When I add a handler that responds with "handler running"
        When I "start" the server
        Then the server should be "running"
        And the handler should respond with "handler running" on port "9090"