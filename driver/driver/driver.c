#include <linux/init.h>
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/types.h>
#include <linux/cdev.h>
#include <linux/kdev_t.h>
#include <linux/uaccess.h>
#include <linux/errno.h>
#include <linux/kernel.h>
#include <linux/device.h>
#include <linux/string.h>
#include <linux/of.h>

#include <linux/mm.h>              //za memorijsko mapiranje
#include <linux/io.h>              //iowrite ioread
#include <linux/slab.h>            //kmalloc kfree
#include <linux/platform_device.h> //platform driver
#include <linux/of.h>              //of match table
#include <linux/ioport.h>          //ioremap

#include <linux/semaphore.h>

#define BUFF_SIZE 30
#define BRAM_SIZE 160000
#define IMG_SIZE 400
#define KERNEL_MATRIX_SIZE 9
#define DRIVER_NAME "CONV_driver"
#define DEVICE_NAME "CONV"

MODULE_AUTHOR("NJV");
MODULE_DESCRIPTION("Driver for convolution IP.");
MODULE_LICENSE("Dual BSD/GPL");
MODULE_ALIAS("custom:CONV");

//********************************************GLOBAL VARIABLES *****************************************//

struct semaphore bramImgSem;
struct semaphore bramResSem;
struct semaphore ipMem;

int bram_img_array[BRAM_SIZE];
int bram_res_array[BRAM_SIZE];

int kernel_reg_bank[81] = {
    41,
    187,
    511,
    893,
    1065,
    893,
    511,
    187,
    41,
    187,
    745,
    1721,
    2477,
    2671,
    2477,
    1721,
    745,
    187,
    511,
    1721,
    2769,
    1575,
    150,
    1575,
    2769,
    1721,
    511,
    893,
    2477,
    1575,
    -6023,
    -11821,
    -6023,
    1575,
    2477,
    893,
    1065,
    2671,
    150,
    -11821,
    -20480,
    -11821,
    150,
    2671,
    1065,
    893,
    2477,
    1575,
    -6023,
    -11821,
    -6023,
    1575,
    2477,
    893,
    511,
    1721,
    2769,
    1575,
    150,
    1575,
    2769,
    1721,
    511,
    187,
    745,
    1721,
    2477,
    2671,
    2477,
    1721,
    745,
    187,
    41,
    187,
    511,
    893,
    1065,
    893,
    511,
    187,
    41};
int start_reg = 0;
int done_reg = 0;
int bram_result_address = 0;
long int sum = 0;

struct CONV_info
{
    unsigned long mem_start;
    unsigned long mem_end;
    void __iomem *base_addr;
};

dev_t my_dev_id;
static struct class *my_class;
static struct device *my_device;
static struct cdev *my_cdev;
static struct CONV_info *ip = NULL;  // ip
static struct CONV_info *img = NULL; // bram_image
static struct CONV_info *res = NULL; // bram_results

int position = 0;
int number = 0;
int counter = 0;
int endRead = 0;
int read_counter = 0;
int i = 0;
int j = 0;
int k = 0;
int l = 0;

int bramResReadCounter = 0;
int allowNextStart = 1;

//****************************** FUNCTION PROTOTYPES ****************************************//
static int CONV_probe(struct platform_device *pdev);
static int CONV_remove(struct platform_device *pdev);
static int CONV_open(struct inode *pinode, struct file *pfile);
static int CONV_close(struct inode *pinode, struct file *pfile);
static ssize_t CONV_read(struct file *pfile, char __user *buf, size_t length, loff_t *offset);
static ssize_t CONV_write(struct file *pfile, const char __user *buf, size_t length, loff_t *offset);
// int CONV_mmap(struct file *f, struct vm_area_struct *vma_s);

static int __init CONV_init(void);
static void __exit CONV_exit(void);

struct file_operations my_fops =
    {
        .owner = THIS_MODULE,
        .read = CONV_read,
        .write = CONV_write,
        .open = CONV_open,
        .release = CONV_close
        // .mmap = CONV_mmap,

};

static struct of_device_id CONV_of_match[] = {

    {
        .compatible = "ip",
    },
    {
        .compatible = "bram_img",
    },
    {.compatible = "bram_res"},
    {/* end of list */}

};

static struct platform_driver CONV_driver = {

