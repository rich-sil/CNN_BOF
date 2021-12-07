
#include "ap_fixed.h"
#include "hls_math.h"

typedef ap_fixed<16,9, AP_TRN, AP_SAT> FixedTypeIn;
typedef ap_fixed<32,24, AP_TRN, AP_SAT> FixedTypeOut;

void exponential ( FixedTypeIn in , FixedTypeOut *out)
{
	float in_f = float(in);

	float exp = hls::exp(in_f);

	*out = FixedTypeOut(exp);
}
