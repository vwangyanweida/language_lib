cmake_minimum_required (VERSION 2.6)
project (test)

set(Tutorial_VERSION_MAJOR 1)
set(Tutorial_VERSION_MINOR 0)

configure_file("${PROJECT_SOURCE_DIR}/TutorialConfig.h.in" "${PROJECT_BINARY_DIR}/TutorialConfig.h")

option(USE_MATHA ON)
include_directories("${PROJECT_SOURCE_DIR}/MathFunctions")
include_directories("${PROJECT_BINARY_DIR}")
add_subdirectory(MathFunctions)

add_executable(Tutorial tutorial.cpp)
target_link_libraries(Tutorial Matha)

install(TARGETS Tutorial DESTINATION bin)
install(FILES "${PROJECT_BINARY}/TutorialConfig.h" DESTINATION include)