    .driver = {
        .name = DRIVER_NAME,
        .owner = THIS_MODULE,
        .of_match_table = CONV_of_match,
    },

    .probe = CONV_probe,
    .remove = CONV_remove,
};

MODULE_DEVICE_TABLE(of, CONV_of_match);

static int CONV_probe(struct platform_device *pdev)
{

    struct resource *r_mem;
    int rc = 0;
    r_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
    if (!r_mem)
    {
        printk(KERN_ALERT "Failed to get resource\n");
        return -ENODEV;
    }

    switch (counter)
    {

    case 0: // ip

        r_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
        if (!r_mem)
        {
            printk(KERN_ALERT "Failed to get resource\n");
            return -ENODEV;
        }
        ip = (struct CONV_info *)kmalloc(sizeof(struct CONV_info), GFP_KERNEL);
        if (!ip)
        {
            printk(KERN_ALERT "Could not allocate memory\n");
            return -ENOMEM;
        }

        ip->mem_start = r_mem->start;
        ip->mem_end = r_mem->end;
        // printk(KERN_INFO "Start address:%x \t end address:%x", r_mem->start, r_mem->end);

        if (!request_mem_region(ip->mem_start, ip->mem_end - ip->mem_start + 1, DRIVER_NAME))
        {
            printk(KERN_ALERT "Could not lock memory region at %p\n", (void *)ip->mem_start);
            rc = -EBUSY;
            goto error3;
        }

        ip->base_addr = ioremap(ip->mem_start, ip->mem_end - ip->mem_start + 1);

        if (!ip->base_addr)
        {
            printk(KERN_ALERT "Could not allocate memory\n");
            rc = -EIO;
            goto error4;
        }

        counter++;
        printk(KERN_WARNING "ip registered\n");
        return 0; // ALL OK

    error4:
        release_mem_region(ip->mem_start, ip->mem_end - ip->mem_start + 1);
    error3:
        return rc;

    case 1: // bram_img
        r_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
        if (!r_mem)
        {
            printk(KERN_ALERT "Failed to get resource\n");
            return -ENODEV;
        }
        img = (struct CONV_info *)kmalloc(sizeof(struct CONV_info), GFP_KERNEL);
        if (!img)
        {
            printk(KERN_ALERT "Could not allocate memory\n");
            return -ENOMEM;
        }

        img->mem_start = r_mem->start;
        img->mem_end = r_mem->end;
        // printk(KERN_INFO "Start address:%x \t end address:%x", r_mem->start, r_mem->end);

        if (!request_mem_region(img->mem_start, img->mem_end - img->mem_start + 1, DRIVER_NAME))
        {
            printk(KERN_ALERT "Could not lock memory region at %p\n", (void *)img->mem_start);
            rc = -EBUSY;
            goto error6;
        }

        img->base_addr = ioremap(img->mem_start, img->mem_end - img->mem_start + 1);

        if (!img->base_addr)
        {
            printk(KERN_ALERT "Could not allocate memory\n");
            rc = -EIO;
            goto error5;
        }

        counter++;
        printk(KERN_WARNING "BRAM_IMG registered\n");
        return 0; // ALL OK

    error5:
        release_mem_region(img->mem_start, img->mem_end - img->mem_start + 1);
    error6:
        return rc;

    case 2: // bram_after_conv
        r_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
        if (!r_mem)
        {
            printk(KERN_ALERT "Failed to get resource\n");
            return -ENODEV;
        }
        res = (struct CONV_info *)kmalloc(sizeof(struct CONV_info), GFP_KERNEL);
        if (!res)
        {
            printk(KERN_ALERT "Could not allocate memory\n");
            return -ENOMEM;
        }

        res->mem_start = r_mem->start;
        res->mem_end = r_mem->end;
        // printk(KERN_INFO "Start address:%x \t end address:%x", r_mem->start, r_mem->end);

        if (!request_mem_region(res->mem_start, res->mem_end - res->mem_start + 1, DRIVER_NAME))
        {
            printk(KERN_ALERT "Could not lock memory region at %p\n", (void *)res->mem_start);
            rc = -EBUSY;
            goto error8;
        }

        res->base_addr = ioremap(res->mem_start, res->mem_end - res->mem_start + 1);

        if (!res->base_addr)
        {
            printk(KERN_ALERT "Could not allocate memory\n");
            rc = -EIO;
            goto error7;
        }
        counter++;
        printk(KERN_WARNING "BRAM_AFTER_CONV registered\n");
        return 0; // ALL OK

    error7:
        release_mem_region(res->mem_start, res->mem_end - res->mem_start + 1);
    error8:
        return rc;
    }

    return 0;
}

