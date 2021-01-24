cmake_minimum_required(VERSION 3.0.0)
project(main VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
if("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    # https://github.com/google/sanitizers/wiki/AddressSanitizer
    set(CMAKE_CXX_FLAGS "-Wall -Werror=return-type -fsanitize=address,undefined -fno-omit-frame-pointer ${CMAKE_CXX_FLAGS}")
else()
    set(CMAKE_CXX_FLAGS "-O0 ${CMAKE_CXX_FLAGS}")
endif()
message(${CMAKE_CXX_FLAGS})

configure_file (
  ${PROJECT_SOURCE_DIR}/config.h.in
  ${PROJECT_BINARY_DIR}/config.h
)

include_directories(
    /usr/local/include
    ${PROJECT_BINARY_DIR}
)
link_directories(
    /usr/local/lib
    ${PROJECT_BINARY_DIR}
)

# add_library(ur_lib
#     SHARED
#     IMPORTED
# )
# set_target_properties(ur_lib
#     PROPERTIES
#     IMPORTED_LOCATION
#     ${PROJECT_SOURCE_DIR}/path/to/ur_lib)

add_subdirectory(src)

add_executable(${PROJECT_NAME} main.cpp)
target_include_directories(
    ${PROJECT_NAME} PUBLIC
    ${PROJECT_BINARY_DIR}
)
target_link_libraries(${PROJECT_NAME} src)

# Test case
include(CTest)
enable_testing()

# build package installer start
include (InstallRequiredSystemLibraries)
set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
set(CPACK_RESOURCE_FILE_LICENSE  "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
set(CPACK_SET_DESTDIR ON)
include(CPack)
# build package installer end
