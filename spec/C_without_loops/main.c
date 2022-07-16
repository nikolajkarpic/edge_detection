
#include <stdio.h>
#define IMG_SIZE 400
#define KERNEL_SIZE 9
#define CONV_LIMIT IMG_SIZE - KERNEL_SIZE

int main()
{
    unsigned char ready = 1;
    unsigned char start = 1;

    int i = 0;
    int j = 0;
    int k = 0;
    int l = 0;

    float sum = 0;
    float sum0 = 0;
    float sum1 = 0;
    float sum2 = 0;

    int pixel_0_val;
    int pixel_1_val;
    int pixel_2_val;

    int pixle_0_address;
    int pixle_1_address;
    int pixle_2_address;

    int conv_address = 0;
    int conv_out = 0;
    int conv_bram[IMG_SIZE * IMG_SIZE];

    float kenel_0_val;
    float kenel_1_val;
    float kenel_2_val;

    int kernel_0_address;
    int kernel_1_address;
    int kernel_2_address;

    int pixel_data[IMG_SIZE * IMG_SIZE];
    float kernel_data[KERNEL_SIZE * KERNEL_SIZE];

idle:
    ready = 1;
    if (start)
    {
        start = 0;
        goto initial_load;
    }
    else
    {
        goto idle;
    }
initial_load:
    pixel_0_val = pixel_data[0];
    pixel_1_val = pixel_data[1];
    pixel_2_val = pixel_data[2];

    kenel_0_val = kernel_data[0];
    kenel_1_val = kernel_data[1];
    kenel_2_val = kernel_data[2];
    goto mac;

mac:
    sum0 = sum0 + (pixel_0_val * kenel_0_val);
    sum1 = sum1 + (pixel_1_val * kenel_1_val);
    sum2 = sum2 + (pixel_2_val * kenel_2_val);

    if (l == KERNEL_SIZE - 3)
    {
        if (k == KERNEL_SIZE - 1)
        {
            goto conv_out;
        }
        else
        {
            k = k + 1;
            goto resetL;
        }
    }
    else
    {
        l = l + 3;
        goto calculateAddress;
    }

calculateAddress:
    pixle_0_address = ((i + k) * IMG_SIZE) + j + l;
    pixle_1_address = ((i + k) * IMG_SIZE) + j + l + 1;
    pixle_2_address = ((i + k) * IMG_SIZE) + j + l + 2;

    conv_address = i * IMG_SIZE + j;


    kernel_0_address = k * KERNEL_SIZE + l;
    kernel_1_address = k * KERNEL_SIZE + l + 1;
    kernel_2_address = k * KERNEL_SIZE + l + 2;
    goto loadData;

loadData:
    pixel_0_val = pixel_data[pixle_0_address];
    pixel_1_val = pixel_data[pixle_1_address];
    pixel_2_val = pixel_data[pixle_2_address];

    kenel_0_val = kernel_data[kernel_0_address];
    kenel_1_val = kernel_data[kernel_1_address];
    kenel_2_val = kernel_data[kernel_2_address];
    goto mac;

conv_out:


    sum = (sum0 + sum1) + sum2;
    if (sum < 0)
    {
        conv_out = -1;
    }
    else if (sum > 0)
    {
        conv_out = 1;
    }
    else
    {
        conv_out = 0;
    }
    conv_bram[conv_address] = conv_out;

    if (j == CONV_LIMIT)
    {
        if (i == CONV_LIMIT)
        {
            goto idle;
        }
        else
        {
            i = i + 1;
            goto resetJ;
        }
    }
    else
    {
        j = j + 1;
        goto resetK;
    }

resetK:
    sum = 0;
    sum1 = 0;
    sum2 = 0;
    sum0 = 0;

    goto resetL;

resetL:
    l = 0;
    goto calculateAddress;

resetJ:
    j = 0;
    goto resetK;
    return 0;
}