static int CONV_remove(struct platform_device *pdev)
{

    switch (counter)
    {

    case 0:
        printk(KERN_WARNING "IP_remove: platform driver removing\n");
        iowrite32(0, ip->base_addr);
        iounmap(ip->base_addr);
        release_mem_region(ip->mem_start, ip->mem_end - ip->mem_start + 1);
        kfree(ip);
        printk(KERN_INFO "IP_remove: IP removed\n");

        break;

    case 1:
        printk(KERN_WARNING "BRAM_IMG_remove: platform driver removing\n");
        iowrite32(0, img->base_addr);
        iounmap(img->base_addr);
        release_mem_region(img->mem_start, img->mem_end - img->mem_start + 1);
        kfree(img);
        printk(KERN_INFO "BRAM_IMG_remove: BRAM_IMG removed \n");
        counter--;
        break;

    case 2: // res
        printk(KERN_WARNING "BRAM_RES_remove: platform driver removing\n");
        iowrite32(0, res->base_addr);
        iounmap(res->base_addr);
        release_mem_region(res->mem_start, res->mem_end - res->mem_start + 1);
        kfree(res);
        printk(KERN_INFO "BRAM_RES_remove: BRAM_RES removed\n");
        counter--;
        break;
    }

    return 0;
}

int CONV_open(struct inode *pinode, struct file *pfile)
{

    printk(KERN_INFO "Succesfully opened file\n");
    return 0;
}

int CONV_close(struct inode *pinode, struct file *pfile)
{

    printk(KERN_INFO "Succesfully closed file\n");
    return 0;
}

ssize_t CONV_read(struct file *pfile, char __user *buf, size_t length, loff_t *offset)
{

    int ret, pos = 0;
    char buff[BUFF_SIZE];
    int len, value;
    int minor = MINOR(pfile->f_inode->i_rdev);
    if (endRead == 1)
    {
        endRead = 0;
        return 0;
    }
    switch (minor)
    {

    case 0: // ip
        if (down_interruptible(&ipMem))
        {

            printk(KERN_INFO "Bram IMG: semaphore: access to IP denied.\n");
            return -ERESTARTSYS;
        }
        pos = 4; // done ?
        // value = ioread32(ip->base_addr + pos);
        value = done_reg;
        len = scnprintf(buff, BUFF_SIZE, "%d\n", value);
        *offset += len;
        ret = copy_to_user(buf, buff, len);
        if (ret)
        {
            return -EFAULT;
        }

        endRead = 1;

        up(&ipMem);

        break;

    case 1: // bram_img
        printk(KERN_WARNING "CONV_write: cannot read from this BRAM_img \n");
        break;

    case 2: // bram_after_conv
        if (down_interruptible(&bramResSem))
        {
            printk(KERN_INFO "Bram RES: semaphore: access to memory denied.\n");

            return -ERESTARTSYS;
        }
        // value = ioread32(res->base_addr + k * 4);
        // value = bram_res_array[read_counter];
        value = bram_res_array[bram_result_address];
        len = scnprintf(buff, BUFF_SIZE, "%d\n", value);
        *offset += len;
        ret = copy_to_user(buf, buff, len);

        printk(KERN_INFO "Bram RES:%d.\n", bramResReadCounter);
        if (bram_result_address == BRAM_SIZE - 1)
        {

            allowNextStart = 1;
        }
        if (ret)
        {
            return -EFAULT;
        }
        endRead = 1;
        // read_counter++;
        // if (read_counter == BRAM_SIZE)
        // {
        //     endRead = 1;
        //     read_counter = 0;
        // }
        up(&bramResSem);
        break;

    default:
        printk(KERN_INFO "somethnig went wrong\n");
    }

    return len;
}

