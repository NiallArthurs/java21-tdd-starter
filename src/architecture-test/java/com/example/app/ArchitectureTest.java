/*
 * Copyright (c) 2025 {Project Name}
 * Licensed under the MIT License. See LICENSE file in the project root for details.
 */
package com.example.app;

import com.tngtech.archunit.core.domain.JavaClasses;
import com.tngtech.archunit.core.importer.ImportOption;
import com.tngtech.archunit.junit.AnalyzeClasses;
import com.tngtech.archunit.junit.ArchTest;
import com.tngtech.archunit.lang.ArchRule;

import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.classes;
import static com.tngtech.archunit.library.GeneralCodingRules.NO_CLASSES_SHOULD_ACCESS_STANDARD_STREAMS;
import static com.tngtech.archunit.library.GeneralCodingRules.NO_CLASSES_SHOULD_THROW_GENERIC_EXCEPTIONS;
import static com.tngtech.archunit.library.GeneralCodingRules.NO_CLASSES_SHOULD_USE_FIELD_INJECTION;
import static com.tngtech.archunit.library.GeneralCodingRules.NO_CLASSES_SHOULD_USE_JAVA_UTIL_LOGGING;
import static com.tngtech.archunit.library.GeneralCodingRules.NO_CLASSES_SHOULD_USE_JODATIME;

/**
 * Architecture tests using ArchUnit to enforce structural rules.
 * <p>
 * These tests verify that the codebase follows architectural best practices
 * and maintains proper separation of concerns. As the project grows, add more
 * rules to enforce layering (e.g., controller → service → repository).
 * </p>
 */
@AnalyzeClasses(packages = "com.example.app", importOptions = ImportOption.DoNotIncludeTests.class)
final class ArchitectureTest {

    private ArchitectureTest() {
        // Utility class - prevent instantiation
    }

    /**
     * Ensures all exception classes extend ApplicationException for consistent exception handling.
     * Allows empty should to pass when no custom exceptions exist yet.
     */
    @ArchTest
    static final ArchRule EXCEPTIONS_SHOULD_EXTEND_APPLICATION_EXCEPTION =
        classes()
            .that().haveSimpleNameEndingWith("Exception")
            .and().areNotAssignableTo(ApplicationException.class)
            .and().areNotAssignableFrom(ApplicationException.class)
            .should().beAssignableTo(ApplicationException.class)
            .allowEmptyShould(true)
            .because("All custom exceptions should extend ApplicationException for consistency");

    /**
     * Ensures utility classes follow proper design patterns.
     * Utility classes should have a private constructor to prevent instantiation.
     */
    @ArchTest
    static final ArchRule UTILITY_CLASSES_SHOULD_BE_PROPERLY_DESIGNED =
        classes()
            .that().haveSimpleNameEndingWith("Utils")
            .should().haveOnlyPrivateConstructors()
            .allowEmptyShould(true)
            .because("Utility classes should not be instantiable");

    /**
     * Prevents the use of java.util.logging in favor of SLF4J.
     * Use @Slf4j annotation from Lombok for consistent logging.
     */
    @ArchTest
    static final ArchRule SHOULD_USE_SLF4J_NOT_JAVA_UTIL_LOGGING = NO_CLASSES_SHOULD_USE_JAVA_UTIL_LOGGING;

    /**
     * Prevents field injection in favor of constructor injection.
     * This promotes better testability and immutability.
     */
    @ArchTest
    static final ArchRule SHOULD_NOT_USE_FIELD_INJECTION = NO_CLASSES_SHOULD_USE_FIELD_INJECTION;

    /**
     * Prevents the use of System.out and System.err for logging.
     * Use proper logging framework (SLF4J) instead.
     */
    @ArchTest
    static final ArchRule SHOULD_NOT_ACCESS_STANDARD_STREAMS = NO_CLASSES_SHOULD_ACCESS_STANDARD_STREAMS;

    /**
     * Prevents throwing generic exceptions like Exception, RuntimeException, or Throwable.
     * Throw specific exceptions that extend ApplicationException instead.
     */
    @ArchTest
    static final ArchRule SHOULD_NOT_THROW_GENERIC_EXCEPTIONS = NO_CLASSES_SHOULD_THROW_GENERIC_EXCEPTIONS;

    /**
     * Prevents the use of Joda-Time in favor of java.time (Java 8+ Date/Time API).
     * Joda-Time is deprecated and superseded by java.time.
     */
    @ArchTest
    static final ArchRule SHOULD_NOT_USE_JODATIME = NO_CLASSES_SHOULD_USE_JODATIME;

    /**
     * Ensures no cyclic dependencies between packages.
     * Cyclic dependencies make code harder to understand, test, and maintain.
     * Allows empty should for single-package projects.
     */
    @ArchTest
    static void packagesShouldBeFreeOfCycles(final JavaClasses classes) {
        com.tngtech.archunit.library.dependencies.SlicesRuleDefinition.slices()
            .matching("com.example.app.(*)..")
            .should().beFreeOfCycles()
            .allowEmptyShould(true)
            .check(classes);
    }

    /**
     * Ensures interfaces are not named with "Impl" suffix.
     * Interfaces should describe behavior, not implementation.
     */
    @ArchTest
    static final ArchRule INTERFACES_SHOULD_NOT_HAVE_IMPL_SUFFIX =
        classes()
            .that().areInterfaces()
            .should().haveSimpleNameNotEndingWith("Impl")
            .allowEmptyShould(true)
            .because("Interfaces should describe behavior, not implementation");

    /**
     * Ensures classes follow proper naming conventions.
     * Classes ending with "Exception" should actually be exceptions.
     */
    @ArchTest
    static final ArchRule CLASSES_NAMED_EXCEPTION_SHOULD_BE_EXCEPTIONS =
        classes()
            .that().haveSimpleNameEndingWith("Exception")
            .should().beAssignableTo(Exception.class)
            .because("Classes ending with 'Exception' should be actual exceptions");

    /**
     * Ensures public API classes are in appropriate packages.
     * Classes in api/controller/rest packages should not contain business logic.
     */
    @ArchTest
    static final ArchRule PUBLIC_API_SHOULD_NOT_CONTAIN_BUSINESS_LOGIC =
        classes()
            .that().resideInAnyPackage("..api..", "..controller..", "..rest..")
            .should().notBeAnnotatedWith("javax.persistence.Entity")
            .andShould().notBeAnnotatedWith("jakarta.persistence.Entity")
            .allowEmptyShould(true)
            .because("API/Controller packages should not contain entity classes");
}
