package com.example;

import io.qameta.allure.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

@Epic("Demo")
@Feature("Allure Integration")
public class AppTest {
    private static final Logger logger = LogManager.getLogger(AppTest.class);
    
    @Test
    @Story("Basic Test")
    @Description("Verify that the main method runs without exceptions.")
    @Severity(SeverityLevel.CRITICAL)
    void testMainRuns() {
        logger.info("Running test with vulnerable log4j dependency");
        assertDoesNotThrow(() -> App.main(new String[]{}));
        logger.warn("Test completed - log4j 2.14.1 has CVE-2021-44228 vulnerability");
    }
} 