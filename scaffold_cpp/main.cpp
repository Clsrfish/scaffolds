#include <iostream>

#include "./config.h"
#include "./src/index.cpp"
#include "./src/utils/log.h"

int main(int argc, char const *argv[]) {
    LOG_I("%s@%s", PROJECT_NAME, PROJECT_VERSION);
    hello();
    return 0;
}