ssize_t CONV_write(struct file *pfile, const char __user *buf, size_t length, loff_t *offset)
{

    char buff[BUFF_SIZE];
    int minor = MINOR(pfile->f_inode->i_rdev);
    int start = 0;
    int ret = 0, pos = 0;
    int pixelVal = 0;
    long int bram_res_adr;
    long int bramPos = 0;
    ret = copy_from_user(buff, buf, length);

    if (ret)
    {
        printk("copy from user failed \n");
        return -EFAULT;
    }
    buff[length] = '\0';

    switch (minor)
    {

    case 0: // IP
        if (down_interruptible(&ipMem))
        {

            printk(KERN_INFO "Bram IMG: semaphore: access to IP denied.\n");
            return -ERESTARTSYS;
        }
        if (down_interruptible(&bramImgSem))
        {

            printk(KERN_INFO "Bram IMG: semaphore: access to memory denied.\n");
            return -ERESTARTSYS;
        }
        if (down_interruptible(&bramResSem))
        {
            printk(KERN_INFO "Bram RES: semaphore: access to memory denied.\n");

            return -ERESTARTSYS;
        }
        sscanf(buff, "%d", &start);

        if (ret != -EINVAL)
        {
            if (allowNextStart == 0)
            {
                printk(KERN_WARNING "IP: To start next proccess first read data from results memory! \n");
            }
            else if (start != 0 && start != 1)
            {
                printk(KERN_WARNING "IP: start must be 1 or 0 \n");
            }
            else
            {
                allowNextStart = 0;
                start_reg = 1;
                for (i = 0; i < IMG_SIZE - KERNEL_MATRIX_SIZE + 1; i++)
                {
                    for (j = 0; j < IMG_SIZE - KERNEL_MATRIX_SIZE + 1; j++)
                    {
                        sum = 0;
                        for (k = 0; k < KERNEL_MATRIX_SIZE; k++)
                        {
                            for (l = 0; l < KERNEL_MATRIX_SIZE; l++)
                            {
                                sum = sum + (kernel_reg_bank[(k * KERNEL_MATRIX_SIZE) + l] * (bram_img_array[((i + k) * IMG_SIZE) + j + l]));

                                // sum = sum + (kernel_reg_bank[(k * KERNEL_MATRIX_SIZE) + l] * (int)((bram_img_array[((i + k) * IMG_SIZE) + j + l])) / 10000);
                            }
                        }

                        if (sum < 0)
                        {
                            sum = -1;
                        }
                        else if (sum > 0)
                        {
                            sum = 1;
                        }
                        else
                        {
                            sum = 0;
                        }

                        bram_res_array[i * IMG_SIZE + j] = sum;
                    }
                }
                // iowrite32((u32)start, ip->base_addr); // columns
            }
            start_reg = 0;
            done_reg = 1;
        }
        up(&ipMem);
        up(&bramImgSem);
        up(&bramResSem);

        break;

    case 1: // bram_img
        if (down_interruptible(&bramImgSem))
        {
            printk(KERN_INFO "Bram IMG: semaphore: access to memory denied.\n");
            return -ERESTARTSYS;
        }
        printk(KERN_WARNING "CONV_write: about to write to bram_img \n");
        sscanf(buff, "(%ld,%d)", &bramPos, &pixelVal);
        printk(KERN_WARNING "CONV_write:brma pos: %ld, pixel value: %d\n", bramPos, pixelVal);
        if (pixelVal > 255)
        {
            printk(KERN_WARNING "BRAM_IMG: Pixel value cannot be larger than 255 \n");
        }
        else if (pixelVal < 0)
        {
            printk(KERN_WARNING "BRAM_IMG: Pixel value cannot be negative \n");
        }
        else if (bramPos < 0)
        {
            printk(KERN_WARNING "BRAM_IMG: Pixel adr cannot be negative \n");
        }
        else if (bramPos > BRAM_SIZE - 1)
        {
            printk(KERN_WARNING "BRAM_IMG: Pixel adr cannot be larger than bram size \n");
        }
        else
        {
            // printk(KERN_WARNING "CONV_write: about to write to %p, brma pos: %ld, pixel value: %d\n", img->base_addr, bramPos, pixelVal);
            pos = bramPos * 4;
            bram_img_array[bramPos] = pixelVal;
            // iowrite32((u32)pixelVal, img->base_addr);
            // iowrite32((u32)bramPos, img->base_addr + 8);
        }
        up(&bramImgSem);
        break;

    case 2: // bram_after_conv
        if (down_interruptible(&bramResSem))
        {

            printk(KERN_INFO "Bram RES: semaphore: access to memory denied.\n");
            return -ERESTARTSYS;
        }
        sscanf(buff, "%d", &start);
        sscanf(buff, "%ld", &bram_res_adr);
        if (bram_res_adr < 0)
        {
            printk(KERN_WARNING "CONV_write: BRAM res out adr cannot be negative \n");
        }
        else if (bram_res_adr > BRAM_SIZE - 1)
        {
            printk(KERN_WARNING "CONV_write: BRAM res out adr cannot be larger than bram size \n");
        }
        else
        {
            bram_result_address = bram_res_adr;
        }
        up(&bramResSem);
        break;
    default:
        printk(KERN_INFO "somethnig went wrong\n");
    }

    return length;
}

