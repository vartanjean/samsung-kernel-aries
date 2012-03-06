/* drivers/misc/live_oc.c
 *
 * Copyright 2011  Ezekeel
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <linux/init.h>
#include <linux/device.h>
#include <linux/miscdevice.h>

#define LIVEOC_VERSION 1

#define MAX_OCVALUE 150

extern void liveoc_update(unsigned int oc_value, unsigned int oc_above, unsigned int oc_under);

static int oc_value = 100;

/* Apply Live OC to 400MHz and above*/
static int oc_above = 400000;

/* Apply Live OC to 0MHz and under*/
static int oc_under = 000000;

static ssize_t liveoc_ocvalue_read(struct device * dev, struct device_attribute * attr, char * buf)
{
    return sprintf(buf, "%u\n", oc_value);
}

static ssize_t liveoc_ocabove_read(struct device * dev, struct device_attribute * attr, char * buf)
{
    return sprintf(buf, "%u\n", oc_above);
}

static ssize_t liveoc_ocunder_read(struct device * dev, struct device_attribute * attr, char * buf)
{
    return sprintf(buf, "%u\n", oc_under);
}

static ssize_t liveoc_ocvalue_write(struct device * dev, struct device_attribute * attr, const char * buf, size_t size)
{
    unsigned int data;

    if(sscanf(buf, "%u\n", &data) == 1) 
	{
	    if (data >= 100 && data <= MAX_OCVALUE)
		{
		    if (data != oc_value)
			{
			    oc_value = data;

			    liveoc_update(oc_value, oc_above, oc_under);
			}

		    pr_info("LIVEOC oc-value set to %u\n", oc_value);
		}
	    else
		{
		    pr_info("%s: invalid input range %u\n", __FUNCTION__, data);
		}
	} 
    else 
	{
	    pr_info("%s: invalid input\n", __FUNCTION__);
	}

    return size;
}

static ssize_t liveoc_ocabove_write(struct device * dev, struct device_attribute * attr, const char * buf, size_t size)
{
    unsigned int data;

    if(sscanf(buf, "%u\n", &data) == 1) 
	{
	    if (data != oc_value)
		{
		    oc_above = data;
	    
		    liveoc_update(oc_value, oc_above, oc_under);
		    pr_info("LIVEOC oc-above set to %u\n", oc_above);
		}
	    else
		{
		    pr_info("%s: invalid input range %u\n", __FUNCTION__, data);
		}
	} 
    else 
	{
	    pr_info("%s: invalid input\n", __FUNCTION__);
	}

    return size;
}


static ssize_t liveoc_ocunder_write(struct device * dev, struct device_attribute * attr, const char * buf, size_t size)
{
    unsigned int data;

    if(sscanf(buf, "%u\n", &data) == 1) 
	{
	    if (data <= oc_above)
		{
		    oc_under = data;
	    
		    liveoc_update(oc_value, oc_above, oc_under);
		    pr_info("LIVEOC oc-under set to %u\n", oc_under);
		}
	    else
		{
		    pr_info("%s: invalid input range %u\n", __FUNCTION__, data);
		}
	} 
    else 
	{
	    pr_info("%s: invalid input\n", __FUNCTION__);
	}

    return size;
}




static ssize_t liveoc_version(struct device * dev, struct device_attribute * attr, char * buf)
{
    return sprintf(buf, "%u\n", LIVEOC_VERSION);
}

static DEVICE_ATTR(oc_value, S_IRUGO | S_IWUGO, liveoc_ocvalue_read, liveoc_ocvalue_write);
static DEVICE_ATTR(oc_above, S_IRUGO | S_IWUGO, liveoc_ocabove_read, liveoc_ocabove_write);
static DEVICE_ATTR(oc_under, S_IRUGO | S_IWUGO, liveoc_ocunder_read, liveoc_ocunder_write);
static DEVICE_ATTR(version, S_IRUGO , liveoc_version, NULL);

static struct attribute *liveoc_attributes[] = 
    {
	&dev_attr_oc_value.attr,
	&dev_attr_oc_above.attr,
	&dev_attr_oc_under.attr,
	&dev_attr_version.attr,
	NULL
    };

static struct attribute_group liveoc_group = 
    {
	.attrs  = liveoc_attributes,
    };

static struct miscdevice liveoc_device = 
    {
	.minor = MISC_DYNAMIC_MINOR,
	.name = "liveoc",
    };

static int __init liveoc_init(void)
{
    int ret;

    pr_info("%s misc_register(%s)\n", __FUNCTION__, liveoc_device.name);

    ret = misc_register(&liveoc_device);

    if (ret) 
	{
	    pr_err("%s misc_register(%s) fail\n", __FUNCTION__, liveoc_device.name);

	    return 1;
	}

    if (sysfs_create_group(&liveoc_device.this_device->kobj, &liveoc_group) < 0) 
	{
	    pr_err("%s sysfs_create_group fail\n", __FUNCTION__);
	    pr_err("Failed to create sysfs group for device (%s)!\n", liveoc_device.name);
	}

    return 0;
}

device_initcall(liveoc_init);
