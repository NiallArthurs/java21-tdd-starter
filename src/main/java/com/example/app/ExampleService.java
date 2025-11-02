/*
 * Copyright (c) 2025 {Project Name}
 * Licensed under the MIT License. See LICENSE file in the project root for details.
 */
package com.example.app;

import java.util.Locale;

import lombok.extern.slf4j.Slf4j;

/**
 * Example service demonstrating SLF4J logging with Lombok.
 * <p>
 * The {@code @Slf4j} annotation automatically generates a logger field:
 * {@code private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(ExampleService.class);}
 * </p>
 * <p>
 * Best Practice: Use key=value format for structured logging, which is more searchable
 * in modern log viewers and SIEM tools.
 * </p>
 */
@Slf4j
public class ExampleService {

    /**
     * Demonstrates various log levels with structured key=value format.
     *
     * @param input the input value to process
     * @return the processed result
     */
    public String processData(final String input) {
        log.trace("method=processData input={}", input);
        log.debug("processing_started input={}", input);

        if (input == null || input.isBlank()) {
            log.warn("invalid_input input=null_or_blank");
            return "";
        }

        try {
            final String result = input.toUpperCase(Locale.ROOT);
            log.info("processing_success inputLength={} outputLength={}", input.length(), result.length());
            return result;
        } catch (Exception e) {
            log.error("processing_failed input={} error={}", input, e.getMessage(), e);
            throw new ApplicationException("Failed to process data", e);
        }
    }

    /**
     * Demonstrates parameterized logging with structured key=value format (efficient - no string concatenation).
     *
     * @param userId the user ID
     * @param action the action performed
     */
    public void logUserAction(final long userId, final String action) {
        // Good: Uses structured key=value logging (searchable and efficient)
        log.info("user_action userId={} action={}", userId, action);

        // Bad: String concatenation (avoid this - not searchable, inefficient)
        // log.info("User " + userId + " performed action: " + action);

        // Bad: Colon format (less searchable in modern log viewers)
        // log.info("User: {} performed action: {}", userId, action);
    }

    /**
     * Demonstrates conditional logging for expensive operations.
     *
     * @param data complex data object
     */
    public void logComplexData(final Object data) {
        // Only compute expensive toString() if DEBUG is enabled
        if (log.isDebugEnabled()) {
            log.debug("complex_data data={}", data.toString());
        }
    }
}
