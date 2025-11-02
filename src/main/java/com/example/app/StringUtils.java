/*
 * Copyright (c) 2025 {Project Name}
 * Licensed under the MIT License. See LICENSE file in the project root for details.
 */
package com.example.app;

import java.util.Collection;
import java.util.Locale;
import java.util.Objects;

/**
 * Utility class for common string operations.
 * <p>
 * This class cannot be instantiated and provides only static methods.
 * Demonstrates the utility class pattern with a private constructor.
 * </p>
 */
public final class StringUtils {

    private StringUtils() {
        throw new AssertionError("Utility class should not be instantiated");
    }

    /**
     * Checks if a string is null or empty.
     *
     * @param str the string to check
     * @return true if the string is null or empty
     */
    public static boolean isEmpty(final String str) {
        return str == null || str.isEmpty();
    }

    /**
     * Checks if a string is not null and not empty.
     *
     * @param str the string to check
     * @return true if the string is not null and not empty
     */
    public static boolean isNotEmpty(final String str) {
        return !isEmpty(str);
    }

    /**
     * Joins a collection of strings with a delimiter.
     *
     * @param strings the strings to join
     * @param delimiter the delimiter
     * @return the joined string
     */
    public static String join(final Collection<String> strings, final String delimiter) {
        Objects.requireNonNull(strings, "strings cannot be null");
        Objects.requireNonNull(delimiter, "delimiter cannot be null");
        return String.join(delimiter, strings);
    }

    /**
     * Capitalizes the first letter of a string.
     *
     * @param str the string to capitalize
     * @return the capitalized string, or null if input is null
     */
    public static String capitalize(final String str) {
        if (isEmpty(str)) {
            return str;
        }
        return str.substring(0, 1).toUpperCase(Locale.ROOT) + str.substring(1);
    }
}
