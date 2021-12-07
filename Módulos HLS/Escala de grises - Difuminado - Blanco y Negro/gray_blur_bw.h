#include "hls_video.h"

typedef ap_axiu<24,1,1,1> interface_in;
typedef hls::stream<interface_in> stream_in_t;

typedef ap_axiu<8,1,1,1> interface_out;
typedef hls::stream<interface_out> stream_out_t;

void gray_blur_bw(stream_in_t &stream_in, stream_out_t &stream_out);

#define MAX_WIDTH	1920
#define MAX_HEIGHT	1080

typedef hls::Mat<MAX_HEIGHT, MAX_WIDTH, HLS_8UC3> rgb_img_t;
typedef hls::Mat<MAX_HEIGHT, MAX_WIDTH, HLS_8UC1> gray_img_t;
