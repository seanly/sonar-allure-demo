package com.example;

import io.qameta.allure.*;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

@Epic("Demo")
@Feature("Allure Integration")
public class AppTest {
    @Test
    @Story("Basic Test")
    @Description("Verify that the main method runs without exceptions.")
    @Severity(SeverityLevel.CRITICAL)
    void testMainRuns() {
        assertDoesNotThrow(() -> App.main(new String[]{}));
    }
} 