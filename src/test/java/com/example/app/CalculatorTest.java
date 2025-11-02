package com.example.app;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import static org.assertj.core.api.Assertions.assertThat;

/**
 * Test class for Calculator, demonstrating:
 * - JUnit 5 annotations
 * - AssertJ assertions
 * - Test naming conventions
 * - Test organization
 * - Branch protection testing
 */
@DisplayName("Calculator")
class CalculatorTest {

    private final Calculator calculator = new Calculator();

    @Test
    @DisplayName("should add two positive numbers correctly")
    void shouldAddTwoPositiveNumbers() {
        // Given two positive numbers
        final int a = 2;
        final int b = 3;

        // When adding them
        final int result = calculator.add(a, b);

        // Then the result should be their sum
        assertThat(result)
            .as("2 + 3 should equal 5")
            .isEqualTo(5);
    }

    @Test
    @DisplayName("should add negative numbers correctly")
    void shouldAddNegativeNumbers() {
        assertThat(calculator.add(-5, -3)).isEqualTo(-8);
        assertThat(calculator.add(-5, 3)).isEqualTo(-2);
        assertThat(calculator.add(5, -3)).isEqualTo(2);
    }

    @Test
    @DisplayName("should add zero correctly")
    void shouldAddZeroCorrectly() {
        assertThat(calculator.add(0, 0)).isEqualTo(0);
        assertThat(calculator.add(5, 0)).isEqualTo(5);
        assertThat(calculator.add(0, 5)).isEqualTo(5);
    }

    @Test
    @DisplayName("should multiply two positive numbers correctly")
    void shouldMultiplyTwoPositiveNumbers() {
        // Given two positive numbers
        final int a = 4;
        final int b = 5;

        // When multiplying them
        final int result = calculator.multiply(a, b);

        // Then the result should be their product
        assertThat(result)
            .as("4 * 5 should equal 20")
            .isEqualTo(20);
    }

    @Test
    @DisplayName("should multiply with zero correctly")
    void shouldMultiplyWithZeroCorrectly() {
        assertThat(calculator.multiply(0, 5)).isEqualTo(0);
        assertThat(calculator.multiply(5, 0)).isEqualTo(0);
        assertThat(calculator.multiply(0, 0)).isEqualTo(0);
    }

    @Test
    @DisplayName("should multiply with one correctly")
    void shouldMultiplyWithOneCorrectly() {
        assertThat(calculator.multiply(1, 5)).isEqualTo(5);
        assertThat(calculator.multiply(5, 1)).isEqualTo(5);
    }

    @Test
    @DisplayName("should multiply negative numbers correctly")
    void shouldMultiplyNegativeNumbers() {
        assertThat(calculator.multiply(-3, 4)).isEqualTo(-12);
        assertThat(calculator.multiply(3, -4)).isEqualTo(-12);
        assertThat(calculator.multiply(-3, -4)).isEqualTo(12);
    }
}
