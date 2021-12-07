#include <stdio.h>
#include "ap_fixed.h"

typedef ap_fixed<16,9, AP_TRN, AP_SAT> FixedTypeIn;
typedef ap_fixed<32,24, AP_TRN, AP_SAT> FixedTypeOut;

void exponential ( FixedTypeIn in, FixedTypeOut *out);

int main()
{
	FixedTypeIn in = FixedTypeIn(4.175);
	FixedTypeOut out;

	exponential(in, &out);
	printf("%f\n\n", float(out));

	return 0;
}