static int __init CONV_init(void)
{
    sema_init(&bramImgSem, 1);
    sema_init(&bramResSem, 1);
    sema_init(&ipMem, 1);

    int num_of_minors = 3;
    int ret = 0;
    ret = alloc_chrdev_region(&my_dev_id, 0, num_of_minors, "CONV_region");
    if (ret != 0)
    {

        printk(KERN_ERR "Failed to register char device\n");
        return ret;
    }
    printk(KERN_INFO "Char device region allocated\n");

    my_class = class_create(THIS_MODULE, "CONV_class");
    if (my_class == NULL)
    {
        printk(KERN_ERR "Failed to create class\n");
        goto fail_0;
    }
    printk(KERN_INFO "Class created\n");

    my_device = device_create(my_class, NULL, MKDEV(MAJOR(my_dev_id), 0), NULL, "ip");
    if (my_device == NULL)
    {
        printk(KERN_ERR "failed to create device IP\n");
        goto fail_1;
    }
    printk(KERN_INFO "created IP\n");
    my_device = device_create(my_class, NULL, MKDEV(MAJOR(my_dev_id), 1), NULL, "bram_img");
    if (my_device == NULL)
    {
        printk(KERN_ERR "failed to create device BRAM_IMG\n");
        goto fail_1;
    }
    printk(KERN_INFO "created BRAM_IMG\n");
    my_device = device_create(my_class, NULL, MKDEV(MAJOR(my_dev_id), 2), NULL, "bram_res");
    if (my_device == NULL)
    {
        printk(KERN_ERR "failed to create device BRAM_RES\n");
        goto fail_1;
    }
    printk(KERN_INFO "created BRAM_RES\n");

    my_cdev = cdev_alloc();
    my_cdev->ops = &my_fops;
    my_cdev->owner = THIS_MODULE;
    ret = cdev_add(my_cdev, my_dev_id, 3);
    if (ret)
    {
        printk(KERN_ERR "Failde to add cdev \n");
        goto fail_2;
    }
    printk(KERN_INFO "cdev_added\n");
    printk(KERN_INFO "Hello from CONV_driver\n");

    return platform_driver_register(&CONV_driver);

fail_2:
    device_destroy(my_class, my_dev_id);
fail_1:
    class_destroy(my_class);
fail_0:
    unregister_chrdev_region(my_dev_id, 1);
    return -1;
}

static void __exit CONV_exit(void)
{
    printk(KERN_ALERT "CONV_exit: rmmod called\n");
    platform_driver_unregister(&CONV_driver);
    printk(KERN_INFO "CONV_exit: platform_driver_unregister done\n");
    cdev_del(my_cdev);
    printk(KERN_ALERT "CONV_exit: cdev_del done\n");
    device_destroy(my_class, MKDEV(MAJOR(my_dev_id), 0));
    printk(KERN_INFO "CONV_exit: device destroy 0\n");
    device_destroy(my_class, MKDEV(MAJOR(my_dev_id), 1));
    printk(KERN_INFO "CONV_exit: device destroy 1\n");
    device_destroy(my_class, MKDEV(MAJOR(my_dev_id), 2));
    printk(KERN_INFO "CONV_exit: device destroy 2\n");
    class_destroy(my_class);
    printk(KERN_INFO "CONV_exit: class destroy \n");
    unregister_chrdev_region(my_dev_id, 3);
    printk(KERN_ALERT "Goodbye from CONV_driver\n");
}

module_init(CONV_init);
module_exit(CONV_exit);