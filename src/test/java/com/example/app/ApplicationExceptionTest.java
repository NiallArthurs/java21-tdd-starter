/*
 * Copyright (c) 2025 {Project Name}
 * Licensed under the MIT License. See LICENSE file in the project root for details.
 */
package com.example.app;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Tests for {@link ApplicationException}.
 */
class ApplicationExceptionTest {

    @Test
    void shouldCreateExceptionWithMessage() {
        final String message = "Test error message";

        final ApplicationException exception = new ApplicationException(message);

        assertThat(exception.getMessage()).isEqualTo(message);
        assertThat(exception.getCause()).isNull();
    }

    @Test
    void shouldCreateExceptionWithMessageAndCause() {
        final String message = "Test error message";
        final Throwable cause = new IllegalArgumentException("Original cause");

        final ApplicationException exception = new ApplicationException(message, cause);

        assertThat(exception.getMessage()).isEqualTo(message);
        assertThat(exception.getCause()).isEqualTo(cause);
        assertThat(exception.getCause().getMessage()).isEqualTo("Original cause");
    }

    @Test
    void shouldBeRuntimeException() {
        final ApplicationException exception = new ApplicationException("test");

        assertThat(exception).isInstanceOf(RuntimeException.class);
    }
}
