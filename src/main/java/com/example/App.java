package com.example;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class App {
    private static final Logger logger = LogManager.getLogger(App.class);
    
    public static void main(String[] args) {
        System.out.println("Hello, Allure!");
        logger.info("Application started with log4j 2.14.1");
        logger.warn("This version of log4j has known vulnerabilities!");
    }
} 