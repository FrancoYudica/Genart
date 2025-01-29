#[compute]
#version 450

layout(local_size_x = 256, local_size_y = 1, local_size_z = 1) in;

// Parameters passed to the shader
layout(push_constant, std430) uniform Params
{
    vec2 texture_size;
    float power;
}
params;

layout(set = 0, binding = 0, std430) restrict buffer ResultBuffer
{
    float partial_mpa_sums[];
};

layout(set = 0, binding = 1, std430) restrict buffer WeightsResultBuffer
{
    float partial_weight_sums[];
};

layout(rgba32f, set = 1, binding = 0) uniform
    restrict readonly image2D target_image;
layout(rgba32f, set = 2, binding = 0) uniform
    restrict readonly image2D source_image;
layout(rgba32f, set = 3, binding = 0) uniform
    restrict readonly image2D weight_image;

shared float shared_partial_mpa_sum[gl_WorkGroupSize.x];
shared float shared_partial_weights_sum[gl_WorkGroupSize.x];

struct MetricData {
    float value;
    float weight;
};

MetricData compute_mse(uint x, uint y)
{
    vec4 target_pixel = imageLoad(target_image, ivec2(x, y));
    vec4 source_pixel = imageLoad(source_image, ivec2(x, y));
    vec4 weight_pixel = imageLoad(weight_image, ivec2(x, y));

    // Compute the squared difference for each color channel
    vec3 diff = abs(target_pixel.rgb - source_pixel.rgb);
    float squared_diff = dot(diff, diff);
    return MetricData(squared_diff * weight_pixel.r, weight_pixel.r);
}

void main()
{

    uint global_id = gl_GlobalInvocationID.x;
    uint local_id = gl_LocalInvocationID.x;
    uint group_id = gl_WorkGroupID.x;

    // Compute total number of pixels in the subrectangle
    uint num_pixels = uint(params.texture_size.x * params.texture_size.y);

    // Initialize shared data
    shared_partial_mpa_sum[local_id] = 0.0;
    shared_partial_weights_sum[local_id] = 0.0;

    // Process pixel if within bounds of the image
    if (global_id < num_pixels) {
        // Map global_id to image coordinates
        uint x = global_id % uint(params.texture_size.x);
        uint y = global_id / uint(params.texture_size.x);

        MetricData data = compute_mse(x, y);
        shared_partial_mpa_sum[local_id] += data.value;
        shared_partial_weights_sum[local_id] += data.weight;
    }

    // Synchronize threads in the workgroup
    barrier();

    // Perform parallel reduction
    for (uint stride = gl_WorkGroupSize.x / 2; stride > 0; stride /= 2) {
        if (local_id < stride) {
            shared_partial_mpa_sum[local_id] += shared_partial_mpa_sum[local_id + stride];
            shared_partial_weights_sum[local_id] += shared_partial_weights_sum[local_id + stride];
        }
        barrier();
    }

    // Write the result of the reduction to the output buffer (only thread 0)
    if (local_id == 0) {
        partial_mpa_sums[group_id] = shared_partial_mpa_sum[0];
        partial_weight_sums[group_id] = shared_partial_weights_sum[0];
    }
}
