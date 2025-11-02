/*
 * Copyright (c) 2025 {Project Name}
 * Licensed under the MIT License. See LICENSE file in the project root for details.
 */
package com.example.app;

/**
 * A simple calculator class to demonstrate project structure and TDD workflow.
 * This class follows the project's style guidelines including immutability and functional approaches.
 */
public final class Calculator {

    /**
     * Adds two numbers.
     *
     * @param a first number
     * @param b second number
     * @return sum of a and b
     */
    public int add(final int a, final int b) {
        return a + b;
    }

    /**
     * Multiplies two numbers.
     *
     * @param a first number
     * @param b second number
     * @return product of a and b
     */
    public int multiply(final int a, final int b) {
        return a * b;
    }
}
