/*
 * Copyright (c) 2025 {Project Name}
 * Licensed under the MIT License. See LICENSE file in the project root for details.
 */
package com.example.app;

/**
 * Base exception for application-specific errors.
 * <p>
 * All custom exceptions should extend this class to maintain
 * a consistent exception hierarchy.
 * </p>
 */
public class ApplicationException extends RuntimeException {

    /**
     * Constructs a new application exception with the specified detail message.
     *
     * @param message the detail message
     */
    public ApplicationException(final String message) {
        super(message);
    }

    /**
     * Constructs a new application exception with the specified detail message and cause.
     *
     * @param message the detail message
     * @param cause the cause
     */
    public ApplicationException(final String message, final Throwable cause) {
        super(message, cause);
    }
}
