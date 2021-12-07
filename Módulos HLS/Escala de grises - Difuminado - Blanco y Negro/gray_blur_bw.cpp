#include "gray_blur_bw.h"

void gray_blur_bw(stream_in_t &stream_in, stream_out_t &stream_out)
{
	int const rows = MAX_HEIGHT;
	int const cols = MAX_WIDTH;

	rgb_img_t img0(rows, cols);
	gray_img_t img1(rows, cols);
	gray_img_t img2(rows, cols);
	gray_img_t img3(rows, cols);

	hls::AXIvideo2Mat(stream_in, img0);
	hls::CvtColor<HLS_RGB2GRAY>(img0, img1);
	hls::GaussianBlur<5,5>(img1, img2);
	hls:Threshold(img2, img3, 115, 255, HLS_THRESH_BINARY);
	hls::Mat2AXIvideo(img3, stream_out);
}
