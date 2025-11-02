package com.example.app;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

/**
 * Tests for {@link Person} demonstrating builder pattern validation.
 */
@DisplayName("Person")
class PersonTest {

    @Test
    @DisplayName("should build person with valid data")
    void shouldBuildPersonWithValidData() {
        // When building a person
        final Person person = Person.builder()
            .firstName("John")
            .lastName("Doe")
            .age(30)
            .build();

        // Then person should have correct values
        assertThat(person.getFirstName()).isEqualTo("John");
        assertThat(person.getLastName()).isEqualTo("Doe");
        assertThat(person.getAge()).isEqualTo(30);
        assertThat(person.getFullName()).isEqualTo("John Doe");
    }

    @Test
    @DisplayName("should throw exception when firstName is null")
    void shouldThrowExceptionWhenFirstNameIsNull() {
        // When building with null firstName, Then should throw NullPointerException
        assertThatThrownBy(() -> Person.builder().lastName("Doe").age(30).build())
            .isInstanceOf(NullPointerException.class)
            .hasMessageContaining("firstName");
    }

    @Test
    @DisplayName("should throw exception when age is negative")
    void shouldThrowExceptionWhenAgeIsNegative() {
        // When building with negative age, Then should throw IllegalArgumentException
        assertThatThrownBy(() -> Person.builder().firstName("John").lastName("Doe").age(-1).build())
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessageContaining("age cannot be negative");
    }

    @Test
    @DisplayName("should have proper equals and hashCode")
    void shouldHaveProperEqualsAndHashCode() {
        // Given two persons with same data
        final Person person1 = Person.builder()
            .firstName("John")
            .lastName("Doe")
            .age(30)
            .build();

        final Person person2 = Person.builder()
            .firstName("John")
            .lastName("Doe")
            .age(30)
            .build();

        // Then they should be equal with same hashCode
        assertThat(person1).isEqualTo(person2);
        assertThat(person1.hashCode()).isEqualTo(person2.hashCode());
    }

    @Test
    @DisplayName("should not equal different person")
    void shouldNotEqualDifferentPerson() {
        final Person person1 = Person.builder()
            .firstName("John")
            .lastName("Doe")
            .age(30)
            .build();

        final Person person2 = Person.builder()
            .firstName("Jane")
            .lastName("Doe")
            .age(30)
            .build();

        assertThat(person1).isNotEqualTo(person2);
    }

    @Test
    @DisplayName("should handle equals edge cases")
    void shouldHandleEqualsEdgeCases() {
        final Person person = Person.builder()
            .firstName("John")
            .lastName("Doe")
            .age(30)
            .build();

        // Test reflexivity (equals with itself) - create a copy
        final Person samePerson = Person.builder()
            .firstName("John")
            .lastName("Doe")
            .age(30)
            .build();

        assertThat(person).isEqualTo(samePerson);
        assertThat(person).isNotEqualTo(null);
        assertThat(person).isNotEqualTo("not a person");
    }

    @Test
    @DisplayName("should allow zero age")
    void shouldAllowZeroAge() {
        final Person baby = Person.builder()
            .firstName("Baby")
            .lastName("Doe")
            .age(0)
            .build();

        assertThat(baby.getAge()).isEqualTo(0);
    }

    @Test
    @DisplayName("should throw exception when lastName is null")
    void shouldThrowExceptionWhenLastNameIsNull() {
        assertThatThrownBy(() -> Person.builder().firstName("John").age(30).build())
            .isInstanceOf(NullPointerException.class)
            .hasMessageContaining("lastName");
    }

    @Test
    @DisplayName("should have proper toString")
    void shouldHaveProperToString() {
        final Person person = Person.builder()
            .firstName("John")
            .lastName("Doe")
            .age(30)
            .build();

        assertThat(person.toString())
            .contains("John")
            .contains("Doe")
            .contains("30");
    }

    @Test
    @DisplayName("should have different hashCode for different persons")
    void shouldHaveDifferentHashCodeForDifferentPersons() {
        final Person person1 = Person.builder()
            .firstName("John")
            .lastName("Doe")
            .age(30)
            .build();

        final Person person2 = Person.builder()
            .firstName("Jane")
            .lastName("Smith")
            .age(25)
            .build();

        assertThat(person1.hashCode()).isNotEqualTo(person2.hashCode());
    }

    @Test
    @DisplayName("should not equal person with different age")
    void shouldNotEqualPersonWithDifferentAge() {
        final Person person1 = Person.builder()
            .firstName("John")
            .lastName("Doe")
            .age(30)
            .build();

        final Person person2 = Person.builder()
            .firstName("John")
            .lastName("Doe")
            .age(31)
            .build();

        assertThat(person1).isNotEqualTo(person2);
    }

    @Test
    @DisplayName("should not equal person with different lastName")
    void shouldNotEqualPersonWithDifferentLastName() {
        final Person person1 = Person.builder()
            .firstName("John")
            .lastName("Doe")
            .age(30)
            .build();

        final Person person2 = Person.builder()
            .firstName("John")
            .lastName("Smith")
            .age(30)
            .build();

        assertThat(person1).isNotEqualTo(person2);
    }
}
