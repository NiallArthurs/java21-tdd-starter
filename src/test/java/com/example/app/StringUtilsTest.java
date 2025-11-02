package com.example.app;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import java.util.Arrays;
import static org.assertj.core.api.Assertions.assertThat;

/**
 * Tests for {@link StringUtils}.
 */
@DisplayName("StringUtils")
class StringUtilsTest {

    @Test
    @DisplayName("should identify empty strings")
    void shouldIdentifyEmptyStrings() {
        assertThat(StringUtils.isEmpty(null)).isTrue();
        assertThat(StringUtils.isEmpty("")).isTrue();
        assertThat(StringUtils.isEmpty("test")).isFalse();
    }

    @Test
    @DisplayName("should identify non-empty strings")
    void shouldIdentifyNonEmptyStrings() {
        assertThat(StringUtils.isNotEmpty("test")).isTrue();
        assertThat(StringUtils.isNotEmpty(null)).isFalse();
        assertThat(StringUtils.isNotEmpty("")).isFalse();
    }

    @Test
    @DisplayName("should join strings with delimiter")
    void shouldJoinStringsWithDelimiter() {
        // Given a collection of strings
        final var strings = Arrays.asList("one", "two", "three");

        // When joining with comma
        final String result = StringUtils.join(strings, ", ");

        // Then should be comma-separated
        assertThat(result).isEqualTo("one, two, three");
    }

    @Test
    @DisplayName("should capitalize first letter")
    void shouldCapitalizeFirstLetter() {
        assertThat(StringUtils.capitalize("hello")).isEqualTo("Hello");
        assertThat(StringUtils.capitalize("H")).isEqualTo("H");
        assertThat(StringUtils.capitalize("")).isEqualTo("");
        assertThat(StringUtils.capitalize(null)).isNull();
    }

    @Test
    @DisplayName("should handle single character strings")
    void shouldHandleSingleCharacterStrings() {
        assertThat(StringUtils.capitalize("a")).isEqualTo("A");
        assertThat(StringUtils.isEmpty("a")).isFalse();
        assertThat(StringUtils.isNotEmpty("a")).isTrue();
    }

    @Test
    @DisplayName("should handle whitespace strings")
    void shouldHandleWhitespaceStrings() {
        assertThat(StringUtils.isEmpty(" ")).isFalse();
        assertThat(StringUtils.isNotEmpty(" ")).isTrue();
        assertThat(StringUtils.capitalize(" ")).isEqualTo(" ");
    }

    @Test
    @DisplayName("should join empty collection")
    void shouldJoinEmptyCollection() {
        assertThat(StringUtils.join(Arrays.asList(), ", ")).isEmpty();
    }

    @Test
    @DisplayName("should join single element")
    void shouldJoinSingleElement() {
        assertThat(StringUtils.join(Arrays.asList("one"), ", ")).isEqualTo("one");
    }
}
