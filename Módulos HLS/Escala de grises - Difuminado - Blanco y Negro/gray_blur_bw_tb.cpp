#include "gray_blur_bw.h"
#include "hls_opencv.h"
#include "stdio.h"

int main()
{
	int const rows = MAX_HEIGHT;
	int const cols = MAX_WIDTH;

	cv::Mat src = cv::imread("cruz_1080.bmp");
	cv::Mat dst(rows, cols, CV_8UC1);

	stream_in_t stream_in;
	stream_out_t stream_out;

	cvMat2AXIvideo(src, stream_in);
	gray_blur_bw(stream_in, stream_out);
	AXIvideo2cvMat(stream_out, dst);

	//printf("------- Vamos --------\n");
	//printf("Pixeles: %d\n\n", pixels);

	cv::imwrite("cruz_out.bmp", dst);

	return 0;
}
