add_subdirectory(utils)

aux_source_directory(. SRC)

add_library (src ${SRC})
target_link_libraries(src utils)
