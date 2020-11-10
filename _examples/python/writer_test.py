###############################################################################
# (c) 2005-2015 Copyright, Real-Time Innovations.  All rights reserved.       #
# No duplications, whole or partial, manual or electronic, may be made        #
# without express written permission.  Any such copies, or revisions thereof, #
# must display this notice unaltered.                                         #
# This code contains trade secrets of Real-Time Innovations, Inc.             #
###############################################################################

from sys import path as sysPath
from os import path as osPath
# from time import sleep
import time
import ctypes
filepath = osPath.dirname(osPath.realpath(__file__))
import argparse
import rticonnextdds_connector as rti
import random
import struct
import math

connector = rti.Connector("MyParticipantLibrary::Zero", filepath + "/ros-types-all.xml")
lidarOut = connector.getOutput("ddsPointCloud2Pub::ddsPointCloud2Writer")
# DDsetOctetArray = rti.connector_binding.library.DDS_DynamicData_set_octet_array

h = 2

# set up the unchanging parts of the DDS data
lidarOut.instance.setDictionary({
    "point_step": 16,
    "is_bigendian": False,
    "is_dense": True,
    "header.frame_id": "map",
    "fields[0].name": "x",
    "fields[0].offset": 0,
    "fields[0].datatype": 7,
    "fields[0].count": 1,
    "fields[1].name": "y",
    "fields[1].offset": 4,
    "fields[1].datatype": 7,
    "fields[1].count": 1,
    "fields[2].name": "z",
    "fields[2].offset": 8,
    "fields[2].datatype": 7,
    "fields[2].count": 1,
    "fields[3].name": "rgb",
    "fields[3].offset": 12,
    "fields[3].datatype": 7,
    "fields[3].count": 1
})

# size of the LiDAR array
rowCnt = 20
colCnt = 20
pointCount = rowCnt * colCnt

# these vars are needed to do the fast-write of array data to DDS
inArrayType = ctypes.c_byte * (pointCount * 16)
inArray = inArrayType()

#dynamicDataNativePointer = lidarOut.instance.native
#arrayLength = c_ulong(pointCount * 16)
#memberName = "data"
#memberId = 0
rgbcolor = 0xCCBB88

# convert from cartesian(X,Y,Z) to spherical(rad, pol, azi)
def cart2rpa(cx, cy, cz):
    rad = math.sqrt(cx**2 + cy**2 + cz**2)
    pol = math.acos(cz/rad)
    azi = math.atan2(cy, cx)
    return rad, pol, azi

# convert from spherical(rad, pol, azi) to cartesian(X,Y,Z)
def rpa2cart(rad, pol, azi):
    cx = rad * math.sin(pol) * math.cos(azi)
    cy = rad * math.sin(pol) * math.sin(azi)
    cz = rad * math.cos(pol)
    return cx, cy, cz

# Have fun with the data points 
def pointModify(aPts, aLen):
    j=0
    for i in range(aLen):
        # convert to spherical
        rad, pol, azi = cart2rpa(aPts[j], aPts[j+1], aPts[j+2])

        # modify
        azi = azi + (0.15 * (1-(rad / 10)))
        
        # convert back to cartesian
        aPts[j], aPts[j+1], aPts[j+2] = rpa2cart(rad, pol, azi)
                      
        j = j+4
    return aPts

# init the 3d area with random points & colors
rPts = list()
for j in range(rowCnt*colCnt):
    rPts.append(random.uniform(-5, 5))  # x
    rPts.append(random.uniform(-5, 5))  # y
    rPts.append(random.uniform( 0, 10)) # z
    # for reference: 3 favorite colors are 0x807e82, 0x004c97, 0xed8b00
#    cPick = random.uniform(0, 10)
#    if cPick < 3:
#      tColor = 0x807e82
#    elif cPick < 6:
#      tColor = 0x004c97
#    else:
#      tColor = 0xed8b00
    tColor = (int(random.uniform(35, 255)) * 65536) + (int(random.uniform(35, 255)) * 256) + int(random.uniform(35, 255))
    rPts.append(tColor)

# main loop -----------------------------------
for i in range(1, 100000):
    tStamp = time.time()
    lidarOut.instance.setNumber("header.stamp.sec", int(tStamp))
    lidarOut.instance.setNumber("header.stamp.nanosec", ((tStamp % 1) * 1000000000))
    lidarOut.instance.setDictionary({"height": rowCnt, "width": colCnt, "row_step": 16*colCnt})
    
    # Modify the points in the display
    rPts = pointModify(rPts, (rowCnt*colCnt))
    
    # pack into struct
    dp = 0
    rs = 0
    for de in range(rowCnt*colCnt):
        struct.pack_into('fffI', inArray, (dp),
                             rPts[rs],    # x
                             rPts[rs+1],  # y
                             rPts[rs+2],  # z
                             rPts[rs+3])  # color (RGB)
        dp = dp + 16
        rs = rs + 4
      
    # (Windows only): copy into list for sending
    lidarOut.instance["data"] = [x for x in inArray]
    
    lidarOut.write()
    time.sleep(0.07)
