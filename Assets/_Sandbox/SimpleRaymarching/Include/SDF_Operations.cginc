#ifndef SDF_OPERATIONS
#define SDF_OPERATIONS

float opUnion(float d1, float d2) { return min(d1, d2); }
float opSmoothUnion(float d1, float d2, float k = .5)
{
	float h = clamp(0.5 + 0.5*(d2 - d1) / k, 0.0, 1.0);
	return lerp(d2, d1, h) - k * h*(1.0 - h);
}

float opSubtraction(float d1, float d2) { return max(-d1, d2); }
float opSmoothSubtraction(float d1, float d2, float k = .5)
{
	float h = clamp(0.5 - 0.5*(d2 + d1) / k, 0.0, 1.0);
	return lerp(d2, -d1, h) + k * h*(1.0 - h);
}

float opIntersection(float d1, float d2) { return max(d1, d2); }
float opSmoothIntersection(float d1, float d2, float k = .5)
{
	float h = clamp(0.5 - 0.5*(d2 - d1) / k, 0.0, 1.0);
	return lerp(d2, d1, h) + k * h*(1.0 - h);
}

float opOnion(in float sdf, in float thickness)
{
	return abs(sdf) - thickness;
}

#endif
