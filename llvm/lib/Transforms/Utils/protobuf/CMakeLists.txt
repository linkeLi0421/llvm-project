INCLUDE(FindProtobuf)
# Create protobuf .h and .cc files, and put them in a library for use
find_package(Protobuf REQUIRED)
add_definitions(-DGOOGLE_PROTOBUF_NO_RTTI)

include_directories(${PROTOBUF_INCLUDE_DIRS})
include_directories(${CMAKE_CURRENT_BINARY_DIR})

PROTOBUF_GENERATE_CPP(IRPROTO_SRCS PROTO_HDRS IRInfo.proto)
PROTOBUF_GENERATE_CPP(MIRPROTO_SRCS PROTO_HDRS MIRInfo.proto)


add_llvm_component_library(Myproto
  ${IRPROTO_SRCS}
  ${MIRPROTO_SRCS}
  )

target_link_libraries(Myproto ${PROTOBUF_LIBRARY}) 