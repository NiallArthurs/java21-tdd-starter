/*
 * Copyright (c) 2025 {Project Name}
 * Licensed under the MIT License. See LICENSE file in the project root for details.
 */
package com.example.app;

import lombok.Builder;
import lombok.Value;

/**
 * Example of an immutable data class using Lombok.
 * <p>
 * Demonstrates:
 * - Immutability with @Value (all fields final, no setters)
 * - Builder pattern with @Builder
 * - Automatic equals/hashCode/toString generation
 * - Cleaner code with less boilerplate
 * </p>
 */
@Value
@Builder
public class Person {

    String firstName;
    String lastName;
    int age;

    /**
     * Returns the person's full name (first name + last name).
     *
     * @return the full name
     */
    public String getFullName() {
        return firstName + " " + lastName;
    }

    /**
     * Custom builder to add validation.
     */
    public static class PersonBuilder {
        public Person build() {
            if (firstName == null) {
                throw new NullPointerException("firstName cannot be null");
            }
            if (lastName == null) {
                throw new NullPointerException("lastName cannot be null");
            }
            if (age < 0) {
                throw new IllegalArgumentException("age cannot be negative");
            }
            return new Person(firstName, lastName, age);
        }
    }
}
