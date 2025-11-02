/*
 * Copyright (c) 2025 {Project Name}
 * Licensed under the MIT License. See LICENSE file in the project root for details.
 */
package com.example.app;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("ExampleService")
class ExampleServiceTest {

    private ExampleService service;

    @BeforeEach
    void setUp() {
        service = new ExampleService();
    }

    @Test
    @DisplayName("should convert input to uppercase")
    void shouldConvertToUppercase() {
        // When
        final String result = service.processData("hello");

        // Then
        assertThat(result).isEqualTo("HELLO");
    }

    @Test
    @DisplayName("should return empty string for null input")
    void shouldReturnEmptyForNull() {
        // When
        final String result = service.processData(null);

        // Then
        assertThat(result).isEmpty();
    }

    @Test
    @DisplayName("should return empty string for blank input")
    void shouldReturnEmptyForBlank() {
        // When
        final String result = service.processData("   ");

        // Then
        assertThat(result).isEmpty();
    }

    @Test
    @DisplayName("should log user action without throwing exception")
    void shouldLogUserAction() {
        // This test verifies the method completes without error
        // In a real application, you might use a logging test framework
        // like logback-test or a custom appender to verify log messages

        // When/Then - should not throw
        service.logUserAction(123L, "login");
    }

    @Test
    @DisplayName("should log complex data without throwing exception")
    void shouldLogComplexData() {
        // When/Then - should not throw
        service.logComplexData(new Object());
    }
